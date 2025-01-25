-- Create table with countries (only unique values)
CREATE TABLE countries (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

-- Create table with research fields (only unique values)
CREATE TABLE fields (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

-- Create table for yearly patent applications
CREATE TABLE patents_yearly_applications (
    id INTEGER,
    country_id INTEGER,
    field_id INTEGER,
    year INTEGER NOT NULL,
    amount_applications INTEGER NOT NULL,
    complete TEXT CHECK(complete IN ("True", "False")),
    PRIMARY KEY(id),
    FOREIGN KEY(country_id) REFERENCES countries(id),
    FOREIGN KEY(field_id) REFERENCES fields(id)
);

-- Create table for yearly patent grants
CREATE TABLE patents_yearly_granted (
    id INTEGER,
    country_id INTEGER,
    field_id INTEGER,
    year INTEGER NOT NULL,
    amount_grants INTEGER NOT NULL,
    complete TEXT CHECK(complete IN ("True", "False")),
    PRIMARY KEY(id),
    FOREIGN KEY(country_id) REFERENCES countries(id),
    FOREIGN KEY(field_id) REFERENCES fields(id)
);

-- Create table for yearly disclosed investments into companies
CREATE TABLE companies_yearly_disclosed (
    id INTEGER,
    country_id INTEGER,
    field_id INTEGER,
    year INTEGER NOT NULL,
    disclosed_investment INTEGER NOT NULL,
    complete TEXT CHECK(complete IN ("True", "False")),
    PRIMARY KEY(id),
    FOREIGN KEY(country_id) REFERENCES countries(id),
    FOREIGN KEY(field_id) REFERENCES fields(id)
);

-- Create table for yearly estimated investments into companies
CREATE TABLE companies_yearly_estimated (
    id INTEGER,
    country_id INTEGER,
    field_id INTEGER,
    year INTEGER NOT NULL,
    estimated_investment INTEGER NOT NULL,
    complete TEXT CHECK(complete IN ("True", "False")),
    PRIMARY KEY(id),
    FOREIGN KEY(country_id) REFERENCES countries(id),
    FOREIGN KEY(field_id) REFERENCES fields(id)
);

-- Create table for yearly publicated research articles
CREATE TABLE publications_yearly_articles (
    id INTEGER,
    country_id INTEGER,
    field_id INTEGER,
    year INTEGER NOT NULL,
    amount_articles INTEGER NOT NULL,
    complete TEXT CHECK(complete IN ("True", "False")),
    PRIMARY KEY(id),
    FOREIGN KEY(country_id) REFERENCES countries(id),
    FOREIGN KEY(field_id) REFERENCES fields(id)
);

-- Create index to speed up queries for published articles for certain years
CREATE INDEX
    publications_per_year
ON
    publications_yearly_articles(year);

-- Create index to speed up queries for disclosed and estimated fundings for certain years
CREATE INDEX
    disclosed_funding_per_year
ON
    companies_yearly_disclosed(year);

CREATE INDEX
    estimated_funding_per_year
ON
    companies_yearly_estimated(year);

-- Create index to speed up queries for applied and granted patents for certain years
CREATE INDEX
    applied_patents_per_year
ON
    patents_yearly_applications(year);

CREATE INDEX
    granted_patents_per_year
ON
    patents_yearly_granted(year);

-- Create view for publications (all years, all fields)
CREATE VIEW
    v_publications AS
SELECT
    c.name  AS country,
    p.year  AS year,
    f.name  AS field,
    p.amount_articles AS amount_publications
FROM
    publications_yearly_articles p
JOIN
    countries c
ON
    c.id = p.country_id
JOIN
    fields f
ON
    f.id = p.field_id;
