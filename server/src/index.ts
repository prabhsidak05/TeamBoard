import authRouter from "./modules/auth/auth.routes";
import "dotenv/config";
import express from "express";
import cors from "cors";
import helmet from "helmet";
import { pool } from "./db/pool";
console.log("DATABASE_URL:", process.env.DATABASE_URL);
console.log("CWD:", process.cwd());

const app = express();
app.use(helmet());
app.use(cors({ origin: "http://localhost:3000" }));
app.use(express.json());
app.use("/auth", authRouter);
app.get("/health", async (_req, res) => {
  const result = await pool.query("SELECT NOW()");
  res.json({ status: "ok", dbTime: result.rows[0].now });
});

const port = process.env.PORT || 4000;
app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(err);
  res.status(500).json({ error: "Something went wrong" });
});
app.listen(port, () => console.log(`Server running on port ${port}`));