-- TOP 20 GLOBAL leaders of total published research articles for certain years
SELECT
countries.name AS "Country / Block",
printf('%,d', publications_yearly_articles.amount_articles) AS "Total AI publications"
FROM countries JOIN publications_yearly_articles
ON countries.id = publications_yearly_articles.country_id
JOIN fields ON fields.id = publications_yearly_articles.field_id
WHERE
publications_yearly_articles.year = 2023
AND
fields.name = "All"
ORDER BY
publications_yearly_articles.amount_articles DESC
LIMIT
20;
