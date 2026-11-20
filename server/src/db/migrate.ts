import "dotenv/config";
import fs from "fs";
import path from "path";
import { Pool } from "pg";

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function migrate() {
  const sql = fs.readFileSync(path.join(__dirname, "schema.sql"), "utf8");
  await pool.query(sql);
  console.log("Schema created");
  await pool.end();
}

migrate().catch((err) => {
  console.error(err);
  process.exit(1);
});