-- TOP 20 GLOBAL leaders of total patents applications in year
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
