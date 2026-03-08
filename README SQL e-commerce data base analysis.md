# SQL e-commerce data base analysis

## :red_circle: Project Overview
The analysis used the e-commerce database of a furniture sales website using ![BigQuery](https://img.shields.io/badge/BigQuery-white?style=flat&logo=googlebigquery). Additionally, an interactive dashboard was created in ![Looker](https://img.shields.io/badge/Looker_Studio-white?style=flat&logo=looker&logoColor=4285F4) to visualize the key findings.

## :red_circle: Goals
It was required to collect data that would help analyze:  
✔ **the dynamics of account creation**.  
✔ **user activity by emails (sending, opening, clicks)**.  
✔ **evaluation of such categories as: sending interval, account verification, and subscription status**.  
✔ **activity comparison between countries, identify key markets, and user segmentation according to various parameters**.  

### Main Metrics
+ **account_cnt** — Number of accounts created.
+ **sent_msg** — Number of messages sent.
+ **open_msg** — Number of messages opened.
+ **visit_msg** — Number of clicks within messages.
### Aggregated & Ranking Metrics:
+ **total_country_account_cnt** — Total number of accounts created per country.
+ **total_country_sent_cnt** — Total number of messages sent per country.
+ **rank_total_country_account_cnt** — Country ranking based on the total number of accounts (descending top 10).
+ **rank_total_country_sent_cnt** — Country ranking based on the total number of sent messages (descending top 10).

## :red_circle: Dataset Overview
In the analyzis were used such tables from dataset:  
- `account` - Table with website subscribers.
- `account_session` - Table with information about the sessions within which the subscription was created.
- `session` - Table with information about user sessions.
- `session_params` - Additional information about sessions, including devices, browser language, user country.  
- `email_sent` - Table with a list of emails that were sent to the user.
- `email_open` - Table with a list of emails that the user has opened.  
- `email_visit` - 	Table with a list of emails that the user clicked on.

## :red_circle: Advanced SQL Techniques Used  
This project incorporates **Advanced SQL Techniques** to improve query performance, simplify analysis, and generate powerful insights:  
### 1. Common Table Expressions (CTE):
   Multiple **WITH** expressions are used for step-by-step data transformation:
   This makes the query:
   - modular.
   - readable.
   - easy to debug.
   - logically divided into stages of data processing.
### 2. Multi-Table Joins (Complex Join Strategy):
  - Connect email events (sent → open → visit).
  - Link accounts to sessions via an intermediate table.
  - Saves email metrics even if there are no opens or visits (LEFT JOIN).
### 3. DISTINCT Aggregations: 
  Used for:
  - counting unique accounts.
  - excluding duplicate messages.
  - correct aggregation with multiple joins.
### 4. UNION ALL for Data Consolidation:
  Used for:
  - combining data on account creation and email metrics.
  - subsequent aggregation into a single layer.
### 5. Multi-Dimensional Aggregation: 
- Provides segmentation capabilitiesю
- Offers flexibility for BI analytics.
- Compares the behavior of different groups.
- Prevents information loss.
### 6. Window Functions:
 - **Partitioned Aggregation** (SUM(...) OVER()) allows to calculate country-level totals and keep row detail.
 - **Ranking Functions** (DENSE_RANK() OVER()) used for building a rating of countries analyzing Top-10 segments.
### 7.Layered Data Modeling Approach: 
- Controls data transformation.
- Predicts metrics.
- Simplifies debugging.
- Easier to scale.

## :red_circle: Business Insights & Findings: 
- The **top three** countries with the highest number of **emails sent** are **the United States, India, and Canada** (ranging from *233,000 to 37,000*).
- **These same countries** are among the **top three** in terms of the number of **accounts created** (ranging from *12,000 to 2,000* accounts).
> [!NOTE]
> A direct correlation has been identified between the number of registrations and user activity. The US, India, and Canada are key markets generating the majority of traffic.
- Between *November 2020 and February 2021*, the peak in messages sent occurred in **mid-December 2020**, before Christmas, and a gradual decline began **after December 24**, 2020 (after the holiday).
> [!NOTE]
> The December peak (mid-month) indicates that the service is highly dependent on pre-holiday activity. The sharp decline after December 24 suggests that the product is used primarily for work or personal greetings, which end with the arrival of Christmas.
- A **sharp decline** in the number of messages sent **began at the end of January 2021** and reached its lowest point at the end of the specified period, at the **end of February 2021**.
> [!NOTE]
> The prolonged decline in activity in January and February, reaching a low point by the end of the period, indicates that users who joined in December did not find a reason to remain in the application at the beginning of the year.

## :red_circle: Business Recommendations: 
:x: Problem: Sharp decline in January-February.  
:white_check_mark: Solution: Develop a marketing campaign to “revive” the customer base in January (e.g., promotions for February 14 or “New Year Resolution” mailings) to smooth out the seasonal slump.

:x: Problem: The main load is on three countries.  
:white_check_mark: Solution: Focus server capacity and budgets on supporting the US, Indian, and Canadian markets, as they show the best conversion from registration to sent message.

:x: Problem: Heavy reliance on the top three countries.  
:white_check_mark: Solution: Analyze the reasons for low activity in other regions. Product localization or adaptation to local holidays may be required to diversify traffic sources.

:x: Problem: Peak in mid-December.  
:white_check_mark: Solution: Start advertising activities in November, as after December 24, investments in attracting customers become ineffective due to a natural decline in interest.

## :red_circle: Project Links:
* **[Interactive Dashboard (Looker Studio)](https://lookerstudio.google.com/s/s9vRRdRYBDE)** — View full visualization and filters.
* **[SQL Queries](https://github.com/punhodik/-SQL-e-commerce-data-base-analysis/blob/main/analysis_queries.sql)** — View the source code used for data transformation.

## :red_circle: Tech Stack & Methodology:
* **Storage:** Google BigQuery (Standard SQL).
* **Visualization:** Looker Studio.
* **Note on Access:** Due to data privacy policies, direct access to the BigQuery dataset is restricted. However, all logic is documented in the SQL files provided in this repository.
