# Целевая платформа

Android

# Результаты

## Авторизация

1. Реализован пользовательский интерфейс экрана авторизации **(1)**
2. Реализована логика авторизации
3. Реализорвано отображение SnackBar при загрузке и ошибке **(3, 4)**

### Бонусом

Kнопка скрыть-показать пароль, изменяющая свойство obscureText через стейт виджета **(2)**

## Чат

1. Реализовано отображение сообщения с геолокацией - кнопка "Open Maps" **(5)**
2. Открытие карты с геолокацией - реализовано с помощью url_launcher: ^6.1.5 (на андроиде
   открываются гугл карты по нажатию на кнопку)
3. Отправка текущей геолокации - реализовано с помощью geolocator: ^9.0.1 **(6, 7)**
4. Реализовано отображение изображений в чате **(5)**
5. Аватарки пользователей имеют разный цвет с помощью функции getColorByName (по первой букве имени
   получаем цвет из массива) **(5, 6, 7, 8)**
6. Баблы реализованы с помощью flutter_chat_bubble: ^2.0.0 **(5, 6, 7, 8)**

### Бонусом

1. Добавлена кнопка прокрутки к последнему сообщению в чате - FloatingActionButton если сообдщений в
   чате больше 7 **(9)**
2. Добавлена автозагрузка сообщений - addPostFrameCallback в initState виджета
3. Добавлено отображение загрузки сообщений в чате - isLoading в стейте виджета, который передается
   дочернему **(10)**

## Список топиков

1. Реализован интерфейс для экрана топиков **(11)**
2. Реализовано отображение имени пользователя в AppBar экрана чата (Known issues - 6)
3. Реализовано отображение списка топиков на экране **(11)**
4. Изменена навигация - после входа попадаем на экран списка топиков, а не на экран чата с id = 1

## Создание своего топика

1. Реализован пользовательский интерфейс для экрана Создания топиков **(12)**
2. Реализовано создание нового топика с названием и описанием - после создания возвращаемся на экран
   списка топиков

### Бонусом

1. Добавлено название чата в аппбар **(5, 8, 9, 10)**
2. Добавлен logout по кнопке назад на экране списка топиков **(11)**
3. По клику на топик переходим в соответствующий чат

## Known issues

1. В input не отображается добавление гео, если инпут изначально пустой (если сначала написать, а
   затем добавить гео, то в начало сообщения добавляется текст "GEO: (..., ...)")
2. Баббл с геопозицией текущего пользователя повернут не в ту сторону (как будто его отправил другой
   пользователь) **(7)**
3. Не рабатает скролл поверх изображений в чате
4. Не реализована отправка изображений
5. Не работает плейсхолдер для пустого чата - остается isLoading, а должно появляться сообщение "
   There are no messages yet"
6. Имя пользователя отображается не в том аппбаре (должен быть на списке топиков, а не на экране
   чата)
7. Баг с logout по кнопке назад - если предыдущий экран был создание чата, то навигатор возвращает
   его
8. Нет кнопки назад на экране добавления нового чата **(12)**
9. Баг с отображением слишком длинного описания топика
10. Нужен рефакторинг - разбить виджеты по файлам как минимум и вынести константы некоторые

# Ссылки на демонстрацию работы/скриншоты
[Ссылка](https://drive.google.com/drive/folders/1Ia2YXEzqKlkjmsX8YGqgY7nF0C4NzjpI?usp=sharing
) на гугл диск с картинками и скринкастом 

#### Экран авторизации (1, 2)

<p align="center">
<img src="./docs/assets/results/images/1.authorize.png" width="400" alt="Auth Screen" />
<img src="./docs/assets/results/images/2.authorize_showPassword.png" width="400" 
alt="Auth screen - show password" />
</p>

#### Snackbar (3, 4)

<p align="center">
<img src="./docs/assets/results/images/3.snackbar_processing.png" width="400" 
alt="SnackBar Processing" />
<img src="./docs/assets/results/images/4.snackbar_error.png" width="400" alt="SnackBar Error" />
</p>

#### Chat Screen (5,8)

<p align="center">
<img src="./docs/assets/results/images/5.chat_geo_image.png" width="400" 
alt="Chat Screen" />
<img src="./docs/assets/results/images/8.bubbles.png" width="400" 
alt="Chat Bubbles" />
</p>

#### Chat Send Geo Message (6, 7)

<p align="center">
<img src="./docs/assets/results/images/6.geo_message_before.png" width="400" 
alt="Sending geo message" />
<img src="./docs/assets/results/images/7.geo_message_after.png" width="400" 
alt="Sent geo message" />
</p>

#### Chat Scroll Down (9)

<p align="center">
<img src="./docs/assets/results/images/9.scroll_down.png" width="400" 
alt="Scroll Down" />
</p>

#### Chat Loading (10)

<p align="center">
<img src="./docs/assets/results/images/10.loading.png" width="400" 
alt="Scroll Down" />
</p>

#### Topics Screen (11)

<p align="center">
<img src="./docs/assets/results/images/11.topics_screen.png" width="400" 
alt="Topics Screen" />
</p>

#### Create New Topic (12)

<p align="center">
<img src="./docs/assets/results/images/12.create_new_topic.png" width="400" 
alt="Create New Topic Screen" />
</p>