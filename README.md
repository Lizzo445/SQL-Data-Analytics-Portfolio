README.md
# SQL Data Analytics Portfolio

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue)
![SQL](https://img.shields.io/badge/SQL-Advanced-success)
![Data Analytics](https://img.shields.io/badge/Data-Analytics-orange)

### Data Analyst Job Market Analysis Using PostgreSQL

> An end-to-end SQL analytics project exploring salary trends, in-demand skills, and hiring patterns within the global data analyst job market.

The complete SQL queries used throughout this project are included in this repository and can be found alongside the accompanying visualizations and documentation.

---

## Project Summary

This project analyzes a large-scale dataset of data analyst job postings using SQL and PostgreSQL. The objective is to identify which skills employers value most, how those skills influence compensation, and which technologies provide the strongest return on investment for aspiring data analysts.

---

## Project Overview

| Category | Details |
|-----------|---------|
| **Project Type** | SQL Data Analytics |
| **Database** | PostgreSQL |
| **Language** | SQL |
| **IDE** | Visual Studio Code |
| **Dataset** | Luke Barousse SQL Course Dataset |
| **Analysis** | Salary Analysis, Skill Demand, Market Trends |
| **Visualizations** | SQL + Excel |
| **Version Control** | Git & GitHub |

---

## Repository Structure

```text
SQL-Data-Analytics-Portfolio
│
├── README.md
├── Assets/
│   ├── 2_top_paying_jobs_skills.png
│   ├── 3_top_demanded_skills.png
│   ├── 4_top_paying_skills.png
│   ├── 5_optimal_skills.png
│   └── 6_optimal_skills_demand_vs_salary.png
│
├── 1_top_paying_jobs.sql
├── 2_top_paying_jobs_skills.sql
├── 3_top_demanded_skills.sql
├── 4_top_paying_skills.sql
└── 5_optimal_skills.sql
```
---

## Business Objective

The motivation behind this project was to better understand the data analyst job market through data-driven analysis.

Using SQL, I investigated salary trends, employer demand, and skill requirements to answer one central question:

> **Which technical skills maximize career opportunities and earning potential for data analysts?**

The dataset originates from Luke Barousse's SQL Course and contains job postings including salaries, locations, job titles, and required technical skills.

---

## Business Questions

This project answers five practical questions:

1. Which Data Analyst positions pay the highest salaries?
2. Which technical skills are required for those positions?
3. Which skills are most in demand?
4. Which skills command the highest salaries?
5. Which skills offer the best combination of salary and demand?

---

# Technology Stack
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

---

# Analysis & Findings
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

---

### 1. Top Paying Data Analyst Jobs

### Objective
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

### SQL Query

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```

### Business Insights

- One $650K position represents an extreme outlier rather than the market average.
- Senior Data Analyst compensation typically clusters between $180K–260K.
- Compensation depends more on business impact than job title.

---

### 2. Skills for Top Paying Jobs

### Objective
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

### SQL Query

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    s.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim as sj ON top_paying_jobs.job_id = sj.job_id
INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
ORDER BY 
    salary_year_avg DESC
```

![Top paying skills](Assets/2_top_paying_jobs_skills.png)

### Business Insights

- SQL and Python dominate premium analytics positions.
- Tableau and Azure frequently complement core analytical skills.
- Specialized cloud platforms provide additional differentiation.

---

### 3. In-Demand Skills for Data Analysts

### Objective
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

### SQL Query

```sql
SELECT
    skills,
    COUNT(sj.job_id) aS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim as sj ON job_postings_fact.job_id = sj.job_id
INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

![Most demanded skills](Assets/3_top_demanded_skills.png)

### Business Insights

- SQL remains the industry's most requested technical skill.
- Excel and Python continue to be essential hiring requirements.
- Visualization tools have become standard business skills.

---

### 4. Skills Based on Salary

### Objective
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

### SQL Query

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim as sj ON job_postings_fact.job_id = sj.job_id
INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
   avg_salary DESC
LIMIT 25
```

![Optimal Skills](Assets/5_optimal_skills.png)

### Business Insights

- Rare technical skills command substantial salary premiums.
- Market scarcity drives compensation more than popularity.
- Specialized tools provide higher upside but fewer opportunities.

---

### 5. Most Optimal Skills to Learn

### Objective
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

### SQL Query

```sql
WITH skills_demand AS (
    SELECT
        s.skill_id,
        s.skills,
        COUNT(sj.job_id) aS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim as sj ON job_postings_fact.job_id = sj.job_id
    INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        s.skill_id
), average_salary AS (
    SELECT
        s.skill_id,
        s.skills,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim as sj ON job_postings_fact.job_id = sj.job_id
    INNER JOIN skills_dim as s ON sj.skill_id = s.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        s.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25
```

![Optimal Skills + Top Paying](Assets/6_optimal_skills_demand_vs_salary.png)

### Business Insights

- Python, SQL, Tableau, and R provide the strongest combination of salary and demand.
- Excel remains highly demanded but offers lower salary premiums.
- Building strong fundamentals produces greater long-term career value than focusing exclusively on niche technologies.

---

# Skills Demonstrated

- SQL Query Design
- PostgreSQL
- Data Cleaning
- Data Aggregation
- Common Table Expressions (CTEs)
- Complex Joins
- Aggregate Functions
- Business Analysis
- Salary Analytics
- Data Visualization
- Git
- GitHub

---

# What I Learned
Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

---

# Key Takeaways

- Analyzed a large-scale relational database using PostgreSQL.
- Answered five real-world business questions using SQL.
- Identified the highest-paying Data Analyst positions.
- Measured relationships between salary and technical skills.
- Produced business-focused insights supported by data visualization.
- Presented technical findings using professional documentation.

---

# Conclusion

This project demonstrates my ability to transform relational data into actionable business insights using SQL. Beyond writing efficient queries, the analysis emphasizes structured problem-solving, analytical thinking, and communicating findings through clear visualizations and executive-level summaries.

The project reflects the workflow commonly used by data analysts when exploring labor market trends and generating decision-ready insights from structured datasets.