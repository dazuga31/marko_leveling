local ESX, QBCore = nil, nil

if Config.FrameWork == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.FrameWork == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end


RegisterServerEvent('checkplayerlvlbyUI')
AddEventHandler('checkplayerlvlbyUI', function()
    local playerLevel = 5 -- Наприклад, рівень гравця 5
    local playerExperience = 500 -- Наприклад, досвід гравця 500
    local playerData = {
        level = playerLevel,
        experience = playerExperience
    }

    TriggerClientEvent('updatePlayerLevelUI', source, playerData)
end)


RegisterCommand("lvlcheck", function(source, args, rawCommand)
    local identifier = nil
    if Config.FrameWork == 'ESX' then
        local identifiers = GetPlayerIdentifiers(source)
        -- Перебираємо ідентифікатори гравця, щоб знайти потрібний
        for _, id in ipairs(identifiers) do
            if string.match(id, "license") then
                identifier = id
                break
            end
        end
    elseif Config.FrameWork == 'QB' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        identifier = xPlayer.PlayerData.license
    end

    if identifier then
        exports.oxmysql:execute('SELECT * FROM marko_leveling WHERE identifier = ?', {identifier}, function(result)
            if result[1] then
                local playerData = result[1]
                if Config.DebugMode then
                    print("Player data found:")
                    print("Identifier:", playerData.identifier)
                    print("Citizen ID:", playerData.citizenid)
                    print("Bus Driver XP:", playerData.busdriver_xp)
                    print("Bus Driver Level:", playerData.busdriver_lvl)
                    print("Lumberjack XP:", playerData.lumberjack_xp)
                    print("Lumberjack Level:", playerData.lumberjack_lvl)
                    print("Gruppe XP:", playerData.gruppe_xp)
                    print("Gruppe Level:", playerData.gruppe_lvl)
                    print("Deliveryman XP:", playerData.deliveryman_xp)
                    print("Deliveryman Level:", playerData.deliveryman_lvl)
                    print("Postman XP:", playerData.postman_xp)
                    print("Postman Level:", playerData.postman_lvl)
                    print("Player XP:", playerData.player_xp)
                    print("Player Level:", playerData.player_lvl)
                    print("Player Playtime:", playerData.player_playtime)
                end
                TriggerClientEvent('lvlcheck:result', source, playerData)
            else
                if Config.DebugMode then
                    print("Player data not found in the database.")
                end
                TriggerClientEvent('lvlcheck:error', source, "No player data found.")
            end
        end)
    else
        if Config.DebugMode then
            print("Unable to get your identifier.")
        end
        TriggerClientEvent('lvlcheck:error', source, "Unable to get your identifier.")
    end
end)



local function addExperience(identifier, columnName, amount)
    if not identifier then
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["NoIdentifier"])
        end
        return
    end

    local role = columnName:gsub("_xp", "")  -- Визначаємо роль з назви колонки
    local levelColumn = Config.LevelColumns[role] and Config.LevelColumns[role].lvl or nil
    local playerXPColumn = 'player_xp'  -- Назва колонки для загального досвіду гравця

    if not levelColumn then
        if Config.DebugMode then
            print(string.format(Config.Lang["DebugMessages"]["NoLevelColumn"], columnName))
        end
        return
    end

    if Config.DebugMode then
        print(string.format(Config.Lang["DebugMessages"]["InitiatingXPUpdate"], columnName))
    end

    -- Вибірка поточних значень досвіду та рівня
    exports.oxmysql:execute('SELECT `' .. columnName .. '`, `' .. levelColumn .. '`, `' .. playerXPColumn .. '` FROM marko_leveling WHERE `identifier` = ?', {identifier}, function(rows)
        if rows and rows[1] then
            local currentXP = rows[1][columnName] or 0
            local currentLevel = rows[1][levelColumn] or 0
            local currentPlayerXP = rows[1][playerXPColumn] or 0
            local newXP = currentXP + amount
            local newPlayerXP = currentPlayerXP + 1  -- Збільшення player_xp на 1

            if Config.DebugMode then
                print(string.format(Config.Lang["DebugMessages"]["CurrentAndNewXP"], currentXP, newXP))
            end

            -- Оновлення досвіду для специфічної ролі та player_xp
            exports.oxmysql:execute('UPDATE marko_leveling SET `' .. columnName .. '` = ?, `' .. playerXPColumn .. '` = ? WHERE `identifier` = ?', {newXP, newPlayerXP, identifier}, function(result)
                if result.affectedRows > 0 then
                    if Config.DebugMode then
                        print(string.format(Config.Lang["DebugMessages"]["XPUpdateSuccess"], columnName))
                    end

                    -- Перевірка та оновлення рівня
                    local levels = Config.Levels[role .. "_lvl"]
                    local newLevel = currentLevel
                    for level, xpRequired in ipairs(levels) do
                        if newXP >= xpRequired then
                            newLevel = level
                        end
                    end

                    -- Врахування випадку, коли досвід впав нижче поточного рівня
                    if newXP < (levels[currentLevel] or 0) then
                        newLevel = 0 -- Знайти мінімальний рівень, що відповідає досвіду
                        for level, xpRequired in ipairs(levels) do
                            if newXP >= xpRequired then
                                newLevel = level
                            else
                                break
                            end
                        end
                    end

                    if newLevel ~= currentLevel then
                        if Config.DebugMode then
                            print(string.format(Config.Lang["DebugMessages"]["LevelChange"], currentLevel, newLevel))
                        end
                        exports.oxmysql:execute('UPDATE marko_leveling SET `' .. levelColumn .. '` = ? WHERE `identifier` = ?', {newLevel, identifier}, function(updateResult)
                            if updateResult.affectedRows > 0 then
                                if Config.DebugMode then
                                    print(string.format(Config.Lang["DebugMessages"]["LevelUpdateSuccess"], newLevel))
                                end
                            else
                                if Config.DebugMode then
                                    print(Config.Lang["DebugMessages"]["FailedToUpdateLevel"])
                                end
                            end
                        end)
                    end
                else
                    if Config.DebugMode then
                        print(Config.Lang["DebugMessages"]["FailedToUpdateXP"])
                    end
                end
            end)
        else
            if Config.DebugMode then
                print(string.format(Config.Lang["DebugMessages"]["FailedToGetCurrentValues"], columnName))
            end
        end
    end)
end





-- Функція для отримання рівня гравця за певною роллю
function getPlayerLevel(identifier, role, callback)
    if not identifier or not role then
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["InvalidArgumentsToGetPlayerLevelFunction"])
        end
        return
    end

    local levelColumn = Config.LevelColumns[role] and Config.LevelColumns[role].lvl or nil
    if not levelColumn then
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["NoLevelColumnConfigurationFoundForRole"]:format(role))
        end
        return
    end

    exports.oxmysql:execute('SELECT `' .. levelColumn .. '` FROM marko_leveling WHERE `identifier` = ?', {identifier}, function(rows)
        if rows and rows[1] then
            local playerLevel = rows[1][levelColumn] or 0
            if Config.DebugMode then
                print(Config.Lang["DebugMessages"]["LevelForRoleIs"]:format(role, playerLevel))
            end
            if callback then
                callback(playerLevel)
            end
        else
            if Config.DebugMode then
                print(Config.Lang["DebugMessages"]["FailedToFetchLevelForRole"]:format(role))
            end
            if callback then
                callback(nil)
            end
        end
    end)
end




-- Обробник події для отримання рівня
AddEventHandler('marko_leveling:getPlayerLevel', function(identifier, role, callback)
    local levelColumn = Config.LevelColumns[role] and Config.LevelColumns[role].lvl
    if not levelColumn then
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["NoLevelColumnConfigurationFoundForRole"]:format(role))
        end
        if callback then callback(nil) end
        return
    end

    -- Виконання запиту до бази даних
    exports.oxmysql:execute('SELECT `' .. levelColumn .. '` FROM marko_leveling WHERE `identifier` = ?', {identifier}, function(rows)
        if not rows or #rows == 0 then
            if Config.DebugMode then
                print(Config.Lang["DebugMessages"]["NoRecordsFoundForIdentifier"]:format(identifier, role))
            end
            if callback then callback(nil) end
            return
        end

        local playerLevel = rows[1][levelColumn] or 0
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["RetrievedLevel"]:format(identifier, role, playerLevel))
        end
        if callback then callback(playerLevel) end
    end)
end)






-- Реєстрація серверної події для додавання досвіду гравцю
RegisterServerEvent('addPlayerExperience')
AddEventHandler('addPlayerExperience', function(columnName, amount, src)
    if Config.DebugMode then
        print(Config.Lang["DebugMessages"]["EventAddPlayerExperienceTriggered"]:format(src))
        print(Config.Lang["DebugMessages"]["AddingExperienceToColumn"]:format(columnName))
        print(Config.Lang["DebugMessages"]["AmountOfExperienceToAdd"]:format(amount))
    end

    local identifier = nil
    if Config.FrameWork == 'ESX' then
        local identifiers = GetPlayerIdentifiers(src)
        -- Перебираємо ідентифікатори гравця, щоб знайти потрібний
        for _, id in ipairs(identifiers) do
            if string.match(id, "license") then
                identifier = id
                break
            end
        end
    elseif Config.FrameWork == 'QB' then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        identifier = xPlayer.PlayerData.license
    end

    if identifier then
        -- Додавання досвіду гравцю
        addExperience(identifier, columnName, amount)
    else
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["AddPlayerExperienceUnableToGetIdentifier"]:format(src))
        end
    end
end)







RegisterServerEvent('requestDataFromServer')
AddEventHandler('requestDataFromServer', function(playerId)
    local src = source  -- Зберігаємо source, який є ідентифікатором гравця у вашій сесії сервера
    local identifier, firstName, lastName

    if Config.FrameWork == 'ESX' then
        local identifiers = GetPlayerIdentifiers(src)
        -- Перебираємо ідентифікатори гравця, щоб знайти потрібний
        for _, id in ipairs(identifiers) do
            if string.match(id, "license") then
                identifier = id
                break
            end
        end
        if identifier then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                firstName = xPlayer.get('firstName')
                lastName = xPlayer.get('lastName')
            end
        end
    elseif Config.FrameWork == 'QB' then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer then
            identifier = xPlayer.PlayerData.license
            firstName = xPlayer.PlayerData.charinfo.firstname
            lastName = xPlayer.PlayerData.charinfo.lastname
        end
    end

    if identifier then
        local query = "SELECT * FROM marko_leveling WHERE identifier = ?"
        exports.oxmysql:execute(query, {identifier}, function(results)
            if results and #results > 0 then
                local data = results[1]
                data.fullName = firstName .. " " .. lastName  -- Додаємо ім'я та прізвище до даних
                TriggerClientEvent('receiveDataFromServer', src, data)
            else
                TriggerClientEvent('receiveDataFromServer', src, { error = "No data found" })
            end
        end)
    else
        TriggerClientEvent('receiveDataFromServer', src, { error = "Player not found" })
    end
end)








AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local identifier = nil

    for _, id in ipairs(identifiers) do
        if string.match(id, "license") then
            identifier = id
            break
        end
    end

    if identifier then
        exports.oxmysql:execute('SELECT * FROM marko_leveling WHERE `identifier` = ?', {identifier}, function(rows)
            if not rows[1] then
                local queryData = {identifier, table.unpack(Config.PlayerDefaultData.defaultValues)}
                exports.oxmysql:execute('INSERT INTO marko_leveling (' .. Config.PlayerDefaultData.columns .. ') VALUES (' .. Config.PlayerDefaultData.values .. ')', queryData, function(result)
                    if Config.DebugMode then
                        print(Config.Lang["DebugMessages"]["AddedNewPlayerToDatabase"]:format(identifier))
                    end
                end)
            end
        end)
    else
        deferrals.done(Config.Lang["DebugMessages"]["UnableToRetrievePlayerIdentifier"])
    end
end)



function split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end




-- Винагородження гравця.
RegisterServerEvent('RewardPlayer')
AddEventHandler('RewardPlayer', function(src, itemID, itemQuantity, lvlColumn, moneyTrigger)
    if Config.DebugMode then
        print(Config.Lang["DebugMessages"]["ReceivedRewardPlayer"]:format(src))
    end

    local identifier = nil
    local xPlayer = nil

    -- Отримання ідентифікатора гравця та xPlayer відповідно до фреймворку
    if Config.FrameWork == 'ESX' then
        local identifiers = GetPlayerIdentifiers(src)
        -- Перебираємо ідентифікатори гравця, щоб знайти потрібний
        for _, id in ipairs(identifiers) do
            if string.match(id, "license") then
                identifier = id
                break
            end
        end
        if identifier then
            xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        end
    elseif Config.FrameWork == 'QB' then
        xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer then
            identifier = xPlayer.PlayerData.license
        end
    end

    if identifier then
        exports.oxmysql:execute('SELECT ?? FROM marko_leveling WHERE `identifier` = ?', {lvlColumn, identifier}, function(rows)
            if rows[1] then
                local playerLevel = rows[1][lvlColumn]
                if Config.DebugMode then
                    print(Config.Lang["DebugMessages"]["PlayerLevelForPlayer"]:format(src, playerLevel))
                end
                
                -- Отримання кількості грошей відповідно до рівня гравця, якщо гроші активовані
                local moneyAmount = 0
                if moneyTrigger == 'true' then
                    moneyAmount = Config.Reward[lvlColumn][playerLevel]
                end

                -- Логіка нагородження гравця
                GivePlayerRewardMoney(src, moneyAmount, Config.FrameWork)

                if itemID and itemQuantity and itemID ~= "none" then
                    xPlayer.addInventoryItem(itemID, itemQuantity)
                    if Config.DebugMode then
                        print(Config.Lang["DebugMessages"]["AddedItemToPlayer"]:format(itemID, itemQuantity, src))
                    end
                end

                -- Нотифікація гравця
                if Config.NotificationType == "qb" then
                    TriggerClientEvent('QBCore:Notify', src, Config.Lang["RewardMessages"]["ReceivedMoneyAndItem"]:format(moneyAmount, itemQuantity, itemID), 'success')
                elseif Config.NotificationType == "esx" then
                    xPlayer.showNotification(Config.Lang["RewardMessages"]["ReceivedMoneyAndItem"]:format(moneyAmount, itemQuantity, itemID))
                elseif Config.NotificationType == "17mov" then
                    TriggerClientEvent("17mov_DrawDefaultNotification"..GetCurrentResourceName(), src, Config.Lang["RewardMessages"]["ReceivedMoneyAndItem"]:format(moneyAmount, itemQuantity, itemID))
                end
            else
                if Config.DebugMode then
                    print(Config.Lang["DebugMessages"]["FailedToGetPlayerLevel"]:format(src))
                end
            end
        end)
    else
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["UnableToGetIdentifier"]:format(src))
        end
    end
end)


function GivePlayerRewardMoney(src, amount, framework)
    if amount <= 0 then
        if Config.DebugMode then
            print("GivePlayerRewardMoney: Amount is less than or equal to zero. Check that the amount is correctly calculated and passed.")
        end
        return
    end

    local xPlayer = nil
    if framework == 'ESX' then
        xPlayer = ESX.GetPlayerFromId(src)
    elseif framework == 'QB' then
        xPlayer = QBCore.Functions.GetPlayer(src)
    end

    if not xPlayer then
        if Config.DebugMode then
            print("GivePlayerRewardMoney: Failed to retrieve xPlayer for source " .. src)
        end
        return
    end

    if Config.DebugMode then
        print("Attempting to add money: " .. amount .. " to player's bank in framework: " .. framework)
    end

    if framework == 'ESX' then
        xPlayer.addAccountMoney('bank', amount)
        if Config.DebugMode then
            print("Money added using ESX framework for player: " .. src)
        end
    elseif framework == 'QB' then
        xPlayer.Functions.AddMoney('bank', amount)
        if Config.DebugMode then
            print("Money added using QBCore framework for player: " .. src)
        end
    else
        print("GivePlayerRewardMoney: Unsupported framework specified: " .. tostring(framework))
    end
end



-- Функція для оновлення рівня гравця

RegisterServerEvent('marko_busjob:server:UpdatePlayerLevel')
AddEventHandler('marko_busjob:server:UpdatePlayerLevel', function()
    local src = source
    UpdatePlayerLevel(src)
end)
