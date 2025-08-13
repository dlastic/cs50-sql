SELECT people.name
FROM people
JOIN stars
    ON people.id = stars.person_id
JOIN movies
    ON stars.movie_id = movies.id
JOIN stars AS stars_bacon
    ON movies.id = stars_bacon.movie_id
JOIN people AS people_bacon
    ON stars_bacon.person_id = people_bacon.id
WHERE people_bacon.name = 'Kevin Bacon'
  AND people_bacon.birth = 1958
  AND people.name != 'Kevin Bacon';
