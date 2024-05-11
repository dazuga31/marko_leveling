RegisterCommand("showLVLui", function()
    TriggerServerEvent('checkplayerlvlbyUI', source)
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "show_ui"
    })
end)

function CloseVehicleSelection()
    print("Vehicle selection menu closed.")
    SetNuiFocus(false, false) -- Вимкнути фокус NUI
    SendNUIMessage({
        action = "closeUI" -- Надіслати повідомлення для закриття вікна вибору транспорту
    })
end

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('hide_ui', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)



-- Отримання даних із сервера
RegisterNetEvent('receiveDataFromServer')
AddEventHandler('receiveDataFromServer', function(data)
    if data.error then
        print("Error received from server: " .. data.error)
        -- Відправка помилки у веб-інтерфейс
        SendNUIMessage({
            type = "error",
            message = data.error
        })
    else
        print("Data received from server")
        for key, value in pairs(data) do
            print(key .. ": " .. tostring(value))
        end
        -- Відправка отриманих даних у веб-інтерфейс
        SendNUIMessage({
            type = "updateData",  -- тип повідомлення для ідентифікації у JavaScript
            payload = data  -- передача отриманих даних
        })
    end
end)


-- Функція для відправлення запиту на сервер для отримання даних
function requestDataFromServer()
    print("Requesting data from server...")
    local playerId = GetPlayerServerId(PlayerId())  -- Отримати серверний ID поточного гравця
    TriggerServerEvent('requestDataFromServer', playerId)
end


-- NUI Callback для виклику з JavaScript
RegisterNUICallback('requestData', function(data, cb)
    requestDataFromServer()
    cb('ok')  -- Відправлення відповіді назад у веб-інтерфейс
end)



RegisterNetEvent('playerExperience:update')
AddEventHandler('playerExperience:update', function(role, currentXP, newXP, currentLevel, newLevel, xpToNextLevel)
    print("Player experience update:")
    print("Role:", role)
    print("Current XP:", currentXP)
    print("New XP:", newXP)
    print("Current Level:", currentLevel)
    print("New Level:", newLevel)
    print("XP to Next Level:", xpToNextLevel)  -- Додаємо вивід у консоль

    -- Відправка даних на HTML сторінку через NUI
    SendNUIMessage({
        action = "updateExperience",
        role = role,
        currentXP = currentXP,
        newXP = newXP,
        currentLevel = currentLevel,
        newLevel = newLevel,
        xpToNextLevel = xpToNextLevel  -- Включаємо xpToNextLevel в дані, які відправляються
    })
end)

