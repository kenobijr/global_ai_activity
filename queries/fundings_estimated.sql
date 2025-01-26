-- TOP 20 GLOBAL leaders of total estimated AI company funding in 2024
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
