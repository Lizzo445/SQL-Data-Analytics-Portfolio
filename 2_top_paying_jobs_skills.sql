/*
**Question: What are the top-paying data analyst jobs, and what skills are required?** 
- Identify the top 10 highest-paying Data Analyst jobs and 
    the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying 
    jobs demand certain skills, helping job seekers understand which 
    skills to develop that align with top salaries
*/

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