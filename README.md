![ScopTrackr Banner](banner.png)

# ⚡ ScopTrackr ⚡  - **Scope it. Track it. Hack it.**
*A Bash-based subdomain enumeration script to track targets, live hosts, and subdomain statistics.*  
❤️ Crafted with AI — Prompted by Shivam 👨‍💻  

---

## 📌 What It Does

ScopTrackr is a Bash-powered automation script that helps you:

- Discover subdomains using `subfinder`
- Check which subdomains are alive using `httpx`
- Track and organize target domains
- Log results with summary counts and timestamps
- Store everything in a structured, deduplicated format

---

## ✨ Features

- ✅ Single and bulk domain input support
- ✅ Auto-sanitizes malformed or noisy inputs
- ✅ Handles `.txt` misuse (mistakenly passed without `-f`)
- ✅ Ensures last-line processing in input files
- ✅ Outputs per-domain data in organized folders
- ✅ Real-time logs, CSV summaries, and total counts
- ✅ Clean, colorized terminal UI

---

## 🛠 Requirements

- `subfinder`
- `httpx`
- `figlet` (optional, for the header)

Install via:
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
brew install figlet  # for macOS (optional)
```

---

## 🚀 Usage

### ▶️ Scan a single domain:
```bash
./scoptrackr.sh example.com
```

### 📂 Scan a list of domains:
```bash
./scoptrackr.sh -f domains.txt
```

---

## 📁 Output Structure

```
.
├── all_targets.txt
├── all_subdomains.txt
├── httpx_subdomains.txt
├── scan_log.txt
├── report.csv
└── output/
    └── example.com/
        ├── subdomains.txt
        └── live_subdomains.txt
```
