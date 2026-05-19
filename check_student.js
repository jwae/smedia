import { query } from "./backend/db.js";

async function checkStudent() {
  try {
    const sId = "123456";
    const students = await query(`SELECT * FROM schueler WHERE id = ? OR S_ID = ?`, [sId, sId]);
    console.log("Students found:", students.length);
    for (const student of students) {
      console.log(`\nStudent DB-ID: ${student.id}, S-ID: ${student.S_ID}, Name: ${student.vorname} ${student.nachname}`);
      
      const ausleiher = await query(`SELECT * FROM ausleiher WHERE quelle_typ = 'schueler' AND quelle_id = ?`, [student.id]);
      if (ausleiher.length > 0) {
        const ausleiherId = ausleiher[0].id;
        console.log(`Ausleiher-ID: ${ausleiherId}`);
        
        const activeLoans = await query(`SELECT id, status FROM ausleihen WHERE ausleiher_id = ? AND status != 'zurueckgegeben'`, [ausleiherId]);
        console.log(`Active loans: ${activeLoans.length}`);
        
        const history = await query(`
            SELECT h.id FROM historie_eintraege h
            JOIN ausleihen a ON h.ausleihe_id = a.id
            WHERE a.ausleiher_id = ?
        `, [ausleiherId]);
        console.log(`History entries via loans: ${history.length}`);
        
        const damage = await query(`SELECT id FROM schadensmeldungen WHERE gemeldet_von_ausleiher_id = ?`, [ausleiherId]);
        console.log(`Damage reports: ${damage.length}`);
      } else {
        console.log("No ausleiher record found for this student.");
      }
    }
  } catch (err) {
    console.error(err);
  }
  process.exit();
}

checkStudent();
