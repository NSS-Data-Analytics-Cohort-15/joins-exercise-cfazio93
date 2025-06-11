SELECT *
FROM revenue; 

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT film_title, release_year, worldwide_gross
FROM specs
INNER JOIN revenue
USING (movie_id)
ORDER BY revenue.worldwide_gross ASC
LIMIT 1; 

--answer: Semi-Tough, 1977, 37187139

-- 2. What year has the highest average imdb rating?

SELECT specs.release_year, AVG(rating.imdb_rating) AS avg_imdb_rating
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY specs.release_year
ORDER BY avg_imdb_rating DESC; 
--answer: 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT *
FROM specs
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
WHERE specs.mpaa_rating = 'G'
ORDER BY revenue.worldwide_gross DESC
LIMIT 1;
--answer Toy Story 4, Walt Disney


-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT distributors.company_name, COUNT(specs.film_title)
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY COUNT(specs.film_title) DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT AVG(revenue.film_budget) AS avg_film_budget, distributors.company_name
FROM revenue
INNER JOIN specs
ON revenue.movie_id = specs.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
GROUP BY distributors.company_name
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;
--answer: Disney, Sony, Lionsgate, DreamWorks, Warner Bros

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT specs.film_title, rating.imdb_rating
FROM specs
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
INNER JOIN rating
ON specs.movie_id = rating.movie_id
WHERE distributors.headquarters NOT LIKE '%, CA'
ORDER BY rating.imdb_rating DESC; 
--answer: 2 movies, highest rating is Dirty Dancing

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
--can go back and do with CASE
SELECT AVG(rating.imdb_rating) AS avg_imdb_rating
FROM rating
INNER JOIN specs
ON rating.movie_id = specs.movie_id
WHERE specs.length_in_min < '120';
--avg rating for movies under 2 hours = 6.92

SELECT AVG(rating.imdb_rating) AS avg_imdb_rating
FROM rating
INNER JOIN specs
ON rating.movie_id = specs.movie_id
WHERE specs.length_in_min >= '120';
--avg rating for movies over 2 hours =7.25
--answer: movies over 2 hours long have a higher avg rating

--from Jennifer, need to fix..also just learned CASE today
--SELECT CASE
--(WHEN specs.length_in_min > 120, THEN 'over hours'
--WHEN specs.length_in_min <120, THEN 'under hours'
--END AS film_length_category,)
--AVG(rating.imdb_rating) AS imdb_rating
--FROM specs
--JOIN rating
--ON specs.movie_id = rating.movie_id
--GROUP BY film_length_category;