// Connect to the MongoDB server
conn = new Mongo();

// Specify the database to use (e.g., "task_db")
db = conn.getDB("task_db");

// Create a "tasks" collection
db.createCollection("tasks");

// Insert sample data into the "tasks" collection
db.tasks.insert([
  {
    name: "Task 1",
    description: "Description of Task 1",
    completed: false,
    priority: 2,
    due_date: new Date("2023-07-29T00:00:00Z"),
  },
  {
    name: "Task 2",
    description: "Description of Task 2",
    completed: true,
    priority: 1,
    due_date: new Date("2023-07-30T00:00:00Z"),
  },
  {
    name: "Task 3",
    description: "Description of Task 3",
    completed: false,
    priority: 3,
    due_date: new Date("2023-07-31T00:00:00Z"),
  },
]);

print("Sample data inserted successfully.");
