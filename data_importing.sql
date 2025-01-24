-- 1. Read in all relevant .csv files as temp tables from https://eto.tech/dataset-docs/country-ai-activity-metrics/

.import --csv ./data/patents_yearly_applications.csv temp_patents_applications
.import --csv ./data/patents_yearly_granted.csv temp_patents_granted
.import --csv ./data/publications_yearly_articles.csv temp_publications_articles
.import --csv ./data/companies_yearly_disclosed.csv temp_companies_disclosed
.import --csv ./data/companies_yearly_estimated.csv temp_companies_estimated

-- 2. Insert countries & research_fields into new tables from the temp tables (with unique values only)

INSERT INTO countries(name)
SELECT DISTINCT country FROM temp_patents_applications
UNION
SELECT DISTINCT country FROM temp_patents_granted
UNION
SELECT DISTINCT country FROM temp_publications_articles
UNION
SELECT DISTINCT country FROM temp_companies_disclosed
UNION
SELECT DISTINCT country FROM temp_companies_estimated
ORDER BY country;

INSERT INTO fields (name)
SELECT DISTINCT field FROM temp_patents_applications
UNION
SELECT DISTINCT field FROM temp_patents_granted
UNION
SELECT DISTINCT field FROM temp_publications_articles
UNION
SELECT DISTINCT field FROM temp_companies_disclosed
UNION
SELECT DISTINCT field FROM temp_companies_estimated
ORDER BY field;

-- 3. Populate the new structured tables with the data from temp tables and countries and fields as FK

INSERT INTO patents_yearly_applications (country_id, field_id, year, amount_applications, complete)
SELECT countries.id, fields.id, temp_patents_applications.year, temp_patents_applications.num_patent_applications, temp_patents_applications.complete
FROM countries JOIN temp_patents_applications
ON countries.name = temp_patents_applications.country
JOIN fields ON fields.name = temp_patents_applications.field;

INSERT INTO patents_yearly_granted (country_id, field_id, year, amount_grants, complete)
SELECT countries.id, fields.id, temp_patents_granted.year, temp_patents_granted.num_patent_granted, temp_patents_granted.complete
FROM countries JOIN temp_patents_granted
ON countries.name = temp_patents_granted.country
JOIN fields ON fields.name = temp_patents_granted.field;

INSERT INTO publications_yearly_articles (country_id, field_id, year, amount_articles, complete)
SELECT countries.id, fields.id, temp_publications_articles.year, temp_publications_articles.num_articles, temp_publications_articles.complete
FROM countries JOIN temp_publications_articles
ON countries.name = temp_publications_articles.country
JOIN fields ON fields.name = temp_publications_articles.field;

INSERT INTO companies_yearly_disclosed (country_id, field_id, year, disclosed_investment, complete)
SELECT countries.id, fields.id, temp_companies_disclosed.year, temp_companies_disclosed.disclosed_investment, temp_companies_disclosed.complete
FROM countries JOIN temp_companies_disclosed
ON countries.name = temp_companies_disclosed.country
JOIN fields ON fields.name = temp_companies_disclosed.field;

INSERT INTO companies_yearly_estimated (country_id, field_id, year, estimated_investment, complete)
SELECT countries.id, fields.id, temp_companies_estimated.year, temp_companies_estimated.estimated_investment, temp_companies_estimated.complete
FROM countries JOIN temp_companies_estimated
ON countries.name = temp_companies_estimated.country
JOIN fields ON fields.name = temp_companies_estimated.field;
