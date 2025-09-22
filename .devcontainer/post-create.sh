#!/bin/bash

echo "Starting post-create script..."

# Update paket dan install dependensi dasar & desktop environment
sudo apt-get update
sudo apt-get install -y wget unzip libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libgbm1 libasound2 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation lsb-release xdg-utils curl git xfce4 xfce4-goodies tigervnc-standalone-server novnc

# Download dan install Android Command Line Tools
echo "Downloading Android SDK..."
wget -q [https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip](https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip) -O commandlinetools.zip
mkdir -p /home/vscode/Android/sdk
unzip -q commandlinetools.zip -d /home/vscode/Android/cmdline-tools
mv /home/vscode/Android/cmdline-tools/cmdline-tools /home/vscode/Android/cmdline-tools/latest
rm commandlinetools.zip

# Set environment variables
echo 'export ANDROID_HOME=/home/vscode/Android/sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
echo 'export PATH=$PATH:/home/vscode/Android/cmdline-tools/latest/bin' >> ~/.bashrc
source ~/.bashrc

# Terima semua lisensi SDK secara otomatis
echo "Accepting SDK licenses..."
yes | /home/vscode/Android/cmdline-tools/latest/bin/sdkmanager --licenses

# Install komponen SDK yang dibutuhkan
echo "Installing platform-tools, build-tools, and platforms..."
/home/vscode/Android/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Download dan install Android Studio
echo "Downloading Android Studio..."
wget -q [https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.18/android-studio-2023.3.1.18-linux.tar.gz](https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.18/android-studio-2023.3.1.18-linux.tar.gz) -O android-studio.tar.gz
tar -xzf android-studio.tar.gz -C /home/vscode/
rm android-studio.tar.gz

# Setup VNC (Virtual Desktop)
echo "Setting up VNC server..."
mkdir -p ~/.vnc
echo "codespace" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
echo -e '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# Start VNC Server dan noVNC untuk akses browser
echo "Starting VNC and noVNC..."
vncserver -xstartup ~/.vnc/xstartup -geometry 1280x720 -depth 24 :1
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 &

echo "Setup complete! Android Studio is ready."
