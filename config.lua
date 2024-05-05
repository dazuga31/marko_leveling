
Config = {}
Config.Lang = {}

Config.XpPreCheck = true
Config.DebugMode = true

-- Тип нотифікації ("qb" або "17mov")
Config.NotificationType = "qb"

Config.Levels = {

    -- За замовчуванням у гравця 0 рівень
    postman_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
        [3] = 120,
        [4] = 400,
        [5] = 500,
        [6] = 600,
        [7] = 700,
        [8] = 800,
        [9] = 900,
        [10] = 1000,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,
    },
    deliveryman_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
        [3] = 120,
        [4] = 400,
        [5] = 500,
        [6] = 600,
        [7] = 700,
        [8] = 800,
        [9] = 900,
        [10] = 1000,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,
    },
    player_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
        [3] = 120,
        [4] = 400,
        [5] = 500,
        [6] = 600,
        [7] = 700,
        [8] = 800,
        [9] = 900,
        [10] = 1000,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,
    },
    gruppe_lvl = {
        [1] = 40,
        [2] = 80,
        [3] = 120,
        [4] = 400,
        [5] = 500,
        [6] = 600,
        [7] = 700,
        [8] = 800,
        [9] = 900,
        [10] = 1000,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,        
    },
    busdriver_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
        [3] = 120,
        [4] = 400,
        [5] = 500,
        [6] = 600,
        [7] = 700,
        [8] = 800,
        [9] = 900,
        [10] = 1000,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,
    },
    lumberjack_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
        [3] = 120,
        [4] = 400,
        [5] = 500,
        [6] = 600,
        [7] = 700,
        [8] = 800,
        [9] = 900,
        [10] = 1000,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,
    },
    medic_lvl = {
        [0] = 25,
        [1] = 50,
        [2] = 150,
        [3] = 225,
        [4] = 350,
        [5] = 400,
        [6] = 550,
        [7] = 650,
        [8] = 750,
        [9] = 1000,
        [10] = 1500,
        [11] = 2000,
        [12] = 3000,
        [13] = 4000,
        [14] = 5000,
    }

}

Config.Reward = {
    medic_lvl = {
        [0] = 300,
        [1] = 325,
        [2] = 350,
        [3] = 375,
        [4] = 400,
        [5] = 425,
        [6] = 450,
        [7] = 475,
        [8] = 500,
        [9] = 525,
        [10] = 550,
        [11] = 575,
        [12] = 600,
        [13] = 625,
        [14] = 650,
        [15] = 675,
    },
    postman_lvl = {
        [0] = 300,
        [1] = 325,
        [2] = 350,
        [3] = 375,
        [4] = 400,
        [5] = 425,
        [6] = 450,
        [7] = 475,
        [8] = 500,
        [9] = 525,
        [10] = 550,
        [11] = 575,
        [12] = 600,
        [13] = 625,
        [14] = 650,
        [15] = 675,
    },
    deliveryman_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
    },
    player_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
    },
    gruppe_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
    },
    busdriver_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
    },
    lumberjack_lvl = {
        [0] = 40,
        [1] = 40,
        [2] = 80,
    },
}
Config.LevelColumns = {
    medic = {
        xp = 'medic_xp',
        lvl = 'medic_lvl',
    },
    busdriver = {
        xp = 'busdriver_xp',
        lvl = 'busdriver_lvl',
    },
    lumberjack = {
        xp = 'lumberjack_xp',
        lvl = 'lumberjack_lvl',
    },
    gruppe = {
        xp = 'gruppe_xp',
        lvl = 'gruppe_lvl',
    },
    deliveryman = {
        xp = 'deliveryman_xp',
        lvl = 'deliveryman_lvl',
    },
    postman = {
        xp = 'postman_xp',
        lvl = 'postman_lvl',
    },
    player = {
        xp = 'player_xp',
        lvl = 'player_lvl',
    },
    mechanic = {
        xp = 'toolbox_xp',
        lvl = 'toolbox_lvl',
    },
    police_carreturner = {
        xp = 'carreturn_xp',
        lvl = 'carreturn_lvl',
    },
    carstealer = {
        xp = 'carjack_xp',
        lvl = 'carjack_lvl',
    },
}



Config.Lang["DebugMessages"] = {
    NoIdentifier = "Unable to get identifier for player",
    NoLevelColumn = "No level column configuration found for %s",
    InitiatingXPUpdate = "Initiating XP update for column: %s",
    CurrentAndNewXP = "Current XP: %s, New XP: %s",
    XPUpdateSuccess = "Experience added successfully to column: %s",
    LevelChange = "Level change from %s to %s",
    LevelUpdateSuccess = "Level updated successfully to %s",
    FailedToUpdateLevel = "Failed to update level.",
    FailedToUpdateXP = "Failed to update XP.",
    FailedToGetCurrentValues = "Failed to get current values for %s",
    ReceivedRewardPlayer = "Received RewardPlayer event for player with source: %s",
    PlayerLevelForPlayer = "Player level for player with source: %s is: %s",
    AddedMoneyToPlayer = "Added money: %s to player with source: %s",
    AddedItemToPlayer = "Added item with ID: %s and quantity: %s to player with source: %s",
    FailedToGetPlayerLevel = "RewardPlayer: Failed to get player level for player with source: %s",
    UnableToGetIdentifier = "RewardPlayer: Unable to get identifier for player with source: %s",
    AddedNewPlayerToDatabase = "Added new player to the database. Identifier: %s",
    UnableToRetrievePlayerIdentifier = "playerConnecting: Unable to retrieve player identifier.",
    ReceivedCheckPlayerLevel = "Received checkPlayerLevel event for player with source: %s",
    PlayerLevelForPlayer = "Player level for player with source: %s is: %s",
    FailedToGetPlayerLevel = "checkPlayerLevel: Failed to get player level for player with source: %s",
    UnableToGetIdentifierForPlayer = "checkPlayerLevel: Unable to get identifier for player with source: %s",
    EventAddPlayerExperienceTriggered = "Event 'addPlayerExperience' triggered for player with source: %s",
    AddingExperienceToColumn = "Adding experience to column: %s",
    AmountOfExperienceToAdd = "Amount of experience to add: %s",
    AddPlayerExperiencePlayerIdentifier = "AddPlayerExperience: Player identifier: %s",
    AddPlayerExperienceUnableToGetIdentifier = "AddPlayerExperience: Unable to get identifier for player with source: %s",
    NoLevelColumnConfigurationFoundForRole = "No level column configuration found for role: %s",
    NoRecordsFoundForIdentifier = "No records found for identifier: %s in role: %s",
    RetrievedLevel = "Retrieved level for %s in role %s: %s",
    InvalidArgumentsToGetPlayerLevelFunction = "Invalid arguments to getPlayerLevel function",
    NoLevelColumnConfigurationFoundForRole = "No level column configuration found for role %s",
    LevelForRoleIs = "Level for %s is: %s",
    FailedToFetchLevelForRole = "Failed to fetch level for %s",
    NoIdentifier = "Unable to get identifier for player",
    NoLevelColumn = "No level column configuration found for column: %s",
    InitiatingXPUpdate = "Initiating XP update for column: %s",
    CurrentAndNewXP = "Current XP: %s, New XP: %s",
    XPUpdateSuccess = "Experience added successfully to column: %s",
    LevelChange = "Level change from %s to %s",
    LevelUpdateSuccess = "Level updated successfully to %s",
    FailedToUpdateLevel = "Failed to update level.",
    FailedToUpdateXP = "Failed to update XP.",
    FailedToGetCurrentValues = "Failed to get current values for column: %s",

}

Config.Lang["RewardMessages"] = {
    ReceivedMoneyAndItem = "You received $%s and %sx %s",
    ReceivedMoney = "You received $%s",
    ReceivedItem = "You received %sx %s"
    
}


return Config
