require("dotenv").config();

const express = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = Number(process.env.PORT) || 3000;
const uploadDir = path.join(__dirname, "uploads");

fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) => {
    const safeName = path.basename(file.originalname)
      .replace(/[^a-zA-Z0-9._-]/g, "_");
    cb(null, `${Date.now()}-${safeName}`);
  }
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024, files: 10 },
  fileFilter: (_req, file, cb) => {
    if (file.mimetype && file.mimetype.startsWith("image/")) {
      cb(null, true);
    } else {
      cb(new Error("Only image files are accepted."));
    }
  }
});

app.get("/", (_req, res) => {
  res.sendFile(path.join(__dirname, "Gallery-sry.html"));
});

app.post("/upload", upload.array("photos", 10), async (req, res) => {
  if (!req.files || req.files.length === 0) {
    return res.status(400).json({ message: "Please select images first." });
  }

  const count = req.files.length;

  // Send a text notification only; uploaded images remain on this server.
  if (process.env.BOT_TOKEN && process.env.CHAT_ID) {
    try {
      const message = `GALLERY-SRY: ${count} image(s) were uploaded with the user's confirmation.`;
      const response = await fetch(
        `https://api.telegram.org/bot${process.env.BOT_TOKEN}/sendMessage`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            chat_id: process.env.CHAT_ID,
            text: message
          })
        }
      );

      if (!response.ok) {
        console.error("Telegram notification failed:", await response.text());
      }
    } catch (error) {
      console.error("Telegram notification error:", error.message);
    }
  }

  res.json({
    message: `${count} image(s) uploaded successfully.`,
    count
  });
});

app.use((err, _req, res, _next) => {
  res.status(400).json({ message: err.message || "Upload failed." });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`GALLERY-SRY running at http://127.0.0.1:${PORT}`);
});
