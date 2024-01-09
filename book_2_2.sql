-- Задание 1: Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
SELECT title, name_genre, price
FROM
    genre INNER JOIN book
    ON genre.genre_id = book.genre_id
WHERE amount > 8
ORDER BY price DESC;


-- Задание 2: Вывести все жанры, которые не представлены в книгах на складе.
SELECT name_genre
FROM 
    genre LEFT JOIN book
    ON genre.genre_id = book.genre_id
WHERE title IS NULL;


