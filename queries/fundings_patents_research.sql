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
