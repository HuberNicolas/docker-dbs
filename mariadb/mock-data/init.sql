-- Create a new database
CREATE DATABASE IF NOT EXISTS task_db;

-- Switch to the new database
USE task_db;

-- Create a sample table for tasks
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    completed BOOLEAN NOT NULL,
    priority INT NOT NULL,
    due_date DATE
);
