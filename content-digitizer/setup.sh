#!/usr/bin/env bash
# content-digitizer/setup.sh
#
# Installs and updates the local tools this skill relies on for digitization
# conversions (see local-tools.md for what each one is used for). Safe to
# re-run at any time -- every step upgrades in place if a newer version is
# available and no-ops if the tool is already current, so this script IS the
# Tool Readiness Check described in local-tools.md, not just documentation
# of one.
#
# Usage:
#   ./setup.sh              Install/upgrade the core toolset (PDF, OCR,
#                            document conversion, archives, JSON/XML)
#   ./setup.sh --check       Report installed versions only, no changes
#   ./setup.sh --with-heavy  Also install optional heavy tools: Whisper
#                            (audio/video transcription), LibreOffice
#                            (legacy doc formats), a headless browser
#                            (client-rendered HTML)
#
# Requires a supported package manager (apt-get, brew, or dnf) and, for the
# apt/dnf paths, sudo privileges. If neither is available -- e.g. a locked-
# down sandbox with no package manager or no network -- this script will
# say so explicitly rather than silently doing nothing; fall back to the
# manual guidance in local-tools.md and flag the limitation per this
# skill's Rule of Engagement 9.

set -euo pipefail

CHECK_ONLY=false
WITH_HEAVY=false
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=true ;;
    --with-heavy) WITH_HEAVY=true ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^#//; s/^ //'
      exit 0
      ;;
    *) echo "Unknown option: $arg (use --check, --with-heavy, or --help)" >&2; exit 1 ;;
  esac
done

log() { printf '\n=== %s ===\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

report() {
  local name="$1"; shift
  if have "$name"; then
    printf '%-14s %s\n' "$name" "$("$@" 2>&1 | head -n1)"
  else
    printf '%-14s not installed\n' "$name"
  fi
}

if $CHECK_ONLY; then
  log "Installed versions (check-only -- no changes made)"
  report pdftotext pdftotext -v
  report tesseract tesseract --version
  report pandoc pandoc --version
  report ffmpeg ffmpeg -version
  report jq jq --version
  report unzip unzip -v
  report 7z 7z
  report soffice soffice --version
  echo
  echo "Python conversion libraries:"
  python3 -m pip show pymupdf pdfplumber python-docx python-pptx openpyxl pandas ocrmypdf 2>/dev/null \
    | grep -E '^(Name|Version): ' || echo "  (none of the expected packages found)"
  echo
  echo "Run without --check to install anything missing or update anything outdated."
  exit 0
fi

# --- Detect package manager ---
if have apt-get; then
  PM=apt
elif have brew; then
  PM=brew
elif have dnf; then
  PM=dnf
else
  echo "No supported package manager found (apt-get/brew/dnf)." >&2
  echo "This environment can't be auto-provisioned -- install tools manually per local-tools.md," >&2
  echo "and flag this limitation explicitly per Rule of Engagement 9 before converting anything." >&2
  exit 1
fi

install_or_upgrade() {
  local pkg="$1"
  case "$PM" in
    apt)
      sudo apt-get install -y --only-upgrade "$pkg" 2>/dev/null || sudo apt-get install -y "$pkg"
      ;;
    brew)
      brew list "$pkg" >/dev/null 2>&1 && brew upgrade "$pkg" || brew install "$pkg"
      ;;
    dnf)
      sudo dnf install -y "$pkg"
      ;;
  esac
}

log "Updating package index"
case "$PM" in
  apt)  sudo apt-get update -y ;;
  brew) brew update ;;
  dnf)  sudo dnf check-update -y || true ;;  # dnf exits 100 when updates ARE available -- not an error here
esac

log "Core toolset: PDF text extraction, OCR, document conversion, audio, archives, JSON/XML"
case "$PM" in
  apt)
    install_or_upgrade poppler-utils       # pdftotext -- native PDF text-layer extraction
    install_or_upgrade tesseract-ocr       # OCR engine
    install_or_upgrade tesseract-ocr-eng   # English language pack -- add more (e.g. tesseract-ocr-tha) as needed
    install_or_upgrade pandoc              # docx/html/markdown conversion
    install_or_upgrade ffmpeg              # audio/video extraction ahead of transcription
    install_or_upgrade jq                  # JSON manipulation
    install_or_upgrade libxml2-utils       # xmllint -- XML handling
    install_or_upgrade unzip
    install_or_upgrade p7zip-full
    ;;
  brew)
    install_or_upgrade poppler
    install_or_upgrade tesseract
    install_or_upgrade pandoc
    install_or_upgrade ffmpeg
    install_or_upgrade jq
    install_or_upgrade libxml2
    install_or_upgrade p7zip
    ;;
  dnf)
    install_or_upgrade poppler-utils
    install_or_upgrade tesseract
    install_or_upgrade pandoc
    install_or_upgrade ffmpeg
    install_or_upgrade jq
    install_or_upgrade libxml2
    install_or_upgrade p7zip
    ;;
esac

log "Python conversion libraries"
python3 -m pip install --upgrade --quiet \
  pymupdf pdfplumber python-docx python-pptx openpyxl pandas ocrmypdf

if $WITH_HEAVY; then
  log "Optional heavy tools (--with-heavy): Whisper transcription, LibreOffice, headless browser"
  python3 -m pip install --upgrade --quiet openai-whisper
  case "$PM" in
    apt)  install_or_upgrade libreoffice ;;
    brew) brew list --cask libreoffice >/dev/null 2>&1 && brew upgrade --cask libreoffice || brew install --cask libreoffice ;;
    dnf)  install_or_upgrade libreoffice ;;
  esac
  if have npm; then
    npx --yes playwright install --with-deps chromium
  else
    echo "npm not found -- skipping headless browser install (only needed for client-rendered HTML)." >&2
  fi
fi

log "Done"
echo "Re-run './setup.sh --check' before a conversion batch to confirm versions are current."
