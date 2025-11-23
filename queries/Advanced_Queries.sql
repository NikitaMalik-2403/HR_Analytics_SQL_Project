-- ADVANCE ANALYTICS

-- Find the department with the highest attrition rate.

SELECT d.department_name,
COUNT(a.employee_id)  * 100 / COUNT(e.employee_id) AS attrition_rate
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN attrition a ON e.employee_id = a.employee_id
GROUP BY d.department_name
ORDER BY attrition_rate DESC
LIMIT 1;

-- Find the top 3 highest paid employees in each department (Window Function)
SELECT *
FROM(
SELECT e.name,  d.department_name, e.salary,
DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
)ranked
WHERE salary_rank <= 3;

-- Calculate year-over-year hiring growth (CTE + date functions)
WITH hires AS (
SELECT EXTRACT(YEAR FROM hire_date) AS year, COUNT(*) AS hires
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
)
SELECT year, hires,
hires - LAG(hires) OVER (ORDER BY year) AS year_growth
FROM hires;

-- Identify employees who earn above both their department AND job average salaries
SELECT e.employee_id, e.name, e.salary, d.department_name, j.job_role
FROM employees e 
JOIN jobs j On e.job_id = j.job_id
JOIN departments d ON d.department_id = e.department_id
WHERE e.salary > (
SELECT AVG(salary) FROM employees WHERE department_id = e.department_id
)
AND e.salary > (
SELECT  AVG(salary) FROM employees WHERE job_id = j.job_id)
;

-- Find departments with the highest absence rate
SELECT  d.department_name, 
(SUM( CASE WHEN status = 'Absent' THEN 1 ELSE 0 END) * 100 )/ COUNT(*)
As absence_rate
FROM departments d 
JOIN employees e ON e.department_id = d.department_id
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY d.department_name
ORDER BY absence_rate DESC;

-- Longest-serving employees (based on hire date)
SELECT employee_id, name, hire_date,
        DATEDIFF(CURRENT_DATE, hire_date) AS days_in_company
FROM employees
ORDER BY hire_date ASC
LIMIT 20;

-- Count employees who have never been absent (anti-join)
SELECT e.employee_id, e.name
FROM employees e
LEFT JOIN attendance a 
ON e.employee_id = a.employee_id
AND a.status = 'Absent'
WHERE a.employee_id IS NULL;

-- Find employees most at-risk for attrition (salary < avg + attendance < avg)

SELECT e.employee_id, e.name, e.salary,
       SUM(CASE WHEN a.status='Absent' THEN 1 ELSE 0 END) AS total_absent
FROM employees e
JOIN attendance a ON a.employee_id = e.employee_id
GROUP BY e.employee_id, e.name, e.salary
HAVING e.salary < (SELECT AVG(salary) FROM employees)
   AND SUM(CASE WHEN a.status='Absent' THEN 1 ELSE 0 END)
       > (SELECT AVG(absent_count)
          FROM (
              SELECT employee_id, 
                     SUM(CASE WHEN status='Absent' THEN 1 END) AS absent_count
              FROM attendance
              GROUP BY employee_id
          ) sub);

-- List departments ranked by total salary expenditure
SELECT d.department_name,
        SUM(e.salary ) AS total_salary,
RANK() OVER (ORDER BY SUM(e.salary) DESC) AS exp_rank
FROM employees e
JOIN departments d On e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_salary;

-- Multi-level join: Full employee analytics profile
SELECT e.employee_id, e.name, d.department_name, j.job_role,
			   e.salary, a.attrition, a.reason
FROM employees e
JOIN departments d On e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
JOIN attrition a ON e.employee_id = a.employee_id
JOIN attendance att ON att.employee_id = e.employee_id
GROUP BY e.employee_id, e.name, d.department_name, j.job_role, 
         e.salary, a.attrition, a.reason;











