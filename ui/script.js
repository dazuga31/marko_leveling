
window.addEventListener('DOMContentLoaded', () => {
});

window.addEventListener('message', function(event) {
    var data = event.data;
    
    if (data.type === 'show_ui') {
        toggleUI(true);
        console.log('UI is now visible');
        requestData(); // Update the player's level when showing the interface
    } else if (data.type === 'hide_ui') {
        toggleUI(false);
        console.log('UI is now hidden');
    }
});

// Function to open or close the UI
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
        toggleUI(false); // Hide the interface when the ESC key is pressed
        fetch(`https://${GetParentResourceName()}/hide_ui`, {
            method: 'POST'
        });
    }
});



window.addEventListener('message', function(event) {
    if (event.data.type === "updateData") {
        updateUI(event.data.payload);
    }
});

function requestData() {
    fetch(`https://${GetParentResourceName()}/requestData`, {
        method: 'POST'
    }).then(res => res.json()).then(data => {
        console.log('Response from NUI Callback:', data);
    });
}


const levelExperience = {
    medic: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    busdriver: {
        0: 300,
        1: 325,
        2: 350,
        3: 375,
        4: 400,
        5: 425,
        6: 450,
        7: 475,
        8: 500,
        9: 525,
        10: 550,
        11: 575,
        12: 600,
        13: 625,
        14: 650,
        15: 675,
        16: 700,
        17: 725,
        18: 750,
        19: 775,
        20: 800,
        21: 825,
        22: 850,
        23: 875,
        24: 900,
        25: 925,
        26: 950,
        27: 975,
        28: 1000,
        29: 1025,
        30: 1050,
        31: 1075,
        32: 1100,
        33: 1125,
        34: 1150,
        35: 1175,
        36: 1200,
        37: 1225,
        38: 1250,
        39: 1275,
        40: 1300,
        41: 1325,
        42: 1350,
        43: 1375,
        44: 1400,
        45: 1425,
        46: 1450,
        47: 1475,
        48: 1500,
        49: 1525,
        50: 1550
    },
    player: {
        0: 100,
        1: 200,
        2: 350,
        3: 400,
        4: 1000,
        5: 2000,
        6: 2500,
        7: 3500,
        8: 4500,
        9: 5500,
        10: 6500,
        11: 7500,
        12: 8500,
        13: 9500,
        14: 10000,
        15: 15000,
        16: 25000,
        17: 35000,
        18: 45000,
        19: 55000,
        20: 65000,
        21: 75000,
        22: 85000,
        23: 95000,
        24: 105000,
        25: 115000,
        26: 125000,
        27: 135000,
        28: 145000,
        29: 155000,
        30: 165000,
        31: 175000,
        32: 185000,
        33: 195000,
        34: 205000,
        35: 215000,
        36: 225000,
        37: 235000,
        38: 245000,
        39: 255000,
        40: 265000,
        41: 275000,
        42: 285000,
        43: 295000,
        44: 305000,
        45: 315000,
        46: 325000,
        47: 335000,
        48: 345000,
        49: 355000,
        50: 365000
    },
    lumberjack: {
        0: 50,
        1: 250,
        2: 450,
        3: 650,
        4: 850,
        5: 1000,
        6: 1500,
        7: 2500,
        8: 3500,
        9: 4500,
        10: 5500,
        11: 6500,
        12: 7500,
        13: 8500,
        14: 9000,
        15: 10500,
        16: 15000,
        17: 25000,
        18: 35000,
        19: 45000,
        20: 55000,
        21: 65000,
        22: 75000,
        23: 85000,
        24: 95000,
        25: 105000,
        26: 115000,
        27: 125000,
        28: 135000,
        29: 145000,
        30: 155000,
        31: 165000,
        32: 175000,
        33: 185000,
        34: 195000,
        35: 205000,
        36: 215000,
        37: 225000,
        38: 235000,
        39: 245000,
        40: 255000,
        41: 265000,
        42: 275000,
        43: 285000,
        44: 295000,
        45: 305000,
        46: 315000,
        47: 325000,
        48: 335000,
        49: 345000,
        50: 355000
    },
    inkasator: {
        0 : 100,
        1 : 250,
        2 : 450,
        3 : 650,
        4 : 850,
        5 : 1000,
        6 : 1500,
        7 : 2500,
        8 : 3500,
        9 : 4500,
        10 : 5500,
        11 : 6500,
        12 : 7500,
        13 : 8500,
        14 : 9000,
        15 : 10500,
        16 : 15000,
        17 : 25000,
        18 : 35000,
        19 : 45000,
        20 : 55000,
        21 : 65000,
        22 : 75000,
        23 : 85000,
        24 : 95000,
        25 : 105000,
        26 : 115000,
        27 : 125000,
        28 : 135000,
        29 : 145000,
        30 : 155000,
        31 : 165000,
        32 : 175000,
        33 : 185000,
        34 : 195000,
        35 : 205000,
        36 : 215000,
        37 : 225000,
        38 : 235000,
        39 : 245000,
        40 : 255000,
        41 : 265000,
        42 : 275000,
        43 : 285000,
        44 : 295000,
        45 : 305000,
        46 : 315000,
        47 : 325000,
        48 : 335000,
        49 : 345000,
        50 : 355000
    },

    deliveryman: {
        0: 100,
        1: 300,
        2: 500,
        3: 1000,
        4: 1500,
        5: 2000,
        6: 2500,
        7: 3000,
        8: 3500,
        9: 4000,
        10: 4500,
        11: 5000,
        12: 5500,
        13: 6000,
        14: 6500,
        15: 7000,
        16: 7500,
        17: 8000,
        18: 8500,
        19: 9000,
        20: 9500,
        21: 10000,
        22: 10500,
        23: 11000,
        24: 11500,
        25: 12000,
        26: 12500,
        27: 13000,
        28: 13500,
        29: 14000,
        30: 14500,
        31: 15000,
        32: 15500,
        33: 16000,
        34: 16500,
        35: 17000,
        36: 17500,
        37: 18000,
        38: 18500,
        39: 19000,
        40: 19500,
        41: 20000,
        42: 20500,
        43: 21000,
        44: 21500,
        45: 22000,
        46: 22500,
        47: 23000,
        48: 23500,
        49: 24000,
        50: 24500,
    },
    postman: {
        0: 20,
        1: 60,
        2: 100,
        3: 300,
        4: 500,
        5: 700,
        6: 900,
        7: 1100,
        8: 1300,
        9: 1500,
        10: 1800,
        11: 2000,
        12: 2300,
        13: 2600,
        14: 3000,
        15: 3500,
        16: 4000,
        17: 4500,
        18: 5000,
        19: 5500,
        20: 6000,
        21: 6500,
        22: 7000,
        23: 7500,
        24: 8000,
        25: 8500,
        26: 9000,
        27: 9500,
        28: 10000,
        29: 10500,
        30: 11000,
        31: 11500,
        32: 12000,
        33: 12500,
        34: 13000,
        35: 13500,
        36: 14000,
        37: 14500,
        38: 15000,
        39: 15500,
        40: 16000,
        41: 16500,
        42: 17000,
        43: 17500,
        44: 18000,
        45: 18500,
        46: 19000,
        47: 19500,
        48: 20000,
        49: 20500,
        50: 21000,
    },
    toolbox: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500,
    },
    carjack: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    police_carreturner: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },

    fisherman: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    drugdroper: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    oilrig: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    builder: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    farmer: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    electrician: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    houserobbery: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    },
    miner: {
        0: 50,
        1: 100,
        2: 200,
        3: 400,
        4: 600,
        5: 800,
        6: 1000,
        7: 1200,
        8: 1400,
        9: 1600,
        10: 1800,
        11: 2000,
        12: 2500,
        13: 3000,
        14: 3500,
        15: 4000,
        16: 4500,
        17: 5000,
        18: 5500,
        19: 6000,
        20: 6500,
        21: 7000,
        22: 7500,
        23: 8000,
        24: 8500,
        25: 9000,
        26: 9500,
        27: 10000,
        28: 10500,
        29: 11000,
        30: 11500,
        31: 12000,
        32: 12500,
        33: 13000,
        34: 13500,
        35: 14000,
        36: 14500,
        37: 15000,
        38: 15500,
        39: 16000,
        40: 16500,
        41: 17000,
        42: 17500,
        43: 18000,
        44: 18500,
        45: 19000,
        46: 19500,
        47: 20000,
        48: 20500,
        49: 21000,
        50: 21500
    }
    // Додайте додаткові професії з їхніми рівнями досвіду за потребою
};

function updateProgressBar(profession, barId, currentLevel, currentXp) {
    const levels = levelExperience[profession];
    const nextLevelXp = levels[currentLevel];
    const bar = document.getElementById(barId);
    if (bar && nextLevelXp !== undefined) {
        let percentage = (currentXp / nextLevelXp) * 100;
        bar.innerHTML = `
            <div class="progressbar-inner" style="width: ${percentage.toFixed(2)}%"></div>
            <div class="progress-info">
                Level: ${currentLevel}, Experience: ${currentXp}/${nextLevelXp}
            </div>`;
    }
}

function updateUI(data) {

    // Update general player information
    if (data.fullName) {
        document.querySelector('#user-name').innerText = data.fullName; // Update the player's name
    }
    
    updateProgressBar('inkasator', 'gruppe-level-bar', data['gruppe_lvl'], data['gruppe_xp']);
    updateProgressBar('farmer', 'farmer-level-bar', data['farmer_lvl'], data['farmer_xp']);
    updateProgressBar('medic', 'medic-level-bar', data['medic_lvl'], data['medic_xp']);
    updateProgressBar('busdriver', 'busdriver-level-bar', data['busdriver_lvl'], data['busdriver_xp']);
    updateProgressBar('lumberjack', 'lumberjack-level-bar', data['lumberjack_lvl'], data['lumberjack_xp']);
    updateProgressBar('deliveryman', 'deliveryman-level-bar', data['deliveryman_lvl'], data['deliveryman_xp']);
    updateProgressBar('postman', 'postman-level-bar', data['postman_lvl'], data['postman_xp']);
    updateProgressBar('player', 'player-level-bar', data['player_lvl'], data['player_xp']);
    updateProgressBar('toolbox', 'toolbox-level-bar', data['toolbox_lvl'], data['toolbox_xp']);
    updateProgressBar('carjack', 'carjack-level-bar', data['carjack_lvl'], data['carjack_xp']);
    updateProgressBar('police_carreturner', 'carreturn-level-bar', data['carreturn_lvl'], data['carreturn_xp']);
    updateProgressBar('fisherman', 'fisherman-level-bar', data['fisherman_lvl'], data['fisherman_xp']);
    updateProgressBar('drugdroper', 'drugdroper-level-bar', data['drugdroper_lvl'], data['drugdroper_xp']);
    updateProgressBar('oilrig', 'oilrig-level-bar', data['oilrig_lvl'], data['oilrig_xp']);
    updateProgressBar('builder', 'builder-level-bar', data['builder_lvl'], data['builder_xp']);
    updateProgressBar('electrician', 'electrician-level-bar', data['electrician_lvl'], data['electrician_xp']);
    updateProgressBar('houserobbery', 'houserobbery-level-bar', data['houserobbery_lvl'], data['houserobbery_xp']);
    updateProgressBar('miner', 'miner-level-bar', data['miner_lvl'], data['miner_xp']);

// Add similar lines for other professions
console.log(data); // Output data for validation
}

document.addEventListener('DOMContentLoaded', function() {
    const switchControl = document.querySelector('.switch input[type="checkbox"]');

    switchControl.addEventListener('change', function() {
        if (this.checked) {
            document.body.classList.add('day-theme');
            console.log("Light theme enabled");
        } else {
            document.body.classList.remove('day-theme');
            console.log("Light theme disabled");
        }
    });
});


window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.action === "updateExperience") {
        // Встановлення іконки та опису ролі
        var roleIconClass = "", roleDescription = "";
        switch(data.role) {
            case "busdriver":
                roleIconClass = "fas fa-bus";
                roleDescription = "Bus Driver";
                break;
            case "lumberjack":
                roleIconClass = "fas fa-tree";
                roleDescription = "Lumberjack";
                break;
            case "medic":
                roleIconClass = "fas fa-medkit";
                roleDescription = "Medic";
                break;
            case "farmer":
                roleIconClass = "fas fa-tractor";
                roleDescription = "Farmer";
                break;
            case "deliveryman":
                roleIconClass = "fas fa-truck";
                roleDescription = "Deliveryman";
                break;
            case "postman":
                roleIconClass = "fas fa-mail-bulk";
                roleDescription = "Postman";
                break;
            case "player":
                roleIconClass = "fas fa-gamepad";
                roleDescription = "Player";
                break;
            case "toolbox":
                roleIconClass = "fas fa-tools";
                roleDescription = "Mechanick";
                break;
            case "carjack":
                roleIconClass = "fas fa-car-crash";
                roleDescription = "Car Jacker";
                break;
            case "police_carreturner":
                roleIconClass = "fas fa-car";
                roleDescription = "Patrol Officer";
                break;
            case "fisherman":
                roleIconClass = "fas fa-fish";
                roleDescription = "Fisherman";
                break;
            case "drugdroper":
                roleIconClass = "fas fa-capsules";
                roleDescription = "Drug Dropper";
                break;
            case "oilrig":
                roleIconClass = "fas fa-oil-can";
                roleDescription = "Oil Rig Worker";
                break;
            case "builder":
                roleIconClass = "fas fa-hammer";
                roleDescription = "Builder";
                break;
            case "electrician":
                roleIconClass = "fas fa-bolt";
                roleDescription = "Electrician";
                break;
            case "houserobbery":
                roleIconClass = "fas fa-mask";
                roleDescription = "House Robber";
                break;
            case "miner":
                roleIconClass = "fas fa-hard-hat";
                roleDescription = "Miner";
                break;
            // Додайте додаткові умови для інших ролей за потреби
        }

        var roleIcon = document.getElementById('roleIcon');
        roleIcon.className = roleIconClass;
        document.getElementById('roleName').textContent = roleDescription;

        // Оновлення та анімація для прогрес бару включно з відображенням XP
        document.getElementById('xpProgressText').textContent = `${data.newXP} / ${data.xpToNextLevel}`;
        var xpProgressPercent = ((data.newXP) / (data.xpToNextLevel)) * 100;
        animateProgressBar(0, xpProgressPercent);

        // Показ контейнера з анімацією
        var xpUpdateContainer = document.getElementById('xpUpdateContainer');
        xpUpdateContainer.style.display = 'block';
        xpUpdateContainer.style.opacity = '1';
        xpUpdateContainer.style.transform = 'translateX(-50%) scale(1)'; 

        setTimeout(function() {
            xpUpdateContainer.style.opacity = '0';
            xpUpdateContainer.style.transform = 'translateX(-50%) scale(0.5)'; 
            setTimeout(() => {
                xpUpdateContainer.style.display = 'none'; 
            }, 500);
        }, 5000);
    }
});

function animateProgressBar(startWidth, endWidth) {
    const progressBar = document.getElementById('xpProgress');
    const step = (endWidth - startWidth) / 60;
    function frame() {
        startWidth += step;
        progressBar.style.width = startWidth + '%';
        if (startWidth < endWidth) {
            requestAnimationFrame(frame);
        }
    }
    requestAnimationFrame(frame);
}




