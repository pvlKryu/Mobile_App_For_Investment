Добавлено: 
После предыдущего релиза, где была создана БД, был создан User Bloc, а для локальной БД - репозиторий, который передается в Bloc. 
Добавлены наработки по изменению баланса: новый bloc для экрана портфеля и реализовано изменение UI.

Добавлены проверки на null User'a, там где они были нужны.
Добавлен метод Update
Баланс подтягивается с сервера

Добавлена логика изменения баланса + сделаны всплывающие уведомления для пользователя: операция прошла успешно или ошибки.
Добавлена анимация аватарки по наажатию (тапу).

Изменено:
Изменены методы User Dao для удаления пользователя. 
Аватарка User'a вынесена локально в ассеты, не подгружается по сети.

В расчет общей стоимости портфеля добавлен учет изменения баланса.
Модель акции была изменена: теперь поле Кол-во = ?

Удалено:
Неиспользуемый файл с ошибками Failures.
