#!/data/data/com.termux/files/usr/bin/bash

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${GREEN}"
echo "  ███████╗██████╗ ██╗   ██╗"
echo "  ██╔════╝██╔══██╗╚██╗ ██╔╝"
echo "  ███████╗██████╔╝ ╚████╔╝ "
echo "  ╚════██║██╔══██╗  ╚██╔╝  "
echo "  ███████║██║  ██║   ██║   "
echo "  ╚══════╝╚═╝  ╚═╝   ╚═╝   "
echo -e "${CYAN} MADED ,, CODED BY OFFICIAL_cyber_satyam27${RESET}"
echo

cd "$(dirname "$0")"

# Back up existing files before replacing them
BACKUP="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

for file in server.js Gallery-sry.html package.json .env .gitignore; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP/$file"
    fi
done

echo -e "${CYAN}Enter your Telegram bot token (input hidden):${RESET}"
read -r -s BOT_TOKEN
echo

echo -e "${CYAN}Enter your Telegram chat ID:${RESET}"
read -r CHAT_ID

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo -e "${RED}Token and chat ID are required. No files were configured.${RESET}"
    exit 1
fi

# Keep Telegram credentials on the server, never in the webpage
umask 077
cat > .env <<EOF
BOT_TOKEN=$BOT_TOKEN
CHAT_ID=$CHAT_ID
PORT=3000
EOF
chmod 600 .env

cat > package.json <<'EOF'
{
  "name": "gallery-sry",
  "version": "1.0.0",
  "description": "GALLERY-SRY consent-based image uploader",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "dotenv": "^16.4.7",
    "express": "^4.21.2",
    "multer": "^2.0.0"
  }
}
EOF

cat > .gitignore <<'EOF'
node_modules/
.env
uploads/
backup-*/
EOF

cat > server.js <<'EOF'
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
EOF

cat > Gallery-sry.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>GALLERY-SRY</title>
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0; padding: 24px; min-height: 100vh;
      background: #050b09; color: #eafff4;
      font-family: Arial, sans-serif;
    }
    main {
      max-width: 650px; margin: 35px auto; padding: 24px;
      border: 1px solid #00ff9955; border-radius: 18px;
      background: #0b1511; box-shadow: 0 0 30px #00ff9918;
    }
    h1 { color: #00ff99; letter-spacing: 2px; }
    p { color: #b7c9bf; line-height: 1.6; }
    input, button {
      width: 100%; margin-top: 15px; padding: 13px;
      border-radius: 9px; font-size: 16px;
    }
    input { background: #101e18; color: white; border: 1px solid #315b45; }
    button {
      border: 0; background: #00ff99; color: #04120b;
      font-weight: bold; cursor: pointer;
    }
    button:disabled { opacity: .5; cursor: not-allowed; }
    label { display: block; margin-top: 16px; color: #d5e9dc; }
    label input { width: auto; }
    #preview { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 16px; }
    #preview img { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; }
    #status { overflow-wrap: anywhere; }
  </style>
</head>
<body>
<main>
  <h1>GALLERY-SRY</h1>
  <p>Select images yourself. Nothing is uploaded until you confirm and press Upload.</p>

  <input id="photos" type="file" accept="image/*" multiple>
  <div id="preview"></div>

  <label>
    <input id="consent" type="checkbox">
    I confirm that I chose these images and want to upload them.
  </label>

  <button id="upload" disabled>Upload selected images</button>
  <p id="status" role="status">Choose images to begin.</p>
</main>

<script>
  const picker = document.getElementById("photos");
  const consent = document.getElementById("consent");
  const button = document.getElementById("upload");
  const status = document.getElementById("status");
  const preview = document.getElementById("preview");

  function updateButton() {
    button.disabled = !(picker.files.length && consent.checked);
  }

  picker.addEventListener("change", () => {
    preview.replaceChildren();
    for (const file of picker.files) {
      if (!file.type.startsWith("image/")) continue;
      const img = document.createElement("img");
      img.src = URL.createObjectURL(file);
      img.alt = "Selected image preview";
      preview.appendChild(img);
    }
    updateButton();
  });

  consent.addEventListener("change", updateButton);

  button.addEventListener("click", async () => {
    const data = new FormData();
    for (const file of picker.files) data.append("photos", file);

    button.disabled = true;
    status.textContent = "Uploading…";

    try {
      const response = await fetch("/upload", { method: "POST", body: data });
      const result = await response.json();
      if (!response.ok) throw new Error(result.message || "Upload failed.");
      status.textContent = result.message;
      picker.value = "";
      consent.checked = false;
      preview.replaceChildren();
    } catch (error) {
      status.textContent = error.message;
    } finally {
      updateButton();
    }
  });
</script>
</body>
</html>
EOF

echo
echo -e "${GREEN}Files created successfully.${RESET}"
echo "Installing dependencies..."
npm install

echo
echo -e "${GREEN}Starting GALLERY-SRY...${RESET}"
echo "Open: http://127.0.0.1:3000"
echo "Press CTRL+C to stop the server."
npm start