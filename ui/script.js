// Приклад ініціалізації при завантаженні сторінки
window.addEventListener('DOMContentLoaded', () => {
});

window.addEventListener('message', function(event) {
    var data = event.data;
    
    if (data.type === 'show_ui') {
        toggleUI(true);
        console.log('UI is now visible');
        requestData(); // Оновити рівень гравця при показі інтерфейсу
    } else if (data.type === 'hide_ui') {
        toggleUI(false);
        console.log('UI is now hidden');
    }
});

// Функція для відкриття або закриття UI
function toggleUI(show) {
    var uiElement = document.getElementById('ui-container');
    
    if (show) {
        uiElement.style.display = 'block';
    } else {
        uiElement.style.display = 'none';
    }
}

// To close the menu
document.addEventListener('keydown', function(e) {
    if (e.key === "Escape") {
        toggleUI(false); // Приховати інтерфейс при натисканні клавіші ESC
        fetch(`https://${GetParentResourceName()}/hide_ui`, {
            method: 'POST'
        });
    }
});



window.addEventListener('message', function(event) {
    if (event.data.type === "updateData") {
        updateUI(event.data.payload);  // Переконайтесь, що ви передаєте payload
    }
});

function requestData() {
    fetch(`https://${GetParentResourceName()}/requestData`, {
        method: 'POST'
    }).then(res => res.json()).then(data => {
        console.log('Response from NUI Callback:', data);
    });
}

function updateUI(data) {

    // Оновлення загальної інформації гравця
    if (data.fullName) {
        document.querySelector('#user-name').innerText = data.fullName;  // Оновлюємо ім'я гравця
    }
    
    // Приклад оновлення для однієї професії, вам потрібно розширити це на всі професії
    document.getElementById('medic-level').innerText = data['medic_lvl'] || "0";
    document.getElementById('medic-exp').innerText = data['medic_xp'] || "0";

    document.getElementById('busdriver-level').innerText = data['busdriver_lvl'] || "0";
    document.getElementById('busdriver-exp').innerText = data['busdriver_xp'] || "0";

    document.getElementById('lumberjack-level').innerText = data['lumberjack_lvl'] || "0";
    document.getElementById('lumberjack-exp').innerText = data['lumberjack_xp'] || "0";

    document.getElementById('gruppe-level').innerText = data['gruppe_xp'] || "0";
    document.getElementById('gruppe-exp').innerText = data['gruppe_xp'] || "0";

    document.getElementById('deliveryman-level').innerText = data['deliveryman_lvl'] || "0";
    document.getElementById('deliveryman-exp').innerText = data['deliveryman_xp'] || "0";

    document.getElementById('postman-level').innerText = data['postman_lvl'] || "0";
    document.getElementById('postman-exp').innerText = data['postman_xp'] || "0";

    document.getElementById('player-level').innerText = data['player_lvl'] || "0";
    document.getElementById('player-exp').innerText = data['player_xp'] || "0";

    document.getElementById('toolbox-level').innerText = data['toolbox_lvl'] || "0";
    document.getElementById('toolbox-exp').innerText = data['toolbox_xp'] || "0";

    document.getElementById('carjack-level').innerText = data['carjack_lvl'] || "0";
    document.getElementById('carjack-exp').innerText = data['carjack_xp'] || "0";

    document.getElementById('police_carreturner-level').innerText = data['carreturn_lvl'] || "0";
    document.getElementById('police_carreturner-exp').innerText = data['carreturn_xp'] || "0";
    // Додайте подібні рядки для інших професій
    console.log(data);  // Виведення даних для перевірки
}