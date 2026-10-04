🟢 GALLERY-SRY

<p align="center">
  <b>OFFICIAL_cyber_satyam27</b><br>
  A transparent, user-controlled image upload server.
</p><p align="center">
  <img src="https://img.shields.io/badge/Project-GALLERY--SRY-00ff99?style=for-the-badge">
  <img src="https://img.shields.io/badge/Node.js-16%2B-339933?style=for-the-badge&logo=node.js&logoColor=white">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge">
</p>---

📌 About

GALLERY-SRY is a Node.js image-upload project built with Express, Socket.IO and Multer.

Users can select images themselves, preview their selection, and upload only after confirming. The project includes a Bash launcher for starting the server from Termux or a compatible Linux terminal.

✨ Features

- 🖼️ Manual image selection
- 👁️ Image previews before upload
- ✅ Upload requires user confirmation
- 📡 Live browser-session status with Socket.IO
- 📁 Stores uploaded images in the "uploads/" folder
- 📱 Mobile-friendly interface
- ⚡ Bash launcher with dependency and file checks
- 🔒 No hidden camera access or background photo collection

🛠️ Technologies

- Node.js
- Express.js
- Socket.IO
- Multer
- HTML, CSS and JavaScript
- Bash

📂 Project Structure

GALLERY-SRY/
│
├── server.js
├── Gallery-sry.html
├── sry.sh
├── package.json
├── package-lock.json
├── README.md
│
└── uploads/
    └── Uploaded images

📥 Installation

Termux

Install the required packages:

pkg update && pkg upgrade
pkg install nodejs git

Clone your repository:

git clone https://github.com/OFFICIALcybersatyam27/GALLERY-SRY.git

Open the project directory:

cd GALLERY-SRY

🚀 Start with the Bash Launcher

Run:

bash sry.sh

The launcher will:

1. Display the GALLERY-SRY terminal interface.
2. Check for "server.js", "Gallery-sry.html" and "package.json".
3. Check that Node.js and npm are installed.
4. Install dependencies using "npm ci" when a lockfile exists, or "npm install" otherwise.
5. Start the server using "npm start".

To stop the server, press "CTRL+C".

🌐 Open the Localhost Website

After the server starts, open:

http://127.0.0.1:3000

Important: Use "http://", not "https://". The local server is not configured with an HTTPS certificate.

"127.0.0.1" works on the same device running the server. To connect from another device on the same Wi-Fi, use the server device's local IP address and port "3000".

📤 How to Upload Images

1. Start the server with "bash sry.sh".
2. Open the localhost address in your browser.
3. Select images using the file picker.
4. Review the previews.
5. Confirm that you want to upload the selected images.
6. Press Upload selected photos.
7. Find the uploaded files in the server's "uploads/" directory.

Upload Limits

Setting| Limit
Images per upload| 10
Maximum file size| 10 MB per image
Accepted files| Image files
Storage| "uploads/"

📜 Package Scripts

The "package.json" file defines these npm scripts and commands:

Command| Purpose
"npm start"| Runs "node server.js" and starts the web server.
"npm install"| Installs dependencies and creates or updates "package-lock.json".
"npm ci"| Installs the exact dependency versions recorded in "package-lock.json".
"bash sry.sh"| Runs the launcher, checks files and dependencies, then starts the server.

"npm install" and "npm ci" are built-in npm commands. The custom script defined in "package.json" is "start".

🔐 Privacy & Security

- Users choose which images to upload.
- Selected images are previewed before uploading.
- Uploading requires an explicit confirmation.
- The project does not secretly access the camera or gallery.
- Uploaded images are stored on the server running this project.
- Do not publish bot tokens, passwords or other secrets in HTML, JavaScript or a public repository.

The server is intended for local testing. Before exposing it to the internet, add authentication, HTTPS, upload protections and appropriate access controls.

🧰 Troubleshooting

Node.js not found

In Termux, run:

pkg install nodejs

Dependencies or lockfile issue

Run:

npm install

Then launch again:

bash sry.sh

Website does not open

Check that the server is running and visit:

http://127.0.0.1:3000

Port 3000 is already in use

Stop the other server using port "3000", or change the "PORT" value in "server.js".

👨‍💻 Developer

OFFICIAL_cyber_satyam27

- GitHub: https://github.com/OFFICIALcybersatyam27
- YouTube: https://youtube.com/@official_cyber_satyam27

📜 License

This project is licensed under the MIT License.

---

<p align="center">
  <b>GALLERY-SRY</b><br>
  Made by OFFICIAL_cyber_satyam27
</p>