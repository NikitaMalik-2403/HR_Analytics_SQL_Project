# HR_Analytics_SQL_Project
HR Analytics SQL Project with datasets, queries, and insights
## Project Overview

This repository contains a synthetic but realistic HR analytics dataset designed for SQL practice. It demonstrates common HR analytics tasks including joins, aggregations, window functions, subqueries, and advanced analytics. Use the provided SQL queries to reproduce insights and include them in your portfolio.

---

## Files / Datasets

This project includes the following CSV files:

### **1. employees.csv**

Contains employee-level data.

* `employee_id`
* `name`
* `age`
* `department_id`
* `job_id`
* `salary`
* `hire_date`

### **2. departments.csv**

Lookup table for departments.

* `department_id`
* `department_name`

### **3. jobs.csv**

Lookup table for job roles and salary ranges.

* `job_id`
* `job_role`
* `min_salary`
* `max_salary`

### **4. attendance.csv**

Daily attendance records.

* `employee_id`
* `date`
* `status` (Present / Absent / Work From Home)

### **5. attrition.csv**

Tracks employee attrition and reason.

* `employee_id`
* `attrition`
* `reason`

---

## ER Diagram (text)

```
+-----------+     +-------------+     +--------+
| employees |-----| departments |     |  jobs  |
| (employee_id)   |(department_id)    |(job_id)|
| department_id |                      |       |
| job_id        |                      |       |
+-----------+     +-------------+     +--------+
       |                 
       |                
       |                
       |                
    +-------+   +-----------+
    |attrition| | attendance|
    |(employee_id) (employee_id)
    +-------+   +-----------+
```

---

## Queries Included

A separate file in this repository contains all SQL queries used in the project, along with outputs.

### The queries cover:

* Basic joins (employees ↔ departments ↔ jobs)
* Aggregations (salary summaries, headcount)
* Conditional logic & case statements
* Attendance analytics
* Attrition analysis
* Window functions (rankings, dense rank)
* Subqueries (correlated + non‑correlated)
* Department-level performance and trends

---

## Advanced queries highlights

Examples include:

* Top 3 highest paid employees per department (window function)
* Year-over-year hiring growth using CTEs
* Employees who earn above both department and job averages (subqueries)
* Departments ranked by absenteeism and salary expenditure
* Multi-level profile join combining employees, jobs, departments, attendance, attrition

Example (Top 3 per dept):

```sql
SELECT *
FROM (
    SELECT e.employee_id, e.name, d.department_name, e.salary,
           DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank
    FROM employees e
    JOIN departments d ON d.department_id = e.department_id
) ranked
WHERE salary_rank <= 3;
```

---

## Insights & Analysis Summary

Your analysis demonstrated the following:

### ⭐ **1. Attrition Trends**

* Identified departments with the highest attrition percentage.
* Most common attrition reasons were highlighted.
* Salary & attendance patterns correlated with attrition.

### ⭐ **2. Salary Insights**

* Detected salary gaps across departments and job roles.
* Identified employees earning above or below department/job averages.
* Ranked employees and departments by total salary expenditure.

### ⭐ **3. Attendance Insights**

* Found days with maximum and minimum presence.
* Identified employees with perfect attendance.
* Highlighted departments with highest absenteeism.

### ⭐ **4. Workforce Trends**

* Employee distribution by job role and department.
* Top 3 earners by department using window functions.

---

## License

Feel free to reuse this dataset and queries for learning and portfolio purposes. If you publish results, please credit the author: Nikita Malik.

---

## Contact

* Email: [nikitamalik666625@gmail.com](mailto:nikitamalik666625@gmail.com)
* GitHub: (https://github.com/NikitaMalik-2403)
* LinkedIn: www.linkedin.com/in/nikita-malik-3835a9158
