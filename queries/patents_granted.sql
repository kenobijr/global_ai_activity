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
