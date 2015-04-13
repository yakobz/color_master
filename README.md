# color_master
Игровой экран (альбомная ориентация) делится на 2 части левую и правую.
На каждой из частей экрана написан цвет определенным цветом.
Задача игрока определить совпадает ли текст цвета с его цветом и тем самым набрать большее количество очков.
Управление на каждой из частей экрана осуществляется движением вниз либо вверх,
где вверх -- это подтверждение совпадения, а вниз -- отрицание.
И в первом и втором случае игрок получает +1 к очкам, если же выбор был сделан не верно, игра заканчивается.

Процесс определения усложняется 2 факторами:
Наличие большого количества фонов. 
Временем для определения, которое уменьшяется в зависимости от набранных очков.

Игра имеет 3 основных экрана:

Start Screen
Game Screen
Game Over Screen

Start Screen

![alt tag](https://cloud.githubusercontent.com/assets/11804765/7115090/65d0ebd2-e1ed-11e4-96c3-608d05cda47c.png)

1 Открывает таблицу рекордов подключенную через Google Play Service API (не реализовано)
2 При нажатии осуществляется переход в AppStore с просьбой оценить приложение (не реализовано)
3 Переключение между уровнями сложности. Easier, Harder.
4 Включение/выключение звуков
5 Переход в окно помощи (tutorial) с правилами игры названием цветов. (не реализовано)
6 Переход в игровое окно (Game Screen).



Game Screen 

Шкала времени которая отображает сколько времени осталось до проигрыша.
При верном выборе восстанавливает свое значение. 
Фон для текста, что бы улучшить читабельность на разных фонах.
Текст цвета и его цвет
Набранные очки игрока
Фон



Game Over Screen

Кнопка для перезагрузки игры
Набранные очки
Лучший счет за все время
При нажатии переходим в онлайн таблицу рекордов, где публикуются очки других игроков (не реализовано)
Кнопка для функции “Share” которая позволяет щарить свой счет через сервисы и соц. сети (не реализовано)
Кнопка для перехода в Start Screen
