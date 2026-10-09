// Loads the sample tasks as (:Task) nodes. MERGE makes it safe to run more than once.
CREATE CONSTRAINT task_id IF NOT EXISTS FOR (t:Task) REQUIRE t.id IS UNIQUE;

MERGE (t:Task {id: 1})
SET t.name = 'Task 1', t.description = 'Description of Task 1', t.completed = false, t.priority = 2,
    t.due_date = date('2023-07-29');
MERGE (t:Task {id: 2})
SET t.name = 'Task 2', t.description = 'Description of Task 2', t.completed = true, t.priority = 1,
    t.due_date = date('2023-07-30');
MERGE (t:Task {id: 3})
SET t.name = 'Task 3', t.description = 'Description of Task 3', t.completed = false, t.priority = 3,
    t.due_date = date('2023-07-31');

// Task 1 has to be done before Task 3.
MATCH (a:Task {id: 1}), (b:Task {id: 3})
MERGE (a)-[:BLOCKS]->(b);
