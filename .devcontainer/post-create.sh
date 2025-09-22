#!/bin/bash
set -e  # Exit on any error

echo "Starting post-create script..."
echo "OS Info: $(cat /etc/os-release | grep PRETTY_NAME)"

# Pastikan environment non-interactive
export DEBIAN_FRONTEND=noninteractive

echo "Updating package lists..."
sudo apt-get update

echo "Installing base dependencies and desktop environment..."
sudo apt-get install -y wget unzip libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libgbm1 libasound2 \
    libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation lsb-release xdg-utils curl git xfce4 xfce4-goodies \
    tigervnc-standalone-server novnc

echo "Base packages installed successfully."

# Download dan install Android Command Line Tools
echo "Downloading Android SDK..."
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O commandlinetools.zip

echo "Setting up Android SDK..."
mkdir -p /home/vscode/Android/sdk
mkdir -p /home/vscode/Android/cmdline-tools
unzip -q commandlinetools.zip -d /home/vscode/Android/cmdline-tools
mv /home/vscode/Android/cmdline-tools/cmdline-tools /home/vscode/Android/cmdline-tools/latest
rm commandlinetools.zip

# Set ownership untuk user vscode
sudo chown -R vscode:vscode /home/vscode/Android

# Set environment variables
echo "Setting up environment variables..."
{
    echo 'export ANDROID_HOME=/home/vscode/Android/sdk'
    echo 'export PATH=$PATH:$ANDROID_HOME/emulator'
    echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools'
    echo 'export PATH=$PATH:/home/vscode/Android/cmdline-tools/latest/bin'
} >> /home/vscode/.bashrc

# Source environment untuk sesi ini
export ANDROID_HOME=/home/vscode/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/home/vscode/Android/cmdline-tools/latest/bin

# Terima semua lisensi SDK secara otomatis
echo "Accepting SDK licenses..."
yes | /home/vscode/Android/cmdline-tools/latest/bin/sdkmanager --licenses

# Install komponen SDK yang dibutuhkan
echo "Installing platform-tools, build-tools, and platforms..."
/home/vscode/Android/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Download dan install Android Studio
echo "Downloading Android Studio..."
wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.18/android-studio-2023.3.1.18-linux.tar.gz -O android-studio.tar.gz

echo "Installing Android Studio..."
tar -xzf android-studio.tar.gz -C /home/vscode/
rm android-studio.tar.gz

# Set ownership untuk Android Studio
sudo chown -R vscode:vscode /home/vscode/android-studio

# Setup VNC (Virtual Desktop)
echo "Setting up VNC server..."
mkdir -p /home/vscode/.vnc
echo "codespace" | vncpasswd -f > /home/vscode/.vnc/passwd
chmod 600 /home/vscode/.vnc/passwd
echo -e '#!/bin/bash\nxrdb $HOME/.Xresources 2>/dev/null || true\nstartxfce4 &' > /home/vscode/.vnc/xstartup
chmod +x /home/vscode/.vnc/xstartup

# Set ownership untuk VNC directory
sudo chown -R vscode:vscode /home/vscode/.vnc

# Start VNC Server dan noVNC untuk akses browser
echo "Starting VNC and noVNC..."
su - vscode -c "vncserver -xstartup /home/vscode/.vnc/xstartup -geometry 1280x720 -depth 24 :1" || true

# Start noVNC dalam background
nohup /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 > /dev/null 2>&1 &

echo "Setup complete! Android Studio is ready."
echo "VNC accessible on port 5901, noVNC web interface on port 6080"
