# Marko Leveling

Рівнева система яка позволяє отримувати досвід та здобувати рівні навичок.
Скрипт легко імплеминтується в будьякий інший скрипт, тому він чудово підійде для новачків які мають не вилику кількість знань в програмуванні.

## Початок роботи

Перед початком установки впевніться що у вас встановлена актуальна версія FiveM, QBcore, OxLib - Посилання на них ви знайдете нище.

## Інсталяція та підготовка.

Що потрібно встановити спочатку:

1. Розпакуйте архів marko_leveling.rar в теку ваших ресурсів, видаліть приписку -master так щоб тека залишилась з назвою "marko_leveling".

2. Впевніться що у вас встановлено OX lib - Він потрібен для взаємодії з базою даних MySQL.

3. Відкрийти HeldiSQL (Або інший застосунок) та імпортуйте в вашу базу даних importDB.sql

4. додайте ensure marko_leveling до config.cfg вашого серверу.

5. Все скипт готовий до застосування.

Нище будуть наведені методи інтеграції рівневої системи в скрипти професій від [17Movement](https://discord.gg/wjZe8cKf)

### Інтеграція в 17Movment

#### Модуль `17mov_Deliverer`

Модуль `17mov_Deliverer` дозволяє інтегрувати додаткову логіку до системи доставки, надаючи гравцям досвід за доставку посилок, а також відстежувати кількість доставлених посилок.

##### Оновлення `server/functions.lua` в `17mov_Deliverer`

Для інтеграції додайте наступний код перед функцією `Pay(source, amount)`:

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

    -- Тригер події для оновлення завдань у батлпасі
    TriggerClientEvent('ak4y-battlepass:addtaskcount:standart', src, 15, 1)
end)

```

##### Замініть функцію `function Pay` на:

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


#### Модуль `17mov_GruppeSechs`

Модуль `17mov_GruppeSechs` дозволяє інтегрувати додаткову логіку до системи працівника інксації, отримувати досвід за доставлені до банкоматів/NPC гроші. Отримувати додаткову винагороду базуючись на рівні гравців.

##### Оновлення `server/functions.lua` в `17mov_GruppeSechs`

Для інтеграції додайте наступний код перед функцією `Pay(source, amount)`:

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

    TriggerClientEvent('ak4y-battlepass:addtaskcount:standart', src, 15, 1)
end)

```

##### Замініть функцію `function Pay` на:

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
        -- Підтримка інших фреймворків
    end
end

```

#### Модуль `17mov_Lumberjack`

Модуль `17mov_Lumberjack` дозволяє інтегрувати додаткову логіку до системи лісоруба, надавати гравцю додаткову оплату за виконану роботу базуючись на його рівні.

##### Оновлення `server/functions.lua` в `17mov_Lumberjack`

Для інтеграції додайте наступний код перед функцією `Pay(source, amount)`:

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

    TriggerClientEvent('ak4y-battlepass:addtaskcount:standart', src, 15, 1)
end)

```

##### Додайте до `Config.lua` рядок `Config.RequiredTreesForReward = 10 -- Marko Leveling sys` який відповідає за мінімальну необхідну кількість зрубаних дерев гравцем щоб отримати додаткову винагороду.

##### Замініть функцію `function Pay` на:

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

#### Модуль `17mov_Postman`

Модуль `17mov_Postman` дозволяє інтегрувати додаткову логіку до системи працівника пошти, дає змогу отримати додаткову винагороду після 10+ зібраних листів. Винагорода зележить від рівня гравця.

##### Оновлення `server/functions.lua` в `17mov_Postman`

Для інтеграції додайте наступний код перед функцією `Pay(source, amount)`:

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

    TriggerClientEvent('ak4y-battlepass:addtaskcount:standart', source, 16, 1)

end)

```

##### Замініть функцію `function Pay` на:

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


## Використання

Ви можете з легкістю налаштувати рівневу систему за допомогою `Config.lua`.

##### `Config.Levels` - Дає змогу налаштувати необхідну кількість досвіду для досягнення певного рівня.

##### `Config.Reward` - Відповідає за кількість коштів яку гравець отримає після тригеру винагороди.

##### `Config.LevelColumns` - Зберігає в собі колонки бази даних з досвідом та рівнем.
Якщо ви хочете додати ще один рівень, напиклад для роботи риболова то додайте:
```lua
    fisherman = {
        xp = 'fisherman_xp',
        lvl = 'fisherman_lvl',
    },
```

Також додайте операючись на інші рядки `Config.Levels` та `Config.Reward`
І відповідно до бази даних нові колонки `fisherman_lvl` та `fisherman_xp`

##### Після цього ви можете викликати тригер додавання `xp` для риболова зо допомогою:

```lua
local src = source
TriggerEvent('addPlayerExperience', 'postman_xp', 1, src)
```

Замість `postman_xp` ви можете використати будьякий з колонок бази даних який відповідає за зберігання досвіду гравця, замість `1` ви можете вказати іншу кількість отримуваного гравцем досвіду.

##### Та викликати тригер винагородження гравця за допомогою:

```lua
TriggerEvent('RewardPlayer', source, "none", 1, 'postman_lvl', 'true')
```

Замість `postman_lvl` ви можете використати будьякий з колонок бази даних який відповідає за рівень гравця, замість `"none", 1` ви можете вказати назву предмету наприклад `bandage` та його кількість `"bandage", 10`.
- Якщо ви не хочете видавати жоден предмет як винагороду то залишете аргумент як none.
- Якщо ви хочете видати лише предмет але без грошей то змініть 'true' на 'false'

`Приклад:`
```lua
TriggerEvent('RewardPlayer', source, "bandage", 10, 'postman_lvl', 'false')
```

## Внесок у проект

17Movment - Дякую розробникам за представлені чудові скрипти.

## Версії

[QBcore](http://semver.org/) Актуальна версія [tags on this repository](https://github.com/qbcore-framework/qb-core).
[OxLib](http://semver.org/) Актуальна версія [tags on this repository](https://github.com/overextended/ox_lib).


## Автори

* **Marko Scripts** - *marko_leveling* - [Discord](https://discord.gg/ptUTdGWtjX)

