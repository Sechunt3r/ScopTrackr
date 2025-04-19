#!/bin/bash

# Subdomain Enumeration Script v2 (ScopTrackr)
# Crafted with AI — Prompted by Shivam
# Features: Bulk support, logging, reporting, time tracking, colored output, per-domain folder outputs
# Now includes: input sanitization, txt misuse check, and smart domain filtering

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m" # No Color

TARGET="$1"
TARGET_FILE=""
TARGETS_FILE="all_targets.txt"
SUBDOMAINS_FILE="all_subdomains.txt"
HTTPX_FILE="httpx_subdomains.txt"
LOG_FILE="scan_log.txt"
REPORT_FILE="report.csv"

function banner() {
    command -v figlet >/dev/null 2>&1 && figlet "ScopTrackr" || echo "=== ScopTrackr ==="
    echo -e "${YELLOW}⚡ ScopTrackr - Scope it. Track it. Hack it. ⚡${NC}"
    echo -e "${YELLOW}❤️  Crafted with AI — Prompted by Shivam 👨‍💻${NC}"
    echo
}

function usage() {
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ./scoptrackr.sh <domain>           # Scan a single domain"
    echo "  ./scoptrackr.sh -f domains.txt     # Scan multiple domains from file"
    echo
    echo -e "${YELLOW}Features:${NC}"
    echo "  ✔ Adds root domains to all_targets.txt"
    echo "  ✔ Stores all subdomains in all_subdomains.txt"
    echo "  ✔ Stores only live subdomains in httpx_subdomains.txt"
    echo "  ✔ Creates output/<domain>/ folder with detailed results"
    echo "  ✔ Logs summary in scan_log.txt"
    echo "  ✔ Generates CSV report in report.csv"
    echo "  ✔ Tracks time taken for each scan"
    echo "  ✔ Colored, clean, and user-friendly output"
    echo
}

function scan_domain() {
    local domain=$1
    local tmp_subs="temp_${domain}_subs.txt"
    local tmp_httpx="temp_${domain}_httpx.txt"

    echo -e "${GREEN}[*] Finding subdomains for: $domain${NC}"
    subfinder -d "$domain" -silent > "$tmp_subs"

    mkdir -p output/"$domain"
    cp "$tmp_subs" output/"$domain"/subdomains.txt

    grep -qxF "$domain" "$TARGETS_FILE" 2>/dev/null || echo "$domain" >> "$TARGETS_FILE"
    touch "$SUBDOMAINS_FILE"
    grep -vxFf "$SUBDOMAINS_FILE" "$tmp_subs" >> "$SUBDOMAINS_FILE"

    TOTAL=$(cat "$tmp_subs" | wc -l | xargs)

    cat "$tmp_subs" | httpx -silent > "$tmp_httpx"
    cp "$tmp_httpx" output/"$domain"/live_subdomains.txt

    touch "$HTTPX_FILE"
    grep -vxFf "$HTTPX_FILE" "$tmp_httpx" >> "$HTTPX_FILE"

    cat "$tmp_httpx"

    LIVE=$(cat "$tmp_httpx" | wc -l | xargs)

    echo -e "${GREEN}[*] Finished scanning $domain. Found $TOTAL subdomains, $LIVE are live.${NC}"
    echo "[$(date)] $domain | Total: $TOTAL | Live: $LIVE" >> "$LOG_FILE"
    echo "$domain,$TOTAL,$LIVE" >> "$REPORT_FILE"

    rm "$tmp_subs" "$tmp_httpx"
}

function main() {
    banner
    echo "Domain,Total Subdomains,Live Subdomains" > "$REPORT_FILE"

    # Safety check: If user passed a .txt file as domain (instead of using -f)
    if [[ "$1" =~ \.txt$ && "$1" != "-f" ]]; then
        echo -e "${RED}[!] Detected a .txt file as input. Did you mean to use:${NC}"
        echo -e "${YELLOW}    ./scoptrackr.sh -f $1${NC}"
        exit 1
    fi

    if [[ "$1" == "-f" && -n "$2" ]]; then
while IFS= read -r domain || [[ -n "$domain" ]]; do
    # Clean and sanitize input
    domain=$(echo "$domain" | xargs | sed 's/[^a-zA-Z0-9.-]//g')

    # Validate domain format
    if [[ -z "$domain" || ! "$domain" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo -e "${YELLOW}[!] Skipping invalid input: '$domain'${NC}"
        continue
    fi

    start=$(date +%s)
    scan_domain "$domain"
    end=$(date +%s)
    echo -e "${GREEN}[*] Time taken: $((end - start)) seconds${NC}"
    echo ""
done < "$2"
    elif [[ -n "$1" ]]; then
        start=$(date +%s)
        scan_domain "$1"
        end=$(date +%s)
        echo -e "${GREEN}[*] Time taken: $((end - start)) seconds${NC}"
    else
        usage
        exit 1
    fi
}

main "$@"
