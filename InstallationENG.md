## Getting Started

Before starting the installation, make sure that you have the latest version of FiveM, QBcore, OxLib installed - You will find links to them below.

## Installation and preparation.

What you need to install first:

1. Unpack the archive **marko_leveling.rar** in the folder of your resources, remove the postscript -master so that the folder remains with the name "marko_leveling".

2. Make sure you have **OX lib** installed - It is required to interact with the MySQL database.

3. Open **HeldiSQL** (Or another application) and import into your database importDB.sql

4. add **ensure marko_leveling** to **config.cfg** of your server at the end.

5. The entire script is ready for use.

Below are the methods of integrating the level system into profession scripts from [17Movement](https://discord.gg/wjZe8cKf)


## Integration into other scripts

#### Integration in 17Movment
See file [17MOVMENT_INTEGRATION.md](17MOVMENT_INTEGRATION.md) for details.

## Usage

You can easily customize the level system with **Config.lua**.

##### **Config.Levels** - Allows you to configure the required amount of experience to reach a certain level.

##### **Config.Reward** - Responsible for the amount of funds the player will receive after the reward trigger.

##### **Config.LevelColumns** - Stores experience and level database columns.
If you want to add another level, for example, for the operation of fishing, then add to **Config.lua**.:
```lua
     fisherman = {
         xp = 'fisherman_xp',
         lvl = 'fisherman_lvl',
     },
```

Also add `Config.Levels` and `Config.Reward` operating on other lines
And according to the database, the new `fisherman_lvl` and `fisherman_xp` columns

##### Adding new columns to the web interface.

Add a new line next to the others in the file **\marko_leveling\ui\index.html**:

```html
             <!-- Section for Fisherman -->
             <div class="profession-section">
                 <h2><i class="fas fa-tree"></i> Fisherman</h2>
                 <p>Level: <span id="fisherman-level">1</span></p>
                 <p>Experience: <span id="fisherman-exp">0</span></p>
             </div>
```

Add a new line next to the others in the file **\marko_leveling\ui\script.js**:
```js
     document.getElementById('fisherman-level').innerText = data['fisherman_lvl'] || "0";
     document.getElementById('fisherman-exp').innerText = data['fisherman_xp'] || "0";
```


##### You can then trigger the add **xp** for fishing with:

```lua
local src = source
TriggerEvent('addPlayerExperience', 'postman_xp', 1, src)
```

Instead of **postman_xp**, you can use any of the database columns responsible for storing the player's experience, instead of **1**, you can specify another amount of experience received by the player.

##### Calling the player reward trigger:

```lua
TriggerEvent('RewardPlayer', source, "none", 1, 'postman_lvl', 'true')
```

Instead of `postman_lvl` you can use any of the database columns responsible for the level of the player, instead of **"none", 1** you can specify the name of the item for example **bandage** and its quantity **"bandage", 10**.
- If you don't want to issue any item as a reward, leave the argument as none.
- If you want to issue only an item but no money, change **'true'** to **'false'**


`Example:`
```lua
TriggerEvent('RewardPlayer', source, "bandage", 10, 'postman_lvl', 'false')
```

## Contribution to the project

[17Movment](https://discord.gg/wjZe8cKf) - Thanks to the developers for the great scripts presented.


## Dependencies

[QBcore](http://semver.org/) Current version [tags on this repository](https://github.com/qbcore-framework/qb-core).
[OxLib](http://semver.org/) Current version of [tags on this repository](https://github.com/overextended/ox_lib).


## Authors

* **Marko Scripts** - *marko_leveling* - [Discord](https://discord.gg/ptUTdGWtjX)





























## Versions

* **V-1.0** - Release version.