-- TOP 20 GLOBAL leaders of total disclosed AI company fundings for certain years
SELECT
countries.name AS "Country",
printf('%,d', companies_yearly_disclosed.disclosed_investment) AS "Total disclosed AI funding in million USD"
FROM countries JOIN companies_yearly_disclosed
ON countries.id = companies_yearly_disclosed.country_id
JOIN fields ON fields.id = companies_yearly_disclosed.field_id
WHERE
companies_yearly_disclosed.year = 2023
AND
fields.name = "All"
ORDER BY
companies_yearly_disclosed.disclosed_investment DESC
LIMIT
20;
