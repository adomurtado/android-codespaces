#!/bin/bash

echo "🛑 Stopping Android Development Environment..."
echo "================================================"

# Function to stop process and verify
stop_process() {
    local process_name="$1"
    local display_name="$2"
    
    echo "🔄 Stopping $display_name..."
    
    # Kill the process
    pkill -f "$process_name" 2>/dev/null
    sleep 2
    
    # Check if process is still running
    if pgrep -f "$process_name" > /dev/null; then
        echo "⚠️  Force killing $display_name..."
        pkill -9 -f "$process_name" 2>/dev/null
        sleep 1
    fi
    
    # Final check
    if ! pgrep -f "$process_name" > /dev/null; then
        echo "✅ $display_name stopped"
    else
        echo "❌ Failed to stop $display_name"
    fi
}

# Stop Android Studio
stop_process "studio" "Android Studio"

# Stop noVNC websockify
stop_process "websockify" "noVNC websockify"

# Stop XFCE Desktop
stop_process "xfce4-session" "XFCE Desktop"

# Stop VNC Server
echo "🔄 Stopping VNC Server..."
vncserver -kill :1 2>/dev/null
pkill -f "Xvnc" 2>/dev/null
sleep 2

if ! pgrep -f "Xvnc" > /dev/null; then
    echo "✅ VNC Server stopped"
else
    echo "❌ Failed to stop VNC Server"
fi

# Clean up any remaining Java processes from Android Studio
echo "🧹 Cleaning up remaining processes..."
pkill -f "java.*studio" 2>/dev/null

# Show final status
echo ""
echo "📊 Final Process Check:"
echo "================================================"

remaining_processes=$(ps aux | grep -E "(Xvnc|websockify|xfce|studio)" | grep -v grep | wc -l)

if [ "$remaining_processes" -eq 0 ]; then
    echo "✅ All Android environment processes stopped successfully"
else
    echo "⚠️  Some processes may still be running:"
    ps aux | grep -E "(Xvnc|websockify|xfce|studio)" | grep -v grep
fi

echo ""
echo "🚀 To restart: ./start_android.sh"
echo "================================================"