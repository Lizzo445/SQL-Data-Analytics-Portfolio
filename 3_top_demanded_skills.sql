/*
**Question: What are the most in-demand skills for data analyst?**
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand 
    in the job market, providing insights into the most valuable skills for job seekers.
*/
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
