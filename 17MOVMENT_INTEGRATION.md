### Integration in 17Movment

#### Module `17mov_Deliverer`

The `17mov_Deliverer` module allows you to integrate additional logic into the delivery system, providing players with experience for delivering parcels, as well as tracking the number of parcels delivered.

##### Update `server/functions.lua` in `17mov_Deliverer`

For integration, add the following code before the `Pay(source, amount)` function:

```lua
local ParcelDelivered = {}

RegisterNetEvent('17mov_deliverer:CreatePed')
AddEventHandler('17mov_deliverer:CreatePed', function(letterInfo)
    local src = source  -- Отримуємо source
    print("17mov_deliverer: Отримано інформацію про лист для гравця з ID:", source)
    -- Додавання досвіду за доставку
    TriggerEvent('addPlayerExperience', 'deliveryman_xp', 1, src)
    print("17mov_deliverer: Added deliveryman_xp to player with identifier:", src)

    -- Збільшення кількості доставлених посилок
    if not ParcelDelivered[src] then
        ParcelDelivered[src] = 1
    else
        ParcelDelivered[src] = ParcelDelivered[src] + 1
    end
end)

```

##### Replace `function Pay` with:

```lua

function Pay(source, amount)
    local itemsToGive = amount / Config.Price
    
    if Config.Framework == "QBCore" then
        local Player = Core.Functions.GetPlayer(source)
        if Player ~= nil and Player.Functions ~= nil then
            Player.Functions.AddMoney("cash", amount)

            -- Перевірка кількості зібраних листів
            if ParcelDelivered[source] and ParcelDelivered[source] >= 10 then
                -- Винагородження гравця
                TriggerEvent('RewardPlayer', source, "none", 1, 'deliveryman_lvl', 'true')
            else
                print("Гравець ще не відвіз достатньої кількості пакунків.", source)
            end

            for _, item in pairs(Config.RewardItemsToGive) do
                if math.random(100) <= item.chance then
                    Player.Functions.AddItem(item.item_name, math.floor(itemsToGive))
                end
            end
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = Core.GetPlayerFromId(source)
        if xPlayer ~= nil and xPlayer.addMoney ~= nil then
            xPlayer.addMoney(amount)

            -- Перевірка кількості зібраних листів
            if ParcelDelivered[source] and ParcelDelivered[source] >= 10 then
                -- Винагородження гравця
                TriggerEvent('RewardPlayer', source, "none", 1, 'deliveryman_lvl', 'true')
            else
                print("Гравець ще не відвіз достатньої кількості пакунків.")
            end

            for _, item in pairs(Config.RewardItemsToGive) do
                if math.random(100) <= item.chance then
                    xPlayer.addInventoryItem(item.item_name, math.floor(itemsToGive))
                end
            end
        end
    else
        -- Підтримка інших фреймворків
    end
end

```


#### Module `17mov_GruppeSechs`

The module `17mov_GruppeSechs` allows you to integrate additional logic into the collection worker system, to get experience for money delivered to ATMs/NPCs. Get extra rewards based on player level.

##### Update `server/functions.lua` in `17mov_GruppeSechs`

For integration, add the following code before the `Pay(source, amount)` function:

```lua

local MoneyPackDeliveredToNPC = {} -- Масив для зберігання кількості доставлених грошей для кожного гравця

RegisterNetEvent('17mov_GruppeSechs:DeliverThisAtm')
AddEventHandler('17mov_GruppeSechs:DeliverThisAtm', function(letterInfo)
    local src = source -- Отримуємо source
    print("17mov_GruppeSechs: Отримано інформацію про лист для гравця з ID:", source)
    TriggerEvent('addPlayerExperience', 'gruppe_xp', 1, src)
    print("17mov_GruppeSechs: Added gruppe_xp to player with identifier:", src)

    -- Збільшення кількості доставлених грошей
    if not MoneyPackDeliveredToNPC[src] then
        MoneyPackDeliveredToNPC[src] = 1
    else
        MoneyPackDeliveredToNPC[src] = MoneyPackDeliveredToNPC[src] + 1
    end
end)

```

##### Replace `function Pay` with:

```lua
function Pay(source, amount)
    if Config.Framework == "QBCore" then
        local Player = Core.Functions.GetPlayer(source)
        if Player ~= nil and Player.Functions ~= nil then
            Player.Functions.AddMoney("cash", amount)

            -- Перевірка кількості доставлених грошей
            if ParcelDelivered[source] and ParcelDelivered[source] >= 10 then
                -- Винагородження гравця
                TriggerEvent('RewardPlayer', source, "none", 1, 'gruppe_lvl', 'true')
            else
                print("Гравець ще не відвіз достатньої кількості пакунків.")
            end

            for _, item in pairs(Config.RewardItemsToGive) do
                if math.random(100) <= item.chance then
                    Player.Functions.AddItem(item.item_name, math.floor(itemsToGive))
                end
            end
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = Core.GetPlayerFromId(source)
        if xPlayer ~= nil and xPlayer.addMoney ~= nil then
            xPlayer.addMoney(amount)

            -- Перевірка кількості доставлених грошей
            if ParcelDelivered[source] and ParcelDelivered[source] >= 10 then
                -- Винагородження гравця
                TriggerEvent('RewardPlayer', source, "none", 1, 'gruppe_lvl', 'true')
            else
                print("Гравець ще не відвіз достатньої кількості пакунків.")
            end

            for _, item in pairs(Config.RewardItemsToGive) do
                if math.random(100) <= item.chance then
                    xPlayer.addInventoryItem(item.item_name, math.floor(itemsToGive))
                end
            end
        end
    else
  end
end

```
#### Module `17mov_Lumberjack`

The module `17mov_Lumberjack` allows you to integrate additional logic into the lumberjack system, providing the player with additional payment for the work performed based on his level.

##### Update `server/functions.lua` in `17mov_Lumberjack`

For integration, add the following code before the `Pay(source, amount)` function:

```lua

local ChoppedTreesCount = {} -- Масив для зберігання кількості відрубаних дерев для кожного гравця

RegisterNetEvent('17mov_Lumberjack:disableThisTree')
AddEventHandler('17mov_Lumberjack:disableThisTree', function(letterInfo)
    local src = source -- Отримуємо source
    print("17mov_Lumberjack: Отримано інформацію про лист для гравця з ID:", source)
    TriggerEvent('addPlayerExperience', 'lumberjack_xp', 1, src)
    print("17mov_Lumberjack: Added lumberjack_xp to player with identifier:", src)

    -- Збільшення кількості відрубаних дерев для гравця
    if not ChoppedTreesCount[src] then
        ChoppedTreesCount[src] = 1
    else
        ChoppedTreesCount[src] = ChoppedTreesCount[src] + 1
    end
end)

```
##### Add to `Config.lua` the line `Config.RequiredTreesForReward = 10 -- Marko Leveling sys` which is responsible for the minimum required number of trees cut down by the player to receive an additional reward.

##### Replace `function Pay` with:

```lua
function Pay(source, amount, logsItem, planksItems, chipsItems, lobbySize)
    if Config.Framework == "QBCore" then
        local Player = Core.Functions.GetPlayer(source)
        if Player ~= nil and Player.Functions ~= nil then
            Player.Functions.AddMoney("cash", amount)
        end

        for itemName, count in pairs(logsItem) do
            if count >= 1 then
                Player.Functions.AddItem(itemName, count)
            end
        end

        for itemName, count in pairs(planksItems) do
            if count >= 1 then
                Player.Functions.AddItem(itemName, count)
            end
        end

        for itemName, count in pairs(chipsItems) do
            if count >= 1 then
                Player.Functions.AddItem(itemName, count)
            end
        end

        -- Винагородження гравця залежно від кількості відрубаних дерев
        if ChoppedTreesCount[source] and ChoppedTreesCount[source] >= Config.RequiredTreesForReward then

            -- Винагородження гравця
            TriggerEvent('RewardPlayer', source, "none", 1, 'medic_lvl', 'true')
        else
            print("Гравець ще не відрубав достатню кількість дерев.")
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = Core.GetPlayerFromId(source)
        if xPlayer ~= nil and xPlayer.addMoney ~= nil then
            xPlayer.addMoney(amount)
        end

        for itemName, count in pairs(logsItem) do
            if count >= 1 then
                xPlayer.addInventoryItem(itemName, count)
            end
        end

        for itemName, count in pairs(planksItems) do
            if count >= 1 then
                xPlayer.addInventoryItem(itemName, count)
            end
        end

        for itemName, count in pairs(chipsItems) do
            if count >= 1 then
                xPlayer.addInventoryItem(itemName, count)
            end
        end

        -- Винагородження гравця залежно від кількості відрубаних дерев
        if ChoppedTreesCount[source] and ChoppedTreesCount[source] >= Config.RequiredTreesForReward then
            -- Винагородження гравця
            TriggerEvent('RewardPlayer', source, "none", 1, 'medic_lvl', 'true')
        else
            print("Гравець ще не відрубав достатню кількість дерев.")
        end
    else
        -- Configure here ur payment
    end
end

```

#### Module `17mov_Postman`

The `17mov_Postman` module allows you to integrate additional logic into the postman system, allowing you to get an additional reward after 10+ collected letters. The reward depends on the level of the player.

##### Update `server/functions.lua` in `17mov_Postman`

For integration, add the following code before the `Pay(source, amount)` function:
```lua

local PlayerCollectedLetter = {} -- Масив для зберігання кількості зібраних листів для кожного гравця

RegisterNetEvent('17mov_postman:collectLetter')
AddEventHandler('17mov_postman:collectLetter', function(letterInfo)
    local src = source -- Отримуємо source
    print("17mov_postman: Отримано інформацію про лист для гравця з ID:", source)

    -- Виведення поточної кількості зібраних листів для гравця
    if PlayerCollectedLetter[src] then
        print("17mov_postman: Поточна кількість зібраних листів для гравця з ID " .. src .. ":", PlayerCollectedLetter[src])
    else
        print("17mov_postman: Поточна кількість зібраних листів для гравця з ID " .. src .. ": 0")
    end

    TriggerEvent('addPlayerExperience', 'postman_xp', 1, src)
    print("17mov_postman: Added collectLetter experience to player with identifier:", src)

    -- Збільшення кількості зібраних листів для гравця
    if not PlayerCollectedLetter[src] then
        PlayerCollectedLetter[src] = 1
    else
        PlayerCollectedLetter[src] = PlayerCollectedLetter[src] + 1
    end
end)

```

##### Replace `function Pay` with:

```lua
function Pay(source, amount)
    local itemsToGive = amount / Config.Price
    
    if Config.Framework == "QBCore" then
        local Player = Core.Functions.GetPlayer(source)
        if Player ~= nil and Player.Functions ~= nil then
            Player.Functions.AddMoney("cash", amount)

            -- Перевірка кількості зібраних листів
            if PlayerCollectedLetter[source] and PlayerCollectedLetter[source] >= 10 then
                -- Винагородження гравця
                TriggerEvent('RewardPlayer', source, "none", 1, 'postman_lvl', 'true')
            else
                print("Гравець ще не зібрав достатню кількість листів.")
            end

            for _, item in pairs(Config.RewardItemsToGive) do
                if math.random(100) <= item.chance then
                    if math.floor(itemsToGive * item.amountPerMailbox) >= 1 then
                        Player.Functions.AddItem(item.item_name, math.floor(itemsToGive * item.amountPerMailbox))
                    end
                end
            end
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = Core.GetPlayerFromId(source)
        if xPlayer ~= nil and xPlayer.addMoney ~= nil then
            xPlayer.addMoney(amount)

            -- Перевірка кількості зібраних листів
            if PlayerCollectedLetter[source] and PlayerCollectedLetter[source] >= 10 then
                -- Винагородження гравця
                TriggerEvent('RewardPlayer', source, "none", 1, 'postman_lvl', 'true')
            else
                print("Гравець ще не зібрав достатню кількість листів.")
            end

            for _, item in pairs(Config.RewardItemsToGive) do
                if math.random(100) <= item.chance then
                    if math.floor(itemsToGive * item.amountPerMailbox) >= 1 then
                        xPlayer.addInventoryItem(item.item_name, math.floor(itemsToGive * item.amountPerMailbox))
                    end
                end
            end
        end
    else
        -- Підтримка інших фреймворків
    end
end

```
#### Module `17mov_OilRig`

##### Add tihs line in Config.lua:
```lua
Config.MinGasProgressRequired = 5
```

##### Update `server/functions.lua` in `17mov_OilRig`

For integration, add the following code before the `Pay(source, amount)` function:
```lua

local PlayerGasProgress = {}

RegisterNetEvent('17mov_OilRig:UpdateGasProgress')
AddEventHandler('17mov_OilRig:UpdateGasProgress', function()
    local src = source -- Отримуємо source
    print("17mov_OilRig: Received PlayerGasProgress information for player ID:", src)
    TriggerEvent('addPlayerExperience', 'oilrig_xp', 1, src)
    print("17mov_OilRig: Added oilrig_xp to player with identifier:", src)

    if not PlayerGasProgress[src] then
        PlayerGasProgress[src] = 1
    else
        PlayerGasProgress[src] = PlayerGasProgress[src] + 1
    end
end)

```

##### Replace `function Pay` with:

```lua
function Pay(source, amount, gasProgress, tasksProgress, lobbySize)
    if Config.Framework == "QBCore" then
        local Player = Core.Functions.GetPlayer(source)
        if Player ~= nil and Player.Functions ~= nil then
            Player.Functions.AddMoney("cash", amount)

            if PlayerGasProgress[source] and PlayerGasProgress[source] >= Config.MinGasProgressRequired then
                -- Rewarding the player
                TriggerEvent('RewardPlayer', source, "none", 1, 'oilrig_lvl', 'true')
                print("OILRIG - Player has mined enough gas for additional reward.")
                Notify(source, "You have mined enough gas and received an additional reward!")
            else
                print("OILRIG - Player did not extract enough gas for additional reward.")
                Notify(source, "You have not collected enough gas for an additional reward.")
            end
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = Core.GetPlayerFromId(source)
        if xPlayer ~= nil and xPlayer.addMoney ~= nil then
            xPlayer.addMoney(amount)

            if PlayerGasProgress[source] and PlayerGasProgress[source] >= Config.MinGasProgressRequired then
                -- Rewarding the player
                TriggerEvent('RewardPlayer', source, "none", 1, 'oilrig_lvl', 'true')
                print("OILRIG - Player has mined enough gas for additional reward.")
                Notify(source, "You have mined enough gas and received an additional reward!")
            else
                print("OILRIG - Player did not extract enough gas for additional reward.")
                Notify(source, "You have not collected enough gas for an additional reward.")
            end
        end
    else
        -- Configure here your payment for other frameworks
        -- Debug message for missing configuration
        print("OILRIG - Warning: Config is not set. Add this line in Config.lua: Config.MinGasProgressRequired = 5")

        -- Notify the player about missing configuration
        Notify(source, "OILRIG - Warning: Config is not set. Add this line in Config.lua: Config.MinGasProgressRequired = 5")
    end

    -- Adding reward items based on gas progress
    local itemsToAdd = {}
    for i = 1, math.floor(gasProgress) do
        for k, item in pairs(Config.RewardItemsToGive) do
            if math.random(100) <= item.chance and gasProgress >= item.minimumGasProgressPercent then
                if itemsToAdd[item.itemName] == nil then
                    itemsToAdd[item.itemName] = 0
                end
                itemsToAdd[item.itemName] = itemsToAdd[item.itemName] + item.amountPerPercent
            end
        end
    end

    for k, v in pairs(itemsToAdd) do
        AddItem(source, k, math.floor(v))
    end
end

```


#### Module `17mov_Miner`

##### add tihs line in Config.lua:

```lua
Config.RequiredWallHits = 5
```

##### Update `server/functions.lua` in `17mov_Miner`

For integration, add the following code before the `Pay(source, amount)` function:
```lua

local PlayerHitMineWall = {}

RegisterNetEvent('17mov_Miner:WallHit')
AddEventHandler('17mov_Miner:WallHit', function()
    local src = source -- Отримуємо source
    print("17mov_Miner: Received PlayerHitMineWall information for player ID:", src)
    TriggerEvent('addPlayerExperience', 'miner_xp', 1, src)
    print("17mov_Miner: Added miner_xp to player with identifier:", src)

    if not PlayerHitMineWall[src] then
        PlayerHitMineWall[src] = 1
    else
        PlayerHitMineWall[src] = PlayerHitMineWall[src] + 1
    end
end)

```

##### Replace `function Pay` with:

```lua
function Pay(source, amount, lobbySize, rawProgress)
    local percent = math.floor(amount / Config.OnePercentWorth)

    if Config.Framework == "QBCore" then
        local Player = Core.Functions.GetPlayer(source)
        if Player ~= nil and Player.Functions ~= nil then
            Player.Functions.AddMoney("cash", amount)
        end
    elseif Config.Framework == "ESX" then
        local xPlayer = Core.GetPlayerFromId(source)
        if xPlayer ~= nil and xPlayer.addMoney ~= nil then
            xPlayer.addMoney(amount)
        end
    else
        -- Configure your payment here
    end

    -- Adding reward items
    local itemsToAdd = {}

    for i = 1, percent do
        for k, item in pairs(Config.RewardItemsToGive) do
            if math.random(100) <= item.chance and percent >= item.minimumProgressPercent then
                if itemsToAdd[item.itemName] == nil then
                    itemsToAdd[item.itemName] = 0
                end

                itemsToAdd[item.itemName] = itemsToAdd[item.itemName] +  item.amountPerPercent
            end
        end
    end

    for k, v in pairs(itemsToAdd) do
        AddItem(source, k, v)
    end

    if Config.RequiredWallHits then
        if PlayerHitMineWall[source] and PlayerHitMineWall[source] >= Config.RequiredWallHits then
            -- Rewarding the player for reaching the required wall collision count
            TriggerEvent('RewardPlayer', source, "none", 1, 'miner_lvl', 'true')

            -- Notifying the player about the reward
            Notify(source, "You have received a reward for reaching the required number of wall collisions.")
        else
            -- Printing a message for insufficient wall collision count
            print("The player has not hit wall enough times.")

            -- Notifying the player about insufficient wall collision count
            Notify(source, "You do not have enough hit wall to receive the reward.")
        end
    else
        -- Printing a message for the absence of RequiredWallHits configuration
        print("Warning: Config.RequiredWallHits is not set.")

        -- Notifying the player about the absence of RequiredWallHits configuration
        Notify(source, "Warning: Config.RequiredWallHits is not set.")
    end

    -- Debug messages
    print("17mov_Miner: Paid player:", source, "Amount:", amount, "Lobby Size:", lobbySize, "Raw Progress:", rawProgress)
end

function Notify(source, msg)
    if Config.UseBuiltInNotifications then
        TriggerClientEvent("17mov_DrawDefaultNotification" .. GetCurrentResourceName(), source, msg)
    else
        if Config.Framework == "QBCore" then
            TriggerClientEvent("QBCore:Notify", source, msg)
        elseif Config.Framework == "ESX" then
            TriggerClientEvent("esx:showNotification", source, msg)
        else
            TriggerClientEvent("17mov_DrawDefaultNotification" .. GetCurrentResourceName(), source, msg)
        end
    end
end


```
