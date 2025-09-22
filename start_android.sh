#!/bin/bash

echo "🚀 Starting Android Development Environment..."
echo "================================================"

# Function to check if process is running
check_process() {
    if pgrep -f "$1" > /dev/null; then
        echo "✅ $2 is running"
        return 0
    else
        echo "❌ $2 is not running"
        return 1
    fi
}

# Kill any existing processes first
echo "🧹 Cleaning up existing processes..."
pkill -f "Xvnc" 2>/dev/null
pkill -f "websockify" 2>/dev/null
pkill -f "xfce4-session" 2>/dev/null
sleep 2

# Create VNC directory if not exists
mkdir -p ~/.vnc

# Start VNC Server
echo "🖥️  Starting VNC Server..."
Xvnc :1 -geometry 1280x720 -depth 24 -rfbport 5901 -rfbauth ~/.vnc/passwd > /dev/null 2>&1 &
sleep 3

# Verify VNC started
if check_process "Xvnc" "VNC Server"; then
    echo "   🔗 VNC Port: 5901"
    echo "   🔑 Password: android1"
else
    echo "❌ Failed to start VNC Server"
    exit 1
fi

# Start XFCE Desktop Environment
echo "🖼️  Starting XFCE Desktop..."
DISPLAY=:1 xfce4-session > /dev/null 2>&1 &
sleep 3

# Start noVNC websockify
echo "🌐 Starting noVNC Web Interface..."
cd /usr/share/novnc/
websockify --web . 6080 localhost:5901 > /dev/null 2>&1 &
sleep 2

# Verify websockify started
if check_process "websockify" "noVNC websockify"; then
    echo "   🔗 Web Port: 6080"
    echo "   🌍 Access via browser"
else
    echo "❌ Failed to start noVNC websockify"
fi

# Start Android Studio
echo "📱 Starting Android Studio..."
DISPLAY=:1 /home/vscode/android-studio/bin/studio.sh > /dev/null 2>&1 &
sleep 5

# Verify Android Studio started
if check_process "studio" "Android Studio"; then
    echo "   🎯 Running on display :1"
else
    echo "⚠️  Android Studio may take a moment to start"
fi

echo ""
echo "✅ Android Development Environment Started!"
echo "================================================"
echo "🔗 Access Methods:"
echo "   • noVNC Web: https://$(echo $CODESPACE_NAME)-6080.$(echo $GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN)/"
echo "   • VNC Direct: Port 5901"
echo "   • Password: android1"
echo ""
echo "📋 Status Check: ./check_android.sh"
echo "🛑 Stop Services: ./stop_android.sh"
echo "================================================"