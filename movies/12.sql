SELECT movies.title
FROM movies
JOIN stars AS stars_cooper
    ON movies.id = stars_cooper.movie_id
JOIN people AS people_cooper
    ON stars_cooper.person_id = people_cooper.id
JOIN stars AS stars_lawrence
    ON movies.id = stars_lawrence.movie_id
JOIN people AS people_lawrence
    ON stars_lawrence.person_id = people_lawrence.id
WHERE people_cooper.name = 'Bradley Cooper'
  AND people_lawrence.name = 'Jennifer Lawrence';
