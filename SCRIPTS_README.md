# 🛠️ Android Development Environment Scripts

## 📋 Script yang Tersedia:

### 🚀 `start_android.sh` - Start Environment
Menjalankan semua service Android development:
- VNC Server (port 5901)
- noVNC Web Interface (port 6080) 
- XFCE Desktop Environment
- Android Studio

```bash
./start_android.sh
```

### 🛑 `stop_android.sh` - Stop Environment  
Menghentikan semua service Android development:
- Graceful shutdown semua processes
- Force kill jika diperlukan
- Cleanup memory

```bash
./stop_android.sh
```

### 🔍 `check_android.sh` - Cek Status
Menampilkan status lengkap environment:
- Status setiap service (running/stopped)
- CPU dan memory usage
- Port listening status
- Access URLs
- Quick action suggestions

```bash
./check_android.sh
```

## 🔄 Workflow Harian:

### **Saat Mulai Coding:**
```bash
# 1. Buka Codespaces di browser
# 2. Start environment
./start_android.sh

# 3. Akses Android Studio via browser
# URL akan muncul di output script
```

### **Saat Selesai Coding:**
```bash
# Stop semua services
./stop_android.sh

# Tutup browser, matikan laptop
```

### **Troubleshooting:**
```bash
# Cek status jika ada masalah
./check_android.sh

# Restart environment
./stop_android.sh && sleep 5 && ./start_android.sh

# Restart hanya Android Studio
pkill -f studio && DISPLAY=:1 /home/vscode/android-studio/bin/studio.sh &
```

## 🌐 Access Information:

### **noVNC Web (Recommended):**
- **URL**: Otomatis muncul di output `start_android.sh`
- **Password**: `android1`
- **Features**: Full browser access, no software needed

### **Direct VNC:**
- **Host**: `localhost` 
- **Port**: `5901`
- **Password**: `android1`
- **Requires**: VNC client software

## 📱 Connect Android Device:

```bash
# Wireless debugging (Android 11+)
adb connect YOUR_PHONE_IP:PORT

# Verify connection
adb devices

# Install APK ke HP
adb install -r app-debug.apk
```

## ⚡ Quick Commands:

```bash
# Start everything
./start_android.sh

# Check status
./check_android.sh

# Stop everything  
./stop_android.sh

# Force clean restart
./stop_android.sh && sleep 5 && ./start_android.sh

# Connect phone
adb devices
```

## 🚨 Important Notes:

- **Password VNC**: `android1` (8 characters max)
- **Memory Usage**: Android Studio uses ~2GB RAM
- **Startup Time**: ~30 seconds untuk full startup
- **URL Changes**: noVNC URL berubah setiap Codespaces session baru
- **Auto-cleanup**: Script otomatis kill processes lama sebelum start

## 🎯 Success Indicators:

Setelah `./start_android.sh`, cek:
- ✅ Semua service "running" di output
- ✅ URL noVNC muncul di terminal  
- ✅ Port 6080 accessible via browser
- ✅ Android Studio terbuka di desktop VNC

Environment siap untuk development! 🚀