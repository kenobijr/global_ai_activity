-- TOP 20 GLOBAL leaders of total patents applications and granted combined for a year; sorted by "granted"; change year by CTE for whole query
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
