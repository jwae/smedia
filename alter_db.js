import { query } from "./backend/db.js";

async function alterTable() {
  try {
    await query(`ALTER TABLE schueler ADD COLUMN S_ID INT NULL AFTER id`);
    console.log("Column S_ID added successfully.");
  } catch (err) {
    if (err.code === 'ER_DUP_FIELDNAME') {
      console.log("Column S_ID already exists.");
    } else {
      console.error("Error altering table:", err);
    }
  }
  process.exit();
}

alterTable();
