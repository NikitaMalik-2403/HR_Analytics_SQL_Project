-- List all employees with their department names and job roles.

SELECT e.name, d.department_name, j.job_role
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id;

-- Find employees who joined in the last 6 months.
SELECT name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- Find total employees in each department
SELECT d.department_name , COUNT(e.employee_id) AS total_employes
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY total_employes DESC;

-- Average salary by job role
SELECT j.job_role, ROUND(AVG(e.salary) , 2)AS avg_salary
FROM jobs j
JOIN employees e ON j.job_id = e.job_id
GROUP BY job_role
ORDER BY avg_salary DESC;

-- Find employees earning above their job's max salary
SELECT e.employee_id, e.name , e.salary,  j.max_salary
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
WHERE e.salary > j.max_salary;

-- Top 10 highest paid employees
SELECT employee_id, name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

-- Attrition rate by department
SELECT d.department_name,
SUM(CASE WHEN a.attrition = 'YES' THEN 1 ELSE 0 END) *100.0 /
COUNT(e.employee_id) AS attrition_percentage
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN attrition a ON e.employee_id = a.employee_id
GROUP BY d.department_name
ORDER BY attrition_percentage DESC;

-- List all employees who left the company
SELECT e.employee_id , e.name, a.reason
FROM employees e
JOIN attrition a ON e.employee_id = a.employee_id
WHERE attrition = 'YES';

-- Salary distribution (min, max, avg) per department
SELECT d.department_name,
MIN(e.salary) AS min_salary,
MAX(e.salary) AS max_salary,
AVG(e.salary) AS avg_Salary
FROM departments d 
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Employee attendance summary
SELECT employee_id,
SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) AS days_present,
SUM(CASE WHEN status = 'Absent' THEN 1 ELSE 0 END) AS days_absent
FROM attendance
GROUP BY employee_id;

-- Employees with lowest attendance
SELECT employee_id,
      SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) AS present_days
FROM attendance
GROUP BY employee_id
ORDER BY present_days;

-- Employees having salary above their department average
SELECT e.employee_id , e.name, d.department_name, e.salary
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE e.salary > 
(SELECT Avg(salary)
                FROM employees
				WHERE department_id = e.department_id);
	
-- Rank employees within each department
SELECT e.employee_id, e.name, e.salary, d.department_name,
       RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) AS dept_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
       
-- Departments with highest absenteeism
SELECT d.department_name,
COUNT(*) AS total_absents
FROM departments d
JOIN employees e ON e.department_id = d.department_id
JOIN attendance a ON e.employee_id = a.employee_id
WHERE a.status = 'Absent'
GROUP BY d.department_name
ORDER BY total_absents DESC;

-- Full employee analytic profile
SELECT e.employee_id, e.name, d.department_name, j.job_role,
    e.salary, a.attrition, a.reason
    FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id
    JOIN attrition a ON e.employee_id = a.employee_id;
    
    -- Find the number of employees who left each month.
    SELECT DATE_FORMAT(e.hire_date, '%Y-%m') AS month, COUNT(*) AS attrition_count
FROM attrition a
JOIN employees e ON a.employee_id = e.employee_id
WHERE a.attrition = 'Yes'
GROUP BY month
ORDER BY month;
    

    



