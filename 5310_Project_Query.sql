-- Questions --
--1. Calculate the number of employees in each position and their average salary and bonus.
SELECT 
    e.position, 
    COUNT(e.employee_id) AS num_employees,
    AVG(s.annual_salary) AS avg_salary,
    AVG(s.annual_bonus) AS avg_bonus
FROM 
    employees e
JOIN 
    salaries s ON e.employee_id = s.employee_id
GROUP BY 
    e.position;

--2. Calculate the total sales and profit within a specific date range（Jan 2023 to Jan 2024 and Time interval every 1 month).
SELECT 
    DATE_TRUNC('month', s.sale_date) AS month,
    SUM(s.sale_price) AS total_sales,
    SUM(p.net_profit) AS total_profit
FROM 
    sales s
JOIN 
    transactions t ON s.transaction_id = t.transaction_id
JOIN 
    profits p ON t.transaction_id = p.transaction_id
WHERE 
    s.sale_date BETWEEN '2023-01-01' AND '2024-01-31'
GROUP BY 
    DATE_TRUNC('month', s.sale_date)

--3. Calculate the total sales of each office (Time interval every 1 month).
SELECT 
    o.office_id,
    o.address,
    DATE_TRUNC('month', s.sale_date) AS month,
    SUM(s.sale_price) AS total_sales
FROM 
    offices o
JOIN 
    employees e ON o.office_id = e.office_id
JOIN 
    transactions t ON e.employee_id = t.employee_id
JOIN 
    sales s ON t.transaction_id = s.transaction_id
GROUP BY 
    o.office_id, o.address, DATE_TRUNC('month', s.sale_date)
ORDER BY 
    o.office_id, month;

--4. Calculate and rank the monthly sales of full-time, part-time, contract agents.
SELECT 
    e.employment_type,
    DATE_TRUNC('month', t.transaction_date) AS month,
    COUNT(t.transaction_id) AS total_sales_orders
FROM 
    employees e
JOIN 
    transactions t ON e.employee_id = t.employee_id
JOIN 
    sales s ON t.transaction_id = s.transaction_id
GROUP BY 
    e.employment_type, DATE_TRUNC('month', t.transaction_date)
ORDER BY 
    month, total_sales_orders DESC;

--5. Identify the cyclical demand of sale, lease.
SELECT 
    DATE_TRUNC('month', t.transaction_date) AS month,
    t.transaction_type,
    COUNT(t.transaction_id) AS num_transactions
FROM 
    transactions t
GROUP BY 
    DATE_TRUNC('month', t.transaction_date), t.transaction_type
ORDER BY 
    month;

--6. Identify the most common transaction types of each home in the tri-state area.
SELECT 
    h.state,
    t.transaction_type,
    COUNT(t.transaction_id) AS num_transactions
FROM 
    houses h
JOIN 
    transactions t ON h.house_id = t.house_id
WHERE 
    h.state IN ('NY', 'NJ', 'CT')
GROUP BY 
    h.state, t.transaction_type
ORDER BY 
    num_transactions DESC;

--7. Calculate the total annual expenses of 3 offices.
SELECT 
    o.region AS state,
    SUM(e.amount) AS total_expenses
FROM 
    offices o
JOIN 
    expenses e ON o.office_id = e.office_id
WHERE 
    o.region IN ('NY', 'NJ', 'CT')
GROUP BY 
    o.region
ORDER BY 
    total_expenses DESC
LIMIT 3;

--8. Calculate the average rating of each house based on past rental and purchase experiences.
SELECT 
    h.house_id,
    h.address,
    AVG(f.rating) AS avg_rating
FROM 
    houses h
JOIN 
    client_feedbacks f ON h.house_id = f.house_id
GROUP BY 
    h.house_id, h.address;

--9. Calculate the total appointments, cancelled appointments, and cancellation rate for each state.
SELECT 
    o.region AS state,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(a.appointment_id) FILTER (WHERE a.status = 'cancelled') AS cancelled_appointments,
    COUNT(a.appointment_id) FILTER (WHERE a.status = 'cancelled')::DECIMAL / COUNT(a.appointment_id) AS cancellation_rate
FROM 
    offices o
JOIN 
    employees e ON o.office_id = e.office_id
JOIN 
    appointments a ON e.employee_id = a.agent_id
GROUP BY 
    o.region
ORDER BY 
    o.region;

--10.Determine the impact of different marketing activities on average ROI and average of cost.
SELECT 
    m.activity_name,
    AVG(m.ROI) AS avg_ROI,
    AVG(m.cost) AS avg_cost
FROM 
    marketing_activities m
GROUP BY 
    m.activity_name
ORDER BY
	AVG(m.ROI) desc;

