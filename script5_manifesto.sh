#!/bin/bash

# =============================================================
# Script 5: Open Source Manifesto Generator
# Author: Aryan Baghel
# =============================================================

# --- Header ---
echo "================================================================"
echo "      OPEN SOURCE MANIFESTO GENERATOR"
echo "      Powered by your beliefs, not a corporation."
echo "================================================================"
echo ""
echo "Answer three questions honestly to generate your personal"
echo "open-source philosophy manifesto."
echo ""

# --- User Input ---
read -p "1. Name one open-source tool you use every day: " TOOL
read -p "2. In one word, what does 'freedom' mean to you? " FREEDOM
read -p "3. Name one thing you would build and share freely: " BUILD

# --- Variables ---
DATE=$(date '+%d %B %Y')
AUTHOR=$(whoami)
OUTPUT="manifesto_${AUTHOR}.txt"

echo ""
echo "Generating your manifesto..."
echo ""

# --- Generate Manifesto ---
{
echo "================================================================"
echo "  MY OPEN SOURCE MANIFESTO"
echo "  Author : $AUTHOR"
echo "  Date   : $DATE"
echo "================================================================"
echo ""
echo "I am a part of a world built on openness. Every day, I rely on"
echo "$TOOL — a tool that someone chose to build in the open and share"
echo "freely, not for profit, but because they believed that knowledge"
echo "belongs to everyone. That act of generosity shapes everything I do."
echo ""
echo "To me, freedom means $FREEDOM. In the context of software, that"
echo "word is not abstract — it is the right to read the code that runs"
echo "my computer, to change it when it does not serve me, and to share"
echo "those changes with others who might benefit."
echo ""
echo "I commit to contributing to this tradition. One day, I will build"
echo "$BUILD and release it openly — not to gain credit, but because"
echo "the open-source community gave me everything I know."
echo ""
echo "The software I write will be free as in freedom."
echo ""
echo "  — $AUTHOR, $DATE"
echo "================================================================"
} > "$OUTPUT"

# --- Show Output ---
echo "Manifesto saved to: $OUTPUT"
echo ""

cat "$OUTPUT"
