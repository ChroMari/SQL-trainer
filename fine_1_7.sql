-- Задание 1: Создать таблицу fine.
CREATE TABLE fine (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE
);


-- Задание 2: Добавить в таблицу записи с ключевыми значениями 6, 7, 8.
INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES 
    ("Баранов П.Е.", "Р523ВТ", "Превышение скорости(от 40 до 60)", NULL, "2020-02-14", NULL),
    ("Абрамова К.А.", "О111АВ", "Проезд на запрещающий сигнал", NULL, "2020-02-23", NULL),
    ("Яковлев Г.Р.", "Т330ТТ", "Проезд на запрещающий сигнал", NULL, "2020-03-03", NULL);


-- Задание 3: Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.
UPDATE fine, traffic_violation
SET fine.sum_fine = traffic_violation.sum_fine
WHERE fine.sum_fine IS NULL AND fine.violation = traffic_violation.violation


-- Задание 4: Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило   два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет. Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(name) > 1
ORDER BY name, number_plate, violation


-- Задание 5: В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 
UPDATE fine, (
    SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(name) > 1
    ) query_in
SET fine.sum_fine = fine.sum_fine * 2
WHERE fine.date_payment IS NULL AND fine.name = query_in.name AND fine.number_plate = query_in.number_plate AND fine.violation = query_in.violation
-- WHERE (f.name, f.number_plate, f.violation) =  (q_in.name, q_in.number_plate, q_in.violation) AND f.date_payment IS Null;


-- Задание 6: в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
-- уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE fine, payment
SET fine.date_payment = payment.date_payment,
    fine.sum_fine = IF(DATEDIFF(payment.date_payment, payment.date_violation) <= 20, fine.sum_fine / 2, fine.sum_fine)
WHERE (fine.name, fine.number_plate, fine.violation) = (payment.name, payment.number_plate, payment.violation) AND fine.date_payment IS NULL;


-- Задание 7: Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
CREATE TABLE back_payment AS (
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE fine.date_payment IS NULL
    );


-- Задание 8: Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 
DELETE FROM fine
WHERE date_violation < "2020-02-01";
