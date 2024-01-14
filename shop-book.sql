-- Задание 1: Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.
SELECT buy.buy_id, book.title, book.price, buy_book.amount
FROM client
    INNER JOIN buy ON buy.client_id = client.client_id
    INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
    INNER JOIN book ON buy_book.book_id = book.book_id
WHERE client.name_client = "Баранов Павел"
ORDER BY buy.buy_id, book.title;


-- Задание 2: Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT author.name_author, book.title, COUNT(buy_book.book_id) AS Количество
FROM author
    INNER JOIN book ON author.author_id = book.author_id
    LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY book.book_id
ORDER BY author.name_author, book.title;


-- Задание 3: Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
SELECT city.name_city, COUNT(client.city_id) AS Количество
FROM city
    INNER JOIN client ON city.city_id = client.city_id
    INNER JOIN buy ON client.client_id = buy.client_id
GROUP BY client.city_id
ORDER BY Количество DESC, city.name_city;


-- Задание 4: Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT buy_step.buy_id, date_step_end
FROM
    step INNER JOIN buy_step ON step.step_id = buy_step.step_id
WHERE buy_step.step_id = 1 AND  date_step_beg IS NOT NULL AND date_step_end IS NOT NULL;


-- Задание 5: Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
SELECT buy.buy_id, client.name_client, SUM(book.price * buy_book.amount) AS Стоимость
FROM buy
    INNER JOIN client ON buy.client_id = client.client_id
    INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
    INNER JOIN book ON buy_book.book_id = book.book_id
GROUP BY buy.buy_id
ORDER BY buy.buy_id;


-- Задание 6: Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
SELECT buy_step.buy_id, step.name_step
FROM buy_step INNER JOIN step ON buy_step.step_id = step.step_id
WHERE buy_step.date_step_beg IS NOT NULL AND buy_step.date_step_end IS NULL
ORDER BY buy_step.buy_id;


-- Задание 7: В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
SELECT buy.buy_id, DATEDIFF(buy_step.date_step_end, buy_step.date_step_beg) AS Количество_дней, IF(city.days_delivery <= DATEDIFF(buy_step.date_step_end, buy_step.date_step_beg), DATEDIFF(buy_step.date_step_end, buy_step.date_step_beg) - city.days_delivery, 0) AS Опоздание

FROM city
    INNER JOIN client ON city.city_id = client.city_id
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_step ON buy.buy_id = buy_step.buy_id
    INNER JOIN step ON buy_step.step_id = step.step_id
    
WHERE step.name_step = 'Транспортировка' AND buy_step.date_step_beg IS NOT NULL AND buy_step.date_step_end IS NOT NULL
ORDER BY buy.buy_id;


-- Задание 8: Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
SELECT DISTINCT client.name_client
FROM client 
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
    INNER JOIN book ON buy_book.book_id = book.book_id
    INNER JOIN author ON book.author_id = author.author_id
WHERE author.name_author LIKE "Достоевский %"
ORDER BY client.name_client;


-- Задание 9: Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.
SELECT genre.name_genre, COUNT(genre.name_genre) AS Количество
FROM genre
    INNER JOIN book ON genre.genre_id = book.genre_id
    LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY genre.name_genre
HAVING COUNT(genre.genre_id) = (
    SELECT MAX(sum_genre)
    FROM (
        SELECT SUM(book.genre_id) AS sum_genre
        FROM book LEFT JOIN buy_book ON book.book_id = buy_book.book_id
        GROUP BY book.genre_id
    ) query_in
);


-- Задание 10: Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.
SELECT YEAR(date_payment) AS Год,
	   MONTHNAME(date_payment) AS Месяц,
	   SUM(amount*price) AS Сумма
FROM buy_archive
GROUP BY Год, Месяц

UNION ALL
SELECT YEAR(date_step_end) AS Год,
	   MONTHNAME(date_step_end) AS Месяц,
	   SUM(bb.amount*price) AS Сумма
FROM buy_book bb
      JOIN buy_step bs ON bb.buy_id = bs.buy_id 
  				  AND bs.date_step_end 
  				  AND bs.step_id = 1
      JOIN book USING(book_id)
GROUP BY Год, Месяц
ORDER BY Месяц, Год;


-- Задание 11: Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год . За 2020 год проданными считать те экземпляры, которые уже оплачены. Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.
WITH Title_sales AS (
SELECT title, buy_book.amount, price
FROM book
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
WHERE  date_step_end IS NOT Null and name_step = "Оплата"
    
UNION ALL
    
SELECT title, buy_archive.amount, buy_archive.price
    FROM buy_archive
    INNER JOIN book USING(book_id)
)
SELECT title, SUM(amount) AS Количество, SUM(amount*price) AS Сумма
FROM Title_sales
GROUP BY title
ORDER BY Сумма DESC;

-- Задание 12: Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
INSERT INTO client(name_client, email, city_id) 
SELECT 'Попов Илья', 'popov@test', city.city_id
FROM client INNER JOIN city ON client.city_id = city.city_id
WHERE city.name_city = 'Москва'
LIMIT 1;


-- Задание 13: Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
INSERT INTO buy(client_id, buy_description)
SELECT client_id, 'Связаться со мной по вопросу доставки'
FROM client
WHERE name_client = 'Попов Илья';


-- Задание 14: В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 5, book.book_id, 2
FROM book
    INNER JOIN author ON author.author_id = book.author_id
WHERE author.name_author LIKE 'Пастернак %' AND book.title = 'Лирика';

INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 5, book.book_id, 1
FROM book
    INNER JOIN author ON author.author_id = book.author_id
WHERE author.name_author LIKE 'Булгаков %' AND book.title = 'Белая гвардия';


-- Задание 15: Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, которое в заказе с номером 5  указано.
UPDATE book
    INNER JOIN buy_book ON book.book_id = buy_book.book_id
SET book.amount = book.amount - buy_book.amount
WHERE buy_book.buy_id = 5;


-- Задание 16: Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и  стоимость. Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.
CREATE TABLE buy_pay AS
SELECT title, name_author, book.price, buy_book.amount, book.price * buy_book.amount AS 'Стоимость'
FROM
    buy_book
    INNER JOIN book ON buy_book.book_id = book.book_id
    INNER JOIN author ON book.author_id = author.author_id
WHERE buy_id = 5
ORDER BY title;


-- Задание 17: Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг в заказе (название столбца Количество) и его общую стоимость (название столбца Итого). Для решения используйте ОДИН запрос.
CREATE TABLE buy_pay AS
SELECT buy_book.buy_id AS buy_id, SUM(buy_book.amount) AS Количество, SUM(buy_book.amount * book.price) AS Итого
FROM book INNER JOIN buy_book ON book.book_id = buy_book.book_id
WHERE buy_book.buy_id = 5;


-- Задание 18: В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.
INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
SELECT buy.buy_id, step.step_id, Null, Null
FROM buy, step
WHERE buy.buy_id = 5


-- задание 19: В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5. Правильнее было бы занести не конкретную, а текущую дату. Это можно сделать с помощью функции Now(). Но при этом в разные дни будут вставляться разная дата, и задание нельзя будет проверить, поэтому  вставим дату 12.04.2020.
UPDATE buy_step
    INNER JOIN step ON buy_step.step_id = step.step_id
SET date_step_beg = '2020-04-12'
WHERE buy_step.buy_id = 5 AND step.name_step = 'Оплата';


-- Задание 20: Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.
UPDATE buy_step
    INNER JOIN step ON buy_step.step_id = step.step_id
SET date_step_end = '2020-04-13'
WHERE buy_step.buy_id = 5 AND step.name_step = 'Оплата';

UPDATE buy_step
    INNER JOIN step ON buy_step.step_id = step.step_id
SET date_step_beg = '2020-04-13'
WHERE buy_step.buy_id = 5 AND step.name_step = 'Упаковка';
