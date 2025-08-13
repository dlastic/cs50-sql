-- Look at the crime scene report from July 28, 2024 on Humphrey Street
SELECT description
FROM crime_scene_reports
WHERE year = 2024
    AND month = 7
    AND day = 28
    AND street = 'Humphrey Street';
-- Theft of the CS50 duck at 10:15am at Humphrey Street bakery.
-- Three witnesses were present; all mention the bakery in their transcripts.

-- Look at the three interviews mentioning the word 'bakery'
SELECT transcript
FROM interviews
WHERE year = 2024
    AND month = 7
    AND day = 28
    AND transcript LIKE '%bakery%';
-- Witness 1: Thief entered a car in the bakery parking lot and drove away within 10 minutes of the theft.
-- Witness 2: Thief was seen withdrawing money at the Leggett Street ATM before visiting Emma's bakery.
-- Witness 3: Thief made a short (less than a minute) phone call arranging the earliest flight out of Fiftyville for the next day.


-- Save owners of the cars that left the bakery parking lot
CREATE TEMPORARY TABLE car_people AS
SELECT p.name
FROM people AS p
JOIN bakery_security_logs AS b
    ON p.license_plate = b.license_plate
WHERE b.year = 2024
    AND b.month = 7
    AND b.day = 28
    AND b.hour = 10
    AND b.minute > 15
    AND b.minute < 25
    AND b.activity = 'exit';

-- Save the people who withdrew money on Leggett Street on the day of the theft
CREATE TEMPORARY TABLE atm_people AS
SELECT p.name
FROM people AS p
JOIN bank_accounts AS ba
    ON p.id = ba.person_id
JOIN atm_transactions AS a
    ON ba.account_number = a.account_number
WHERE a.year = 2024
    AND a.month = 7
    AND a.day = 28
    AND a.atm_location = 'Leggett Street'
    AND a.transaction_type = 'withdraw';

-- Save people who made phone calls lasting less than a minute
CREATE TEMPORARY TABLE calls_people AS
SELECT p.name
FROM people AS p
JOIN phone_calls AS c
    ON p.phone_number = c.caller
WHERE c.year = 2024
    AND c.month = 7
    AND c.day = 28
    AND c.duration < 60;

-- Save passengers on the earliest flight out of Fiftyville the day after the theft
CREATE TEMPORARY TABLE passengers_people AS
SELECT p.name
FROM flights AS f
JOIN passengers AS pa
    ON f.id = pa.flight_id
JOIN people AS p
    ON pa.passport_number = p.passport_number
WHERE f.year = 2024
    AND f.month = 7
    AND f.day = 29
    AND f.id = (
        SELECT id
        FROM flights
        WHERE year = 2024
            AND month = 7
            AND day = 29
        ORDER BY hour, minute
        LIMIT 1
    );

-- Find the thief (intersection of all the people from the previous tables)
CREATE TEMPORARY TABLE thief AS
SELECT name FROM car_people
INTERSECT SELECT name FROM atm_people
INTERSECT SELECT name FROM calls_people
INTERSECT SELECT name FROM passengers_people;

SELECT name AS Thief FROM thief;

-- Find the thief's destination (thief planned to take the earliest flight out of Fiftyville the next day)
SELECT a.city AS "Thief's destination"
FROM flights AS f
JOIN airports AS a
    ON f.destination_airport_id = a.id
WHERE f.year = 2024
    AND f.month = 7
    AND f.day = 29
ORDER BY f.hour
LIMIT 1;

-- Find the thief's accomplice (the person they called)
SELECT p2.name AS "Thief's accomplice"
FROM thief AS t
JOIN people AS p1
    ON t.name = p1.name
JOIN phone_calls AS c
    ON p1.phone_number = c.caller
JOIN people AS p2
    ON c.receiver = p2.phone_number
WHERE c.year = 2024
    AND c.month = 7
    AND c.day = 28
    AND c.duration < 60;
