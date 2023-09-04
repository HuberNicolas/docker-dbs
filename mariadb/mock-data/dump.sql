-- Dump of table todos

-- Switch to the new database
USE task_db;

-- Data for table todos
INSERT INTO todos (task_name, description, completed, priority, due_date) VALUES
    ('Task 1', 'Description of Task 1', FALSE, 2, '2023-07-29'),
    ('Task 2', 'Description of Task 2', TRUE, 1, '2023-07-30'),
    ('Task 3', 'Description of Task 3', FALSE, 3, '2023-07-31');
