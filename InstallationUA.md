## Початок роботи

Перед початком установки впевніться що у вас встановлена актуальна версія FiveM, QBcore, OxLib - Посилання на них ви знайдете нище.

## Інсталяція та підготовка.

Що потрібно встановити спочатку:

1. Розпакуйте архів **marko_leveling.rar** в теку ваших ресурсів, видаліть приписку -master так щоб тека залишилась з назвою "marko_leveling".

2. Впевніться що у вас встановлено **OX lib** - Він потрібен для взаємодії з базою даних MySQL.

3. Відкрийти **HeldiSQL** (Або інший застосунок) та імпортуйте в вашу базу даних importDB.sql

4. додайте **ensure marko_leveling** до **config.cfg** вашого серверу в кінець.

5. Все скипт готовий до застосування.

Нище будуть наведені методи інтеграції рівневої системи в скрипти професій від [17Movement](https://discord.gg/wjZe8cKf)


## Інтеграція в інші скрипти

#### Інтеграція в 17Movment
Дивіться файл [17MOVMENT_INTEGRATION.md](17MOVMENT_INTEGRATION.md) для деталей.


## Використання

Ви можете з легкістю налаштувати рівневу систему за допомогою **Config.lua**.

##### **Config.Levels** - Дає змогу налаштувати необхідну кількість досвіду для досягнення певного рівня.

##### **Config.Reward** - Відповідає за кількість коштів яку гравець отримає після тригеру винагороди.

##### **Config.LevelColumns** - Зберігає в собі колонки бази даних з досвідом та рівнем.
Якщо ви хочете додати ще один рівень, напиклад для роботи риболова то додайте до **Config.lua**.:
```lua
    fisherman = {
        xp = 'fisherman_xp',
        lvl = 'fisherman_lvl',
    },
```

Також додайте операючись на інші рядки `Config.Levels` та `Config.Reward`
І відповідно до бази даних нові колонки `fisherman_lvl` та `fisherman_xp`

##### Додавання нових колонок до веб інтерфейсу.

Додайте новий рядок поруч з іншими в файлі **\marko_leveling\ui\index.html**:

```html
            <!-- Section for Fisherman -->
            <div class="profession-section">
                <h2><i class="fas fa-tree"></i> Fisherman</h2>
                <p>Level: <span id="fisherman-level">1</span></p>
                <p>Experience: <span id="fisherman-exp">0</span></p>
            </div>
```

Додайте новий рядок поруч з іншими в файлі **\marko_leveling\ui\script.js**:
```js
    document.getElementById('fisherman-level').innerText = data['fisherman_lvl'] || "0";
    document.getElementById('fisherman-exp').innerText = data['fisherman_xp'] || "0";
```

##### Після цього ви можете викликати тригер додавання **xp** для риболова зо допомогою:

```lua
local src = source
TriggerEvent('addPlayerExperience', 'postman_xp', 1, src)
```

Замість **postman_xp** ви можете використати будьякий з колонок бази даних який відповідає за зберігання досвіду гравця, замість **1** ви можете вказати іншу кількість отримуваного гравцем досвіду.

##### Виклик тригеру винагородження гравця:

```lua
TriggerEvent('RewardPlayer', source, "none", 1, 'postman_lvl', 'true')
```

Замість `postman_lvl` ви можете використати будьякий з колонок бази даних який відповідає за рівень гравця, замість **"none", 1** ви можете вказати назву предмету наприклад **bandage** та його кількість **"bandage", 10**.
- Якщо ви не хочете видавати жоден предмет як винагороду то залишете аргумент як none.
- Якщо ви хочете видати лише предмет але без грошей то змініть **'true'** на **'false'**

`Приклад:`
```lua
TriggerEvent('RewardPlayer', source, "bandage", 10, 'postman_lvl', 'false')
```

## Внесок у проект

[17Movment](https://discord.gg/wjZe8cKf) - Дякую розробникам за представлені чудові скрипти.


## Залежності

[QBcore](http://semver.org/) Актуальна версія [tags on this repository](https://github.com/qbcore-framework/qb-core).
[OxLib](http://semver.org/) Актуальна версія [tags on this repository](https://github.com/overextended/ox_lib).


## Автори

* **Marko Scripts** - *marko_leveling* - [Discord](https://discord.gg/ptUTdGWtjX)





























## Версії

* **V-1.0** - Релізна версія.