# Global AI Activity Tracking DB

By Peter

Video overview: [(https://youtu.be/AhGf7PMjHfk)]

---

## Scope

The primary purpose of this database is to capture and track global AI-related activity across multiple dimensions, including intellectual property (patent applications and grants), academic output (research publications), and financial investments (both disclosed and estimated). Data source a is a set of `.csv` files published by the “Emerging Technology Observatory” at Georgetown University. (https://cat.eto.tech/)

**In-Scope Entities**
- **Countries**: Each country in the world (or in the data source) that participates in AI-related activities, such as patent filing and research publications.
- **Research Fields**: Specific AI-related or technology-related fields, such as Machine Learning, Natural Language Processing, Computer Vision, etc.
- **Yearly Patent Activities**: Yearly counts of patent applications and grants across fields and countries.
- **Yearly Investment Data**: Disclosed and estimated investments in AI companies, organized by country, field, and year.
- **Yearly Publications**: Research articles published in AI fields, aggregated by country, field, and year.

**Out-of-Scope**
- **Granular Company-Specific Details**: While we track annual disclosed and estimated investments, we do not store the names or profiles of individual AI companies.
- **Detailed Patent Metadata**: Patent text, claim details, or patent examiners’ information are not included.
- **Research Article Citation Networks**: We only store aggregated publication counts, not citation references or co-author networks.
- **Demographic or Socio-Economic Data**: Although these factors might influence AI activity, we do not track population data, GDP, or demographic distribution here.

By keeping the data model focused on macro-level metrics—patent activity, publication counts, and investment flows a comprehensive but streamlined view of global AI dynamics is facilitated.

---

## Functional Requirements

The database is designed to facilitate:

1. **Longitudinal Analysis**: Users can query patent, publication, and investment data across multiple years to identify trends, growth rates, and shifts in AI activity over time.
2. **Cross-Country Comparisons**: Because we standardize data under a single schema, it becomes easy to compare the same metrics (e.g., patent grants, investment levels) across different countries.
3. **Field-Specific Insights**: By segmenting the data by AI-related fields, analysts can see which specializations are driving research and where investments are flowing.
4. **Data Quality Checks**: The `complete` column in each fact table allows users to distinguish between fully validated vs. partial or incomplete data. The predefined queries use all data.

**Beyond the Scope**
- **Real-Time Updates**: This database does not handle real-time streaming or event-based updates. Data is loaded in periodic batches (e.g., annually or quarterly).
- **Advanced Predictive Modeling**: While the database can store historical data, advanced analytics or machine learning predictions must be performed outside the database itself, in a separate environment (e.g., Python notebooks or BI tools).
- **Fine-Grained Company / Patent Tracking**: Users can’t do in-depth tracking of every single patent or investment transaction at a micro level.

---

## Representation

### Entities

The database is focused on six main tables representing different aspects of AI-related activity, plus auxiliary tables for reference data and views for optimized querying.

1. **Countries**
   - **Attributes**: `id (INTEGER, PK)`, `name (TEXT, UNIQUE, NOT NULL)`
   - **Reasoning**: A separate `countries` table wa created to avoid repeating country names throughout the dataset. The `id` is the primary key referenced by other tables. Uniqueness is enforced on the name to avoid duplicates.

2. **Fields**
   - **Attributes**: `id (INTEGER, PK)`, `name (TEXT, UNIQUE, NOT NULL)`
   - **Reasoning**: Analogous to "Countries" , a `fields` table for the various AI research areas or technology fields is created.

3. **Patents Yearly Applications**
   - **Attributes**:
     - `id (INTEGER, PK)`
     - `country_id (INTEGER, FK -> countries.id)`
     - `field_id (INTEGER, FK -> fields.id)`
     - `year (INTEGER NOT NULL)`
     - `amount_applications (INTEGER NOT NULL)`
     - `complete (TEXT CHECK(complete IN ("True","False")))`
   - **Reasoning**: This table represents the annual count of patent applications. `NOT NULL` is enforced on crucial metrics (year and amount_applications) to ensure data is always present. The `complete` column is used to indicate data completeness.

4. **Patents Yearly Granted**
   - **Attributes**:
     - `id (INTEGER, PK)`
     - `country_id (INTEGER, FK -> countries.id)`
     - `field_id (INTEGER, FK -> fields.id)`
     - `year (INTEGER NOT NULL)`
     - `amount_grants (INTEGER NOT NULL)`
     - `complete (TEXT CHECK(complete IN ("True","False")))`
   - **Reasoning**: Similar to patent applications, but for granted patents. This separation enables to distinguish between patent pipeline volume (applications) vs. completed results (grants).

5. **Companies Yearly Disclosed**
   - **Attributes**:
     - `id (INTEGER, PK)`
     - `country_id (INTEGER, FK -> countries.id)`
     - `field_id (INTEGER, FK -> fields.id)`
     - `year (INTEGER NOT NULL)`
     - `disclosed_investment (INTEGER NOT NULL)`
     - `complete (TEXT CHECK(complete IN ("True","False")))`
   - **Reasoning**: Stores official or publicly disclosed investment data. Having a separate table for disclosed vs. estimated investments allows users to compare the difference between official statements and approximate valuations.

6. **Companies Yearly Estimated**
   - **Attributes**:
     - `id (INTEGER, PK)`
     - `country_id (INTEGER, FK -> countries.id)`
     - `field_id (INTEGER, FK -> fields.id)`
     - `year (INTEGER NOT NULL)`
     - `estimated_investment (INTEGER NOT NULL)`
     - `complete (TEXT CHECK(complete IN ("True","False")))`
   - **Reasoning**: Some investments may not be fully disclosed publicly, so estimations are important for capturing the broader picture of AI funding. Disclosed fundings are included in it.

7. **Publications Yearly Articles**
   - **Attributes**:
     - `id (INTEGER, PK)`
     - `country_id (INTEGER, FK -> countries.id)`
     - `field_id (INTEGER, FK -> fields.id)`
     - `year (INTEGER NOT NULL)`
     - `amount_articles (INTEGER NOT NULL)`
     - `complete (TEXT CHECK(complete IN ("True","False")))`
   - **Reasoning**: Tracks the volume of research articles published per country and field, by year. This metric is a proxy for research output and academic interest in AI.

### Relationships

All fact tables (patents, investments, publications) share a consistent referencing of `countries.id` and `fields.id`.

Below is a conceptual diagram (referenced by the template):

![Country AI Activity per Research Field](diagram.png)

---

## Optimizations

To enhance performance, especially when filtering by year, indexes on the `year` columns in each fact table were created:

- `publications_per_year` on `publications_yearly_articles(year)`
- `disclosed_funding_per_year` on `companies_yearly_disclosed(year)`
- `estimated_funding_per_year` on `companies_yearly_estimated(year)`
- `applied_patents_per_year` on `patents_yearly_applications(year)`
- `granted_patents_per_year` on `patents_yearly_granted(year)`

These indexes significantly reduce query time for year-based filters, which are common when analyzing trends over time. Furthermore, implemented a **view** named `v_publications` was created to make it easier for users to select all publication records alongside descriptive country and field names, rather than performing manual joins each time.

---

## Limitations

While this schema provides a robust foundation for tracking macro-level AI activity, there are notable limitations:

1. **Lack of Granular Company-Level Detail**

2. **Simplified Patent and Publication Data**: Actual patent documents or research articles are not housed here. Consequently, deeper textual or citation analyses are not possible in this design.

---

## Creation / Data Source

### Source / Citation

The data originates from a set of `.csv` files published by the “Emerging Technology Observatory” at Georgetown University. Specifically, it’s derived from the “Emerging Technology Observatory Country Activity Tracker: Artificial Intelligence,” accessible at [https://cat.eto.tech/]. These files include annual, country-level metrics for patent filings, publication output, and investment flows in AI, thereby forming the core content of our database.

### Data Processing / Importing

To populate the database, each `.csv` is processed in a straightforward manner; the queries are saved in "data_importing.sql".
1. **Country and Field Reference Tables**: A cleaning script deduplicates and inserts each unique country or field into the respective tables.
2. **Fact Tables**: Rows from the `.csv` files are inserted into the relevant fact tables (e.g., `patents_yearly_applications`, `patents_yearly_granted`) with references to the `id` of the corresponding country and field.
3. **Normalization Decision**: Decision to normalize the data by separating countries and fields to reduce redundancy was taken. This design means that queries typically involve joins, but it also ensures that changes or corrections to country or field names are globally consistent.

Certain summary tables and publication citations were dropped from this initial design to keep the database focused on high-level AI metrics.

---

