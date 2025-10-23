CREATE DATABASE cinebase;
USE cinebase;

DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  country_code INT,
  join_year INT,
  premium BOOLEAN
);
CREATE TABLE movies (
  movie_id INT PRIMARY KEY,
  genre_code INT,
  release_year INT,
  duration_min INT
);
CREATE TABLE ratings (
  rating_id INT PRIMARY KEY,
  user_id INT,
  movie_id INT,
  stars INT,
  rated_ymd INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);


EXPLAIN ANALYZE
SELECT
  m.genre_code,
  COUNT(*) AS total_votes,
  ROUND(AVG(r.stars), 2) AS avg_rating,
  (SELECT ROUND(AVG(r2.stars), 2)
   FROM ratings r2
   WHERE SUBSTRING(r2.rated_ymd, 1, 4) = '2024'
     AND r2.stars >= 4
  ) AS overall_avg_rating,
  (SELECT COUNT(*)
   FROM ratings r3
   WHERE SUBSTRING(r3.rated_ymd, 1, 4) = '2024'
     AND r3.stars >= 4
  ) AS overall_votes_all
FROM ratings r
JOIN users u ON r.user_id = u.user_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE
  SUBSTRING(r.rated_ymd, 1, 4) = '2024'
  AND (u.premium + 0) = 1
  AND (r.stars IN (4, 5) OR r.stars >= 4)
  AND m.genre_code IS NOT NULL
  AND r.movie_id NOT IN (
    SELECT r0.movie_id
    FROM ratings r0
    WHERE r0.stars = 0 OR r0.stars IS NULL
  )
GROUP BY m.genre_code
HAVING COUNT(*) > 50
ORDER BY avg_rating DESC, total_votes DESC, m.genre_code
LIMIT 10;


CREATE INDEX index_rat_stars ON ratings (rated_ymd, stars);
CREATE INDEX index_premium     ON users (premium);
CREATE INDEX index_genre      ON movies (genre_code);


EXPLAIN ANALYZE
SELECT  m.genre_code,
  COUNT(*) AS total_votes,
  ROUND(AVG(r.stars), 2) AS avg_rating
FROM ratings r USE INDEX(index_rat_stars)
JOIN users u USE INDEX(index_premium)
 ON r.user_id = u.user_id
JOIN movies m USE INDEX(index_genre)
ON r.movie_id = m.movie_id
WHERE
  r.rated_ymd LIKE '2024%'   
  AND u.premium = 1
  AND r.stars >= 4
  AND m.genre_code IS NOT NULL
GROUP BY m.genre_code
HAVING COUNT(*) > 50
ORDER BY avg_rating DESC, total_votes DESC
LIMIT 10;