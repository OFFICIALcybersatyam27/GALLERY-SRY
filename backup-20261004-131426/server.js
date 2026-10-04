
const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const PORT = 3000;
const uploadDir = path.join(__dirname, "uploads");

fs.mkdirSync(uploadDir, { recursive: true });

app.use(express.static(__dirname));

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "Gallery-sry.html"));
});

// Store uploads temporarily; accept only image files.
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) => {
    const safeName = `${Date.now()}-${Math.random()
      .toString(36)
      .slice(2)}${path.extname(file.originalname)}`;
    cb(null, safeName);
  }
});

const upload = multer({
  storage,
  limits: { files: 10, fileSize: 10 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (file.mimetype.startsWith("image/")) return cb(null, true);
    cb(new Error("Only image files are allowed."));
  }
});

app.post("/upload", upload.array("photos", 10), (req, res) => {
  const files = req.files || [];

  if (!files.length) {
    return res.status(400).json({ error: "Choose at least one image." });
  }

  // This demo stores the selected files in ./uploads.
  // It does not forward them to a bot or another service.
  res.json({
    success: true,
    message: `${files.length} image(s) uploaded successfully.`,
    files: files.map(file => file.originalname)
  });
});

app.use((err, _req, res, _next) => {
  res.status(400).json({ error: err.message || "Upload failed." });
});

// Optional live panel connection: reports only clients that explicitly connect.
const connectedClients = new Map();

io.on("connection", socket => {
  socket.on("device_connect", data => {
    const name = String(data?.deviceName || "My device").slice(0, 60);
    connectedClients.set(socket.id, {
      id: socket.id,
      name,
      connectedAt: new Date().toISOString()
    });

    io.emit("devices_list", [...connectedClients.values()]);
  });

  socket.on("disconnect", () => {
    connectedClients.delete(socket.id);
    io.emit("devices_list", [...connectedClients.values()]);
  });
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`GALLERY-SRY running at http://127.0.0.1:${PORT}`);
});
      
