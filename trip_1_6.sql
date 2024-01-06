-- Задание 1: Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а», в отсортированном по убыванию даты последнего дня командировки виде. В результат включить столбцы name, city, per_diem, date_first, date_last.
SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE name LIKE "%а %"
ORDER BY date_last DESC


-- Задание 2: Вывести в алфавитном порядке фамилии и инициалы тех сотрудников, которые были в командировке в Москве.
SELECT DISTINCT name 
FROM trip 
WHERE city ='Москва' 
ORDER BY name;


-- Задание 3: Для каждого города посчитать, сколько раз сотрудники в нем были.  Информацию вывести в отсортированном в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество. 
SELECT city, COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY city;


-- Задание 4: Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество.
SELECT city, COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY COUNT(city) DESC
LIMIT 2;


-- Задание 5: Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город ,  длительность командировки в днях, при этом первый и последний день относится к периоду командировки). Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, а потом по убыванию названий городов (в обратном алфавитном порядке).
SELECT name, city, (DATEDIFF(date_last, date_first) + 1) AS Длительность
FROM trip
WHERE city <> "Москва" AND city <> "Санкт-Петербург"
ORDER BY Длительность DESC, name DESC


-- Задание 6: Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. В результат включить столбцы name, city, date_first, date_last.
SELECT name, city, date_first, date_last
FROM trip
WHERE DATEDIFF(date_last, date_first) = (
    SELECT MIN(DATEDIFF(date_last, date_first))    
    FROM trip
)


-- Задание 7: Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). В результат включить столбцы name, city, date_first, date_last. Строки отсортировать сначала  в алфавитном порядке по названию города, а затем по фамилии сотрудника .
SELECT name, city, date_first, date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city, name


-- Задание 8: Вывести название месяца и количество командировок для каждого месяца. Считаем, что командировка относится к некоторому месяцу, если она началась в этом месяце. Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке по названию месяца виде. Название столбцов – Месяц и Количество.