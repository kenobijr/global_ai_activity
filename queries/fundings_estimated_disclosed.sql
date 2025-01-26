-- TOP 20 GLOBAL leaders of total estimated and disclosed AI company funding in 2024; sorted by estimated funding; change year by CTE for whole query
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
