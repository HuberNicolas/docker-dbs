-- Connect to the 'task_db' database
\c task_db;

-- Create the 'tasks' table if it doesn't exist
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    priority INTEGER,
    due_date DATE
);

INSERT INTO tasks (name, description, completed, priority, due_date)
VALUES
    ('Task 1', 'Description of Task 1', FALSE, 2, '2023-07-29'),
    ('Task 2', 'Description of Task 2', TRUE, 1, '2023-07-30'),
    ('Task 3', 'Description of Task 3', FALSE, 3, '2023-07-31');