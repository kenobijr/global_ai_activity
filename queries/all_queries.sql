-- TOP 20 GLOBAL leaders of total published research articles in 2024
SELECT
countries.name AS "Country / Block",
printf('%,d', publications_yearly_articles.amount_articles) AS "Total AI publications"
FROM countries JOIN publications_yearly_articles
ON countries.id = publications_yearly_articles.country_id
JOIN fields ON fields.id = publications_yearly_articles.field_id
WHERE
publications_yearly_articles.year = 2024
AND
fields.name = "All"
ORDER BY
publications_yearly_articles.amount_articles DESC
LIMIT
20;

-- TOP 20 GLOBAL leaders of total estimated AI company fundings in 2024
SELECT
countries.name AS "Country",
printf('%,d', companies_yearly_estimated.estimated_investment) AS "Total estimated AI funding in million USD"
FROM countries JOIN companies_yearly_estimated
ON countries.id = companies_yearly_estimated.country_id
JOIN fields ON fields.id = companies_yearly_estimated.field_id
WHERE
companies_yearly_estimated.year = 2024
AND
fields.name = "All"
ORDER BY
companies_yearly_estimated.estimated_investment DESC
LIMIT
20;

-- TOP 20 GLOBAL leaders of total disclosed AI company fundings in 2024
SELECT
countries.name AS "Country",
printf('%,d', companies_yearly_disclosed.disclosed_investment) AS "Total disclosed AI funding in million USD"
FROM countries JOIN companies_yearly_disclosed
ON countries.id = companies_yearly_disclosed.country_id
JOIN fields ON fields.id = companies_yearly_disclosed.field_id
WHERE
companies_yearly_disclosed.year = 2024
AND
fields.name = "All"
ORDER BY
companies_yearly_disclosed.disclosed_investment DESC
LIMIT
20;

-- TOP 20 GLOBAL leaders of total estimated and disclosed AI company fundings in 2024; sorted by estimated fundings; change year by CTE for whole query
WITH chosen_year AS (
    SELECT 2024 AS y
),
est AS (
    SELECT
        ce.country_id,
        ce.estimated_investment
    FROM companies_yearly_estimated ce
    JOIN fields f
      ON f.id = ce.field_id
    WHERE
        ce.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
),
disc AS (
    SELECT
        cd.country_id,
        cd.disclosed_investment
    FROM companies_yearly_disclosed cd
    JOIN fields f
      ON f.id = cd.field_id
    WHERE
        cd.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
)
SELECT
    c.name AS "Country",
    printf('%,d', e.estimated_investment) AS "Total estimated AI funding in million USD",
    printf('%,d', d.disclosed_investment) AS "Total disclosed AI funding in million USD"
FROM est e
JOIN countries c
    ON c.id = e.country_id
LEFT JOIN disc d
    ON d.country_id = e.country_id
ORDER BY
    e.estimated_investment DESC
LIMIT 20;

-- TOP 20 GLOBAL leaders of total patents granted in 2023
SELECT
countries.name AS "Country",
printf('%,d', patents_yearly_granted.amount_grants) AS "Total AI patents granted"
FROM countries JOIN patents_yearly_granted
ON countries.id = patents_yearly_granted.country_id
JOIN fields ON fields.id = patents_yearly_granted.field_id
WHERE
patents_yearly_granted.year = 2023
AND
fields.name = "All"
ORDER BY
patents_yearly_granted.amount_grants DESC
LIMIT
20;

-- TOP 20 GLOBAL leaders of total patents applications in 2023
SELECT
countries.name AS "Country",
printf('%,d', patents_yearly_applications.amount_applications) AS "Total AI patent applications"
FROM countries JOIN patents_yearly_applications
ON countries.id = patents_yearly_applications.country_id
JOIN fields ON fields.id = patents_yearly_applications.field_id
WHERE
patents_yearly_applications.year = 2023
AND
fields.name = "All"
ORDER BY
patents_yearly_applications.amount_applications DESC
LIMIT
20;

-- TOP 20 GLOBAL leaders of total patents applications and granted combined in 2023; sorted by "granted"; change year by CTE for whole query
WITH chosen_year AS (
    SELECT 2023 AS y
),
granted AS (
    SELECT
        pg.country_id,
        pg.amount_grants
    FROM patents_yearly_granted pg
    JOIN fields f
      ON f.id = pg.field_id
    WHERE
        pg.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
),
applications AS (
    SELECT
        pa.country_id,
        pa.amount_applications
    FROM patents_yearly_applications pa
    JOIN fields f
      ON f.id = pa.field_id
    WHERE
        pa.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
)
SELECT
    c.name AS "Country",
    printf('%,d', g.amount_grants)         AS "Total AI patents granted",
    printf('%,d', a.amount_applications)   AS "Total AI patent applications"
FROM granted g
JOIN countries c
    ON c.id = g.country_id
LEFT JOIN applications a
    ON a.country_id = g.country_id
ORDER BY
    g.amount_grants DESC
LIMIT 20;

-- TOP 50 GLOBAL LEADERSHIP board with funding, patents and research papers combined in 2024; sorted by total funds; change year by CTE for whole query
WITH chosen_year AS (
    SELECT 2024 AS y
),
est AS (
    SELECT
        ce.country_id,
        ce.estimated_investment
    FROM companies_yearly_estimated ce
    JOIN fields f
      ON f.id = ce.field_id
    WHERE
        ce.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
),
disc AS (
    SELECT
        cd.country_id,
        cd.disclosed_investment
    FROM companies_yearly_disclosed cd
    JOIN fields f
      ON f.id = cd.field_id
    WHERE
        cd.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
),
granted AS (
    SELECT
        pg.country_id,
        pg.amount_grants
    FROM patents_yearly_granted pg
    JOIN fields f
      ON f.id = pg.field_id
    WHERE
        pg.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
),
applications AS (
    SELECT
        pa.country_id,
        pa.amount_applications
    FROM patents_yearly_applications pa
    JOIN fields f
      ON f.id = pa.field_id
    WHERE
        pa.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
),
articles AS (
    SELECT
        ar.country_id,
        ar.amount_articles
    FROM publications_yearly_articles ar
    JOIN fields f
      ON f.id = ar.field_id
    WHERE
        ar.year = (SELECT y FROM chosen_year)
        AND f.name = 'All'
)
SELECT
    c.name AS "Country / Block",
    printf('%,d', e.estimated_investment)               AS "Total estimated AI funding in million USD",
    printf('%,d', d.disclosed_investment)               AS "Total disclosed AI funding in million USD",
    printf('%,d', g.amount_grants)                      AS "Total AI patents granted",
    printf('%,d', app.amount_applications)              AS "Total AI patent applications",
    printf('%,d', art.amount_articles)                  AS "Total AI publications"
FROM est e
JOIN countries c
    ON c.id = e.country_id
LEFT JOIN disc d
    ON d.country_id = e.country_id
LEFT JOIN granted g
    ON g.country_id = e.country_id
LEFT JOIN applications app
    ON app.country_id = e.country_id
LEFT JOIN articles art
    ON art.country_id = e.country_id
ORDER BY
    e.estimated_investment DESC
LIMIT 50;
