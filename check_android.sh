#!/bin/bash

echo "🔍 Android Development Environment Status"
echo "================================================"

# Function to check process status with details
check_detailed_status() {
    local process_name="$1"
    local service_name="$2"
    local port="$3"
    
    if pgrep -f "$process_name" > /dev/null; then
        local pid=$(pgrep -f "$process_name" | head -1)
        local cpu=$(ps -p $pid -o %cpu --no-headers | tr -d ' ')
        local mem=$(ps -p $pid -o %mem --no-headers | tr -d ' ')
        echo "✅ $service_name"
        echo "   PID: $pid | CPU: ${cpu}% | Memory: ${mem}%"
        
        if [ ! -z "$port" ]; then
            if netstat -tlnp 2>/dev/null | grep ":$port " > /dev/null; then
                echo "   🔗 Port $port: LISTENING"
            else
                echo "   ❌ Port $port: NOT LISTENING"
            fi
        fi
    else
        echo "❌ $service_name: NOT RUNNING"
    fi
    echo ""
}

# Check each service
check_detailed_status "Xvnc" "VNC Server" "5901"
check_detailed_status "websockify" "noVNC websockify" "6080"  
check_detailed_status "xfce4-session" "XFCE Desktop" ""
check_detailed_status "studio" "Android Studio" ""

# Check ports summary
echo "📡 Network Ports Status:"
echo "================================================"
ports_output=$(netstat -tlnp 2>/dev/null | grep -E "(5901|6080)")
if [ ! -z "$ports_output" ]; then
    echo "$ports_output"
else
    echo "❌ No VNC/noVNC ports listening"
fi
echo ""

# Memory usage summary
echo "💾 Memory Usage:"
echo "================================================"
free -h
echo ""

# Show access information if services are running
if pgrep -f "websockify" > /dev/null; then
    echo "🌐 Access Information:"
    echo "================================================"
    echo "🔗 noVNC Web Interface:"
    echo "   URL: https://$(echo $CODESPACE_NAME)-6080.$(echo $GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN)/"
    echo "   Password: android1"
    echo ""
    echo "🔗 Direct VNC Connection:"
    echo "   Host: localhost"
    echo "   Port: 5901" 
    echo "   Password: android1"
    echo ""
fi

# Quick action suggestions
echo "⚡ Quick Actions:"
echo "================================================"
if ! pgrep -f "Xvnc\|websockify" > /dev/null; then
    echo "🚀 Start environment: ./start_android.sh"
else
    echo "🛑 Stop environment: ./stop_android.sh"
    echo "🔄 Restart environment: ./stop_android.sh && ./start_android.sh"
fi

echo "📱 Connect Android device: adb devices"
echo "🧹 Clean restart: ./stop_android.sh && sleep 5 && ./start_android.sh"
echo "================================================"