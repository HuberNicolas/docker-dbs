-- Create a new database
CREATE DATABASE IF NOT EXISTS task_db;

-- Switch to the new database
USE task_db;

-- Create a sample table for tasks
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    completed BOOLEAN NOT NULL,
    priority INT NOT NULL,
    due_date DATE
);

INSERT INTO tasks (name, description, completed, priority, due_date) VALUES
    ('Task 1', 'Description of Task 1', FALSE, 2, '2023-07-29'),
    ('Task 2', 'Description of Task 2', TRUE, 1, '2023-07-30'),
    ('Task 3', 'Description of Task 3', FALSE, 3, '2023-07-31');