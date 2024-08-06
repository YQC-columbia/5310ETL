-- Create Tables --

CREATE TABLE offices (
    office_id SERIAL PRIMARY KEY,
    address VARCHAR(80) NOT NULL,
    contact_info VARCHAR(80),
    region VARCHAR(40)
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(40) NOT NULL,
    location VARCHAR(80) NOT NULL,
    manager_id INT
);

CREATE TABLE houses (
    house_id SERIAL PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    type VARCHAR(50) NOT NULL,
    bedrooms INT NOT NULL,
    bathrooms INT NOT NULL,
    sqft INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    gender VARCHAR(40),
    date_of_birth DATE,
    phone_number VARCHAR(20),
    email VARCHAR(80),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    date_of_registration date NOT NULL,
    client_type VARCHAR(40)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    gender VARCHAR(40),
    date_of_birth DATE NOT NULL,
    email VARCHAR(80),
    date_of_employment DATE NOT NULL,
    position VARCHAR(80),
    department_id INT,
    employment_status VARCHAR(40),
    office_id INT,
    employment_type VARCHAR(40),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (office_id) REFERENCES offices(office_id)
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    transaction_type VARCHAR(40) NOT NULL,
    transaction_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    house_id INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (house_id) REFERENCES houses(house_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE client_feedbacks (
    feedback_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    house_id INT NOT NULL,
    transaction_id INT NOT NULL,
    feedback_date DATE NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (house_id) REFERENCES houses(house_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    annual_salary NUMERIC(10, 2) NOT NULL,
    annual_bonus NUMERIC(10, 2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    description VARCHAR(255),
    amount DECIMAL(10, 2) NOT NULL,
    expense_date DATE NOT NULL,
    office_id INT,
    FOREIGN KEY (office_id) REFERENCES offices(office_id)
);

CREATE TABLE profits (
    profit_id SERIAL PRIMARY KEY,
    transaction_id INT,
    net_profit DECIMAL(10, 2) NOT NULL, 
    profit_date DATE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    transaction_id INT,
    listing_price DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

CREATE TABLE house_amenities (
    house_id INT,
    amenity_id INT,
    amenity_name VARCHAR(255),
    description TEXT,
    FOREIGN KEY (house_id) REFERENCES houses(house_id)
);

CREATE TABLE house_records (
    house_id INT,
    usage_type VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (house_id, start_date),
    FOREIGN KEY (house_id) REFERENCES houses(house_id)
);

CREATE TABLE market_trends (
    trend_id SERIAL PRIMARY KEY,
    house_id INT NOT NULL,
    date_recorded DATE NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    trend_description TEXT,
    FOREIGN KEY (house_id) REFERENCES houses(house_id)
);

CREATE TABLE marketing_activities (
    activity_id SERIAL PRIMARY KEY,
    activity_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    cost DECIMAL(15, 2) NOT NULL,
    ROI DECIMAL(5, 2),
    description TEXT
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    agent_id INT NOT NULL,
    house_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    comments TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (agent_id) REFERENCES employees(employee_id),
    FOREIGN KEY (house_id) REFERENCES houses(house_id)
);