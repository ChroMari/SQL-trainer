-- Задание 1: Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.
SELECT name_student, date_attempt, result
FROM attempt
    INNER JOIN subject ON attempt.subject_id = subject.subject_id
    INNER JOIN student ON attempt.student_id = student.student_id
WHERE name_subject = 'Основы баз данных'
ORDER BY result DESC;


-- Задание 2: Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой. Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.  В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.
SELECT name_subject, COUNT(result) AS Количество, ROUND(AVG(result), 2) AS Среднее
FROM subject LEFT JOIN attempt ON subject.subject_id = attempt.subject_id
GROUP BY subject.subject_id
ORDER BY Среднее DESC;


-- Задание 3: Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента. Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать.
SELECT name_student, result
FROM attempt INNER JOIN student ON attempt.student_id = student.student_id
WHERE result = (
    SELECT MAX(result)
    FROM attempt
)
ORDER BY name_student;


-- Задание 4: Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой. В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы. Студентов, сделавших одну попытку по дисциплине, не учитывать. 
SELECT name_student, name_subject, DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS Интервал
FROM attempt 
    INNER JOIN student ON attempt.student_id = student.student_id
    INNER JOIN subject ON attempt.subject_id = subject.subject_id
GROUP BY name_student, name_subject
HAVING COUNT(result) > 1
ORDER BY Интервал ASC;


-- Задание 5: Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины. В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0.
SELECT name_subject, COUNT(DISTINCT(student_id)) AS Количество
FROM subject LEFT JOIN attempt ON subject.subject_id = attempt.subject_id
GROUP BY subject.subject_id
ORDER BY Количество DESC, name_subject;


-- Задание 6: Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.
SELECT question_id, name_question
FROM question INNER JOIN subject ON question.subject_id = subject.subject_id
WHERE name_subject = 'Основы баз данных'
ORDER BY RAND()
LIMIT 3;


-- Задание 7: Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17  (значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат.
SELECT name_question, name_answer, IF(is_correct, "Верно", "Неверно") AS Результат
FROM testing
    INNER JOIN question ON testing.question_id = question.question_id
    INNER JOIN answer ON testing.answer_id = answer.answer_id
WHERE attempt_id = 7;


-- Задание 8: В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». Установить текущую дату в качестве даты выполнения попытки.
INSERT INTO attempt(student_id, subject_id, date_attempt)
SELECT student_id, subject_id, NOW()
FROM  student, subject
WHERE name_student = 'Баранов Павел' and name_subject = 'Основы баз данных' ;


-- Задание 9: Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing. id последней попытки получить как максимальное значение id из таблицы attempt.

-- Задание 10: 


-- Задание 11: Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing
DELETE FROM attempt
WHERE date_attempt < '2020-05-1';
