-- This file is for your solutions to the census question.
-- Lines starting with -- ! are recognised by a script that we will
-- use to automatically test your queries, so you must not change
-- these lines or create any new lines starting with this marker.
--
-- You may break your queries over several lines, include empty
-- lines and SQL comments wherever you wish.
--
-- Remember that the answer to each question goes after the -- !
-- marker for it and that the answer to each question must be
-- a single SQL query.
--
-- Upload this file to SAFE as part of your coursework.

-- !census

-- !question0

-- Sample solution to question 0.
SELECT data FROM Statistic WHERE wardId = 'E05001982' AND
occId = 2 AND gender = 0;

-- !question1

SELECT 
    data
FROM
    Statistic
WHERE
    wardId = 'E05001975' AND occId = 7
        AND gender = 1;

-- !question2

SELECT 
    SUM(data) AS Total
FROM
    Statistic
WHERE
    wardId = 'E05000697' AND occId = 5;

-- !question3

SELECT 
    SUM(s.data) AS num_people, o.name AS occ_class
FROM
    Statistic s
        INNER JOIN
    Occupation o ON s.occId = o.Id
WHERE
    s.wardId = 'E05008884'
GROUP BY o.Id;

-- !question4

SELECT 
    SUM(s.data) AS population,
    w.code AS wardCode,
    w.name AS wardName,
    c.name AS countyName
FROM
    Ward w
        INNER JOIN
    Statistic s ON s.wardId = w.code
        INNER JOIN
    County c ON w.parent = c.code
GROUP BY s.wardId
ORDER BY population ASC
LIMIT 1;

-- !question5

SELECT 
    COUNT(*) AS num_ward
FROM
    (SELECT 
        SUM(s.data) AS population
    FROM
        Statistic s
    INNER JOIN Ward w ON s.wardId = w.code
    GROUP BY s.wardId) AS t
WHERE
    t.population >= 1000;

-- !question6

SELECT 
    r.name AS name, AVG(t.data) AS avg_size
FROM
    (SELECT 
        s.wardId AS wardId, SUM(s.data) AS data
    FROM
        Statistic s
    GROUP BY s.wardId) AS t
        INNER JOIN
    Ward w ON t.wardId = w.code
        INNER JOIN
    County c ON w.parent = c.code
        INNER JOIN
    Region r ON c.parent = r.code
GROUP BY r.code;

-- !question7

SELECT 
    c.name AS CLU,
    o.name AS occupation,
    CASE s.gender
        WHEN 1 THEN 'female'
        WHEN 0 THEN 'male'
        ELSE 'X'
    END AS gender,
    SUM(s.data) AS N
FROM
    Occupation o
        INNER JOIN
    Statistic s ON o.Id = s.occId
        INNER JOIN
    Ward w ON s.wardId = w.code
        INNER JOIN
    County c ON w.parent = c.code
        INNER JOIN
    Region r ON c.parent = r.code
WHERE
    r.code = 'E12000002'
GROUP BY c.code , o.Id , s.gender
HAVING N >= 10000
ORDER BY N;

-- !question8

SELECT 
    t1.region1 AS region,
    t1.men AS men,
    t2.women AS women,
    t2.women / t3.population * 100 AS percent
FROM
    ((SELECT 
        r.name AS region1, SUM(s.data) AS men
    FROM
        Statistic s
    INNER JOIN Ward w ON s.wardId = w.code
    INNER JOIN County c ON w.parent = c.code
    INNER JOIN Region r ON c.parent = r.code
    WHERE
        s.occId = 1 AND s.gender = 0
    GROUP BY r.code) AS t1
    INNER JOIN (SELECT 
        r.name AS region2, SUM(s.data) AS women
    FROM
        Statistic s
    INNER JOIN Ward w ON s.wardId = w.code
    INNER JOIN County c ON w.parent = c.code
    INNER JOIN Region r ON c.parent = r.code
    WHERE
        s.occId = 1 AND s.gender = 1
    GROUP BY r.code) AS t2 ON t1.region1 = t2.region2
    INNER JOIN (SELECT 
        r.name AS region3, SUM(s.data) AS population
    FROM
        Statistic s
    INNER JOIN Ward w ON s.wardId = w.code
    INNER JOIN County c ON w.parent = c.code
    INNER JOIN Region r ON c.parent = r.code
    WHERE
        s.occId = 1
    GROUP BY r.code) AS t3 ON t1.region1 = t3.region3)
ORDER BY percent ASC;

-- !question9

SELECT 
    r.name AS name, AVG(t.data) AS avg_size
FROM
    (SELECT 
        s.wardId AS wardId, SUM(s.data) AS data
    FROM
        Statistic s
    GROUP BY s.wardId) AS t
        INNER JOIN
    Ward w ON t.wardId = w.code
        INNER JOIN
    County c ON w.parent = c.code
        INNER JOIN
    Region r ON c.parent = r.code
GROUP BY r.code 
UNION ALL SELECT 
    'England', AVG(s.data) AS avg_size
FROM
    (SELECT 
        s.wardId AS wardId, SUM(s.data) AS data
    FROM
        Statistic s
    GROUP BY s.wardId) AS s
        INNER JOIN
    Ward w ON s.wardId = w.code
        INNER JOIN
    County c ON w.parent = c.code
        INNER JOIN
    Region r ON c.parent = r.code
        INNER JOIN
    Country ct ON r.parent = ct.code
WHERE
    ct.name = 'England' 
UNION ALL SELECT 
    'All', AVG(s.data) AS avg_size
FROM
    (SELECT 
        s.wardId AS wardId, SUM(s.data) AS data
    FROM
        Statistic s
    GROUP BY s.wardId) AS s;

-- !end
