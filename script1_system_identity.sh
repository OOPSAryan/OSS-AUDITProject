#!/bin/bash

# =============================================================================
# Script 1: System Identity Report
# Author: Aryan Baghel | Course: Open Source Software
# Registration No: 24BCE11101
# Description: Displays system identity and Python installation status
# =============================================================================

# --- Variables ---
STUDENT_NAME="Aryan Baghel"
SOFTWARE_CHOICE="Python"
REGISTRATION_NO="24BCE11101"

# --- System Information Collection ---
KERNEL=$(uname -r)
USER_NAME=$(whoami)
UPTIME=$(uptime -p)
CURRENT_DATE=$(date '+%A, %d %B %Y')
CURRENT_TIME=$(date '+%H:%M:%S %Z')
HOME_DIR=$HOME
HOSTNAME=$(hostname)

# --- Distribution Detection ---
if [ -f /etc/os-release ]; then
    DISTRO=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d'"' -f2)
elif [ -f /etc/lsb-release ]; then
    DISTRO=$(grep "DISTRIB_DESCRIPTION=" /etc/lsb-release | cut -d'"' -f2)
elif [ -f /etc/redhat-release ]; then
    DISTRO=$(cat /etc/redhat-release)
else
    DISTRO="Unknown Linux Distribution"
fi

# --- License Information ---
LICENSE_MSG="This operating system is primarily covered under GPL (GNU General Public License).
The Linux Kernel is licensed under GPL v2, ensuring freedom to use, study, modify, and distribute."

# --- Display Section ---
clear

echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    OPEN SOURCE AUDIT - SYSTEM IDENTITY                   ║"
echo "╠══════════════════════════════════════════════════════════════════════════╣"

echo "║  Student Name    : $STUDENT_NAME"
echo "║  Registration No : $REGISTRATION_NO"
echo "║  Software Audit  : $SOFTWARE_CHOICE"
echo "╠══════════════════════════════════════════════════════════════════════════╣"

echo "║                        SYSTEM INFORMATION                                ║"
echo "╠══════════════════════════════════════════════════════════════════════════╣"
echo "║  Hostname        : $HOSTNAME"
echo "║  Distribution    : $DISTRO"
echo "║  Kernel Version  : $KERNEL"
echo "║  Current User    : $USER_NAME"
echo "║  Home Directory  : $HOME_DIR"
echo "║  System Uptime   : $UPTIME"
echo "║  Current Date    : $CURRENT_DATE"
echo "║  Current Time    : $CURRENT_TIME"
echo "╠══════════════════════════════════════════════════════════════════════════╣"

echo "║                        LICENSE INFORMATION                               ║"
echo "╠══════════════════════════════════════════════════════════════════════════╣"
echo "║  $LICENSE_MSG"
echo "╚══════════════════════════════════════════════════════════════════════════╝"

# --- Python Installation Check ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    PYTHON INSTALLATION STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Python 3
if command -v python3 &> /dev/null; then
    PYTHON3_VERSION=$(python3 --version 2>&1)
    PYTHON3_PATH=$(which python3)
    echo "✓ $PYTHON3_VERSION is installed"
    echo "  Path: $PYTHON3_PATH"
else
    echo "✗ Python 3 is NOT installed"
fi

# Check Python 2
if command -v python2 &> /dev/null; then
    PYTHON2_VERSION=$(python2 --version 2>&1)
    PYTHON2_PATH=$(which python2)
    echo "✓ $PYTHON2_VERSION is installed"
    echo "  Path: $PYTHON2_PATH"
else
    echo "✗ Python 2 is NOT installed (legacy version)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Script execution completed at $(date '+%H:%M:%S on %d/%m/%Y')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Exit
exit 0
