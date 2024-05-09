-- Ти пробував додати виклик з роботи буса на додавання хр за нпс.

local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('checkplayerlvlbyUI')
AddEventHandler('checkplayerlvlbyUI', function()
    -- Тут ми можемо створити статичні дані для рівня гравця
    local playerLevel = 5 -- Наприклад, рівень гравця 5
    local playerExperience = 500 -- Наприклад, досвід гравця 500

    -- Створюємо об'єкт з даними про рівень та досвід гравця
    local playerData = {
        level = playerLevel,
        experience = playerExperience
    }

    -- Відправляємо дані клієнту через NUI
    TriggerClientEvent('updatePlayerLevelUI', source, playerData)
end)




RegisterCommand("lvlcheck", function(source, args, rawCommand)
    local src = source

    -- Функція для отримання ідентифікатора гравця
    local function getPlayerIdentifier(player)
        return QBCore.Functions.GetIdentifier(player, 'license')
    end

    -- Отримання ідентифікатора гравця
    local identifier = getPlayerIdentifier(src)

    -- Перевірка наявності ідентифікатора
    if identifier then
        -- Виконання запиту до бази даних для отримання інформації про гравця
        exports.oxmysql:execute('SELECT * FROM marko_leveling WHERE identifier = ?', {identifier}, function(result)
            if result[1] then
                -- Якщо гравець знайдений в базі даних, виводимо інформацію
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

                -- Можна також відправити інформацію гравцю через повідомлення в гру
                TriggerClientEvent('lvlcheck:result', src, playerData)
            else
                -- Якщо гравець не знайдений в базі даних
                if Config.DebugMode then
                    print("Player data not found in the database.")
                end
            end
        end)
    else
        if Config.DebugMode then
            print("Unable to get your identifier.")
        end
        return
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
    -- Виведення інформації про подію, якщо ввімкнено режим налагодження
    if Config.DebugMode then
        print(Config.Lang["DebugMessages"]["EventAddPlayerExperienceTriggered"]:format(src))
        print(Config.Lang["DebugMessages"]["AddingExperienceToColumn"]:format(columnName))
        print(Config.Lang["DebugMessages"]["AmountOfExperienceToAdd"]:format(amount))
    end
    
    -- Отримання ідентифікатора гравця
    local identifier = QBCore.Functions.GetIdentifier(src, 'license')
    print(Config.Lang["DebugMessages"]["AddPlayerExperiencePlayerIdentifier"]:format(identifier))

    if identifier then
        -- Додавання досвіду гравцю
        addExperience(identifier, columnName, amount)
    else
        -- Виведення повідомлення про неможливість отримання ідентифікатора гравця, якщо ввімкено режим налагодження
        if Config.DebugMode then
            print(Config.Lang["DebugMessages"]["AddPlayerExperienceUnableToGetIdentifier"]:format(src))
        end
    end
end)




RegisterServerEvent('requestDataFromServer')
AddEventHandler('requestDataFromServer', function(playerId)
    local src = source  -- Зберігаємо source, який є ідентифікатором гравця у вашій сесії сервера
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        local identifier = xPlayer.PlayerData.license
        local firstName = xPlayer.PlayerData.charinfo.firstname
        local lastName = xPlayer.PlayerData.charinfo.lastname
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
    local identifier = QBCore.Functions.GetIdentifier(src, 'license') -- Отримання ідентифікатора гравця
    if identifier then
        -- Перевірка чи гравець є в базі даних
        exports.oxmysql:execute('SELECT * FROM marko_leveling WHERE `identifier` = ?', {identifier}, function(rows)
            if not rows[1] then
                -- Гравець відсутній в базі даних, додаємо його зі значеннями за замовчуванням
                exports.oxmysql:execute('INSERT INTO marko_leveling (identifier, busdriver_xp, busdriver_lvl, lumberjack_xp, lumberjack_lvl, gruppe_xp, gruppe_lvl, deliveryman_xp, deliveryman_lvl, postman_xp, postman_lvl, player_xp, player_lvl, player_playtime, medic_xp, medic_lvl, toolbox_xp, toolbox_lvl, carreturn_xp, carreturn_lvl, carjack_xp, carjack_lvl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {identifier, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, function(rows)
                    if Config.DebugMode then
                        print(Config.Lang["DebugMessages"]["AddedNewPlayerToDatabase"]:format(identifier))
                    end
                end)
            end
        end)
    else
        -- Якщо не вдалося отримати ідентифікатор, відхиляємо підключення
        deferrals.done(Config.Lang["DebugMessages"]["UnableToRetrievePlayerIdentifier"])
    end
end)



-- Винагородження гравця.
RegisterServerEvent('RewardPlayer')
AddEventHandler('RewardPlayer', function(src, itemID, itemQuantity, lvlColumn, moneyTrigger)
    if Config.DebugMode then
        print(Config.Lang["DebugMessages"]["ReceivedRewardPlayer"]:format(src))
    end
    
    local identifier = QBCore.Functions.GetIdentifier(src, 'license')
    if identifier then
        exports.oxmysql:execute('SELECT ?? FROM marko_leveling WHERE `identifier` = ?', {lvlColumn, identifier}, function(rows)
            if rows[1] then
                local playerLevel = rows[1][lvlColumn]
                if Config.DebugMode then
                    print(Config.Lang["DebugMessages"]["PlayerLevelForPlayer"]:format(src, playerLevel))
                end
                
                local xPlayer = QBCore.Functions.GetPlayer(src)
                
                -- Отримання кількості грошей відповідно до рівня гравця, якщо гроші активовані
                local moneyAmount = 0
                if moneyTrigger == 'true' then
                    moneyAmount = Config.Reward[lvlColumn][playerLevel]
                end
                
                -- Логіка нагородження гравця
                if moneyAmount > 0 then
                    xPlayer.Functions.AddMoney('bank', moneyAmount)
                    if Config.DebugMode then
                        print(Config.Lang["DebugMessages"]["AddedMoneyToPlayer"]:format(moneyAmount, src))
                    end
                end
                
                if itemID and itemQuantity and itemID ~= "none" then
                    xPlayer.Functions.AddItem(itemID, itemQuantity)
                    if Config.DebugMode then
                        print(Config.Lang["DebugMessages"]["AddedItemToPlayer"]:format(itemID, itemQuantity, src))
                    end
                end

                Citizen.Wait(1000) -- Затримка в 10 секунд (7000 мілісекунд)
                -- Нотифікація гравця
                if Config.NotificationType == "qb" then
                    if moneyAmount > 0 and itemID and itemQuantity and itemID ~= "none" then
                        TriggerClientEvent('QBCore:Notify', src, Config.Lang["RewardMessages"]["ReceivedMoneyAndItem"]:format(moneyAmount, itemQuantity, itemID), 'success')
                    elseif moneyAmount > 0 then
                        TriggerClientEvent('QBCore:Notify', src, Config.Lang["RewardMessages"]["ReceivedMoney"]:format(moneyAmount), 'success')
                    elseif itemID and itemQuantity and itemID ~= "none" then
                        TriggerClientEvent('QBCore:Notify', src, Config.Lang["RewardMessages"]["ReceivedItem"]:format(itemQuantity, itemID), 'success')
                    end
                elseif Config.NotificationType == "17mov" then
                    local msg
                    if moneyAmount > 0 and itemID and itemQuantity and itemID ~= "none" then
                        msg = Config.Lang["RewardMessages"]["ReceivedMoneyAndItem"]:format(moneyAmount, itemQuantity, itemID)
                    elseif moneyAmount > 0 then
                        msg = Config.Lang["RewardMessages"]["ReceivedMoney"]:format(moneyAmount)
                    elseif itemID and itemQuantity and itemID ~= "none" then
                        msg = Config.Lang["RewardMessages"]["ReceivedItem"]:format(itemQuantity, itemID)
                    end
                    RegisterNetEvent('17mov_DrawDefaultNotification'..GetCurrentResourceName(), function(msg)
                        Notify(msg)
                    end)
                    TriggerClientEvent("17mov_DrawDefaultNotification"..GetCurrentResourceName(), src, msg)
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




-- Функція для оновлення рівня гравця

RegisterServerEvent('marko_busjob:server:UpdatePlayerLevel')
AddEventHandler('marko_busjob:server:UpdatePlayerLevel', function()
    local src = source
    UpdatePlayerLevel(src)
end)



