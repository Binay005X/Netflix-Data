CREATE DATABASE Netflix_db;

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

SELECT * FROM netflix;

SELECT COUNT(*)FROM netflix;

SELECT DISTINCT(type) from netflix;


---- Business problems ---

--- 1. Count the number of movies vs TV Shows. ---

SELECT type, count(*) as total_content 
FROM netflix
GROUP BY type;

--- 2. Find the most common rating for movies and TV shows. --

SELECT 
	type,
	rating
FROM (

	SELECT 
		type, 
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
	-- ORDER BY 1,3 DESC;
     ) as t1
	 
	WHERE 
		ranking = 1


--- 3. List all movies released in a specific year (e.g., 2020) ---

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

--- 4. Find the top 5 countries with the most content on Netflix ---

SELECT
		UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- SELECT 
-- 	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country
-- FROM netflix;


--- 5. Identify the longest movie ? ---

SELECT * FROM NETFLIX
WHERE  
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM NETFLIX)


--- 6. Find the content added in the last 5 years --- 

SELECT *
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY ') >= CURRENT_DATE - INTERVAL '5 years'
	

SELECT CURRENT_DATE - INTERVAL '5 years'


--- 7. Find all the movies/TV shows by director 'Rajiv Chilaka' ---

SELECT * FROM NETFLIX
WHERE director ILIKE '%Rajiv Chilaka%'


--- 8. List all the TV shows with more than 5 seasons

SELECT
	* 
FROM NETFLIX
WHERE 
	type = 'TV Show'
		AND
		SPLIT_PART (duration, ' ', 1)::numeric > 5 


 --- 9. Count the number of content items in each genre ---

SELECT
	UNNEST(	STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id)
FROM netflix
GROUP BY 1


--- 10. Find each year and the average numbers of content release by India on netflix --
--- return the top 5 year with highest avg content release.

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as date,
	COUNT(*) as yearly_content,
	ROUND(
		COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
		 , 2) as avg_content_per_year 
FROM netflix
WHERE country = 'India'
GROUP BY 1


--- 11. List all the movies that are documentaries ---

SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'


--- 12. Find all content without a director ---

SELECT * FROM netflix
WHERE
	director IS NULL


--- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years ! ---


SELECT * FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
 

--- 14. Find the top 10 actors who appeared in the higest number of movies produced in India ---

SELECT 
-- show_id,
-- Casts,
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC


--- 15. Categorize the content based on the presence of the keyword 'kill' and 'violence' in 
--- the description field. Label content containg these keywords as 'Bad' and all other content
--- as 'Good'. Count how many items fall into each category.

WITH new_table
AS (

	SELECT 
	*,
		CASE
		WHEN 
			description ILIKE '%kill%'
			OR
		    description ILIKE '%violence%' THEN 'Bad_Content'
			ELSE 'Good_Content'
		END category
	FROM netflix
	)

SELECT 
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1






-- WHERE 
-- 	description ILIKE '%kill%'
-- 	OR
-- 	description ILIKE '%violence%' THEN 'Bad_Content'




 


