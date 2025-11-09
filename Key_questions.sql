---- Key questions -----------
-- 1. What is the gender distribution of company´s employees?
SELECT gender, count(*) AS count FROM human_resources 
WHERE  age >= 18 AND term_date = "0000-00-00"
GROUP BY gender; 

-- 2. What is the racial /ethnic breakdown  of the company´s employees?
SELECT race, count(*) AS count FROM human_resources
WHERE age >= 18 AND term_date = "0000-00-00"
GROUP BY race
ORDER BY count DESC; 

-- 3. What is the age distribution of the company´s employees?
SELECT MAX(age) FROM human_resources;

SELECT 
	CASE 
        WHEN age BETWEEN 18 AND 24 THEN "18-24"
        WHEN age BETWEEN 25 AND 34 THEN "25-34"
        WHEN age BETWEEN 35 AND 44 THEN "34-44"
        WHEN age BETWEEN 45 AND 54 THEN "45-54"
        WHEN age BETWEEN 55 AND 64 THEN "55-64"
	ELSE "65+"
END AS category, count(*) AS count
FROM human_resources
WHERE age >= 18 AND term_date = "0000-00-00"
GROUP BY category
ORDER BY category;

-- 4. How many employees work at heeadquarters compared to remote locations?
SELECT location, count(*) AS count  FROM human_resources
WHERE age >= 18 AND term_date = "0000-00-00"
GROUP BY location 
ORDER BY count DESC;

-- 5. What is the average lenght of employment for employees who have been terminated?
SELECT ROUND (AVG(timestampdiff(year, hire_date, term_date)),2) AS avg_age FROM human_resources
WHERE age >= 18 AND term_date != "0000-00-00" AND term_date <= CURDATE();

-- 6. How does the gender distribution vary across departments?
SELECT department, gender, count(*) AS count FROM human_resources
WHERE age >= 18 AND term_date ="0000-00-00"
GROUP BY gender, department
ORDER BY department; 

-- 7. What is the distribution of job titles across the company?
SELECT job_title, count(*) AS count FROM human_resources
WHERE age >= 18 AND term_date = "0000-00-00" 
GROUP BY job_title
ORDER BY count DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM (
    SELECT department, count(*) AS total_count,
    SUM(CASE WHEN term_date != "0000-00-00" AND term_date <= curdate() THEN 1 ELSE 0 END)
    AS terminated_count
    FROM human_resources
    WHERE age >= 18
    GROUP BY department
    ) AS Subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution  of employees across locations by city  and state?
SELECT location_state, count(*) AS distribution FROM human_resources
WHERE term_date = "0000-00-00" AND age >= 18
GROUP BY location_state
ORDER BY distribution DESC;

-- 10.How has the company´s employee count changed over time based on hire and term dates?

SELECT 
    year,
    hires,
    terminations, 
    hires - terminations AS net_change,
    ROUND((hires - terminations)/hires * 100, 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN term_date != '0000-00-00' AND term_date <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM human_resources
    WHERE age >= 18 
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each  deparment?
SELECT department, ROUND(AVG(timestampdiff(year,hire_date, term_date)),0) AS avg_tenure
FROM human_resources
WHERE term_date <= curdate() AND term_date != "0000-00-00" AND age >= 18
GROUP BY department 
ORDER BY avg_tenure DESC;

      

        