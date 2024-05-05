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

Замініть функцію `function Pay` на:

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


## Використання

Опис того, як використовувати проект після його налаштування.


## Внесок у проект

17Movment - Дякую розробникам за представлені чудові скрипти.

## Версії

[QBcore](http://semver.org/) Актуальна версія [tags on this repository](https://github.com/qbcore-framework/qb-core).
[OxLib](http://semver.org/) Актуальна версія [tags on this repository](https://github.com/overextended/ox_lib).


## Автори

* **Marko Scripts** - *marko_leveling* - [Discord](https://discord.gg/ptUTdGWtjX)

