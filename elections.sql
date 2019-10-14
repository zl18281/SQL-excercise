-- The comment lines starting -- ! are used by the automatic testing tool to
-- help mark your coursework. You must not modify them or add further lines
-- starting with -- !. Of course you can create comments of your own, just use
-- the normal -- to start them.

-- !elections

-- !question0
-- This is an example question and answer.

SELECT Party.name FROM Party 
JOIN Candidate ON Candidate.party = Party.id 
WHERE Candidate.name = 'Mark Bradshaw';

-- !question1
SELECT DISTINCT
    p.name
FROM
    Party p
        INNER JOIN
    Candidate c ON p.id = c.party
ORDER BY p.name;

-- !question2
SELECT 
    SUM(c.votes)
FROM
    Candidate c;

-- !question3
SELECT 
    c.name, c.votes
FROM
    Candidate c
        JOIN
    Ward w ON c.ward = w.id
WHERE
    w.name = 'Bedminster';

-- !question4
SELECT 
    SUM(c.votes)
FROM
    Party p
        INNER JOIN
    Candidate c ON p.id = c.party
        INNER JOIN
    Ward w ON c.ward = w.id
WHERE
    p.name = 'Liberal Democrat'
        AND w.name = 'Filwood';

-- !question5
SELECT 
    c.name AS name, p.name AS party, c.votes AS votes
FROM
    Party p
        INNER JOIN
    Candidate c ON p.id = c.party
        INNER JOIN
    Ward w ON c.ward = w.id
WHERE
    w.name = 'Hengrove'
ORDER BY c.votes DESC;

-- !question6
SELECT 
    COUNT(*) AS RANK
FROM
    (SELECT 
        p.name AS Party, SUM(c.votes) AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id
    WHERE
        w.name = 'Bishopsworth'
    GROUP BY p.id
    ORDER BY c.votes) AS t
WHERE
    t.Votes >= (SELECT 
            SUM(c.votes)
        FROM
            Party p
                INNER JOIN
            Candidate c ON p.id = c.party
                INNER JOIN
            Ward w ON c.ward = w.id
        WHERE
            w.name = 'Bishopsworth'
                AND p.name = 'Labour');

-- !question7
SELECT 
    Ward AS Ward, (Votes / Votes2) * 100 AS Percent
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        p.name AS Party, w.name AS Ward, c.votes AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id) AS Temp1
    JOIN (SELECT 
        Ward AS Ward2, SUM(Votes) AS Votes2
    FROM
        (SELECT 
        p.name AS Party, w.name AS Ward, c.votes AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id) AS s
    GROUP BY Ward) AS Temp2 ON Temp1.Ward = Temp2.Ward2) AS Temp3
WHERE
    Party = 'Green';

-- !question8
SELECT 
    *
FROM
    (SELECT 
        six.Ward AS ward,
            (three.Votes - six.Votes) / w.electorate * 100 AS rel,
            (three.Votes - six.Votes) AS abs
    FROM
        (SELECT 
        Ward, Votes, (Votes / Votes2) * 100 AS Percent
    FROM
        (SELECT 
        p.name AS Party, w.name AS Ward, c.votes AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id) AS Temp1
    JOIN (SELECT 
        Ward AS Ward2, SUM(Votes) AS Votes2
    FROM
        (SELECT 
        p.name AS Party, w.name AS Ward, c.votes AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id) AS s1
    GROUP BY Ward) AS Temp2 ON Temp1.Ward = Temp2.Ward2
    WHERE
        Party = 'Green') AS three
    JOIN (SELECT 
        Ward, Votes, (Votes / Votes2) * 100 AS Percent
    FROM
        (SELECT 
        p.name AS Party, w.name AS Ward, c.votes AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id) AS Temp4
    JOIN (SELECT 
        Ward AS Ward2, SUM(Votes) AS Votes2
    FROM
        (SELECT 
        p.name AS Party, w.name AS Ward, c.votes AS Votes
    FROM
        Party p
    INNER JOIN Candidate c ON p.id = c.party
    INNER JOIN Ward w ON c.ward = w.id) AS s2
    GROUP BY Ward) AS Temp5 ON Temp4.Ward = Temp5.Ward2
    WHERE
        Party = 'Labour') six ON three.Ward = six.Ward
    JOIN Ward w ON w.name = six.Ward
    WHERE
        three.Votes > six.Votes) AS t

-- !end
