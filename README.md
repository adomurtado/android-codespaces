# Kotlin Android Development - Syntax Reference

## 📱 File Structure yang telah dibuat:

### 1. `KotlinBasics.kt` - Fundamental Kotlin
- ✅ Variables & Data Types (val/var, nullable types)
- ✅ Functions (regular, single expression, default parameters)
- ✅ Classes & Objects (primary/secondary constructors, data classes)
- ✅ Collections (List, Map, Set + operations)
- ✅ Control Flow (if-else, when, loops)
- ✅ Higher-order Functions & Lambdas
- ✅ Extension Functions

### 2. `AndroidKotlinExamples.kt` - Android Specific
- ✅ Activity & Fragment patterns
- ✅ View Binding examples
- ✅ Data Models & Sealed Classes
- ✅ Repository Pattern
- ✅ ViewModel with LiveData
- ✅ RecyclerView Adapter
- ✅ Android utility extensions
- ✅ SharedPreferences helper
- ✅ Network state checking

### 3. `ModernAndroidExamples.kt` - Modern Development
- ✅ Jetpack Compose UI
- ✅ Compose + ViewModel integration
- ✅ Coroutines & Flow
- ✅ Room Database (Entity, DAO, Database)
- ✅ Dependency Injection (Hilt)
- ✅ Navigation Component
- ✅ Permission handling

## 🚀 Cara menggunakan file-file ini:

### Di Android Studio:
1. Buka Android Studio melalui VNC (port 6080)
2. Create New Project atau buka project existing
3. Copy-paste syntax dari file-file ini sebagai referensi
4. Sesuaikan package name dan imports

### Untuk testing langsung:
```bash
# Compile Kotlin file (basic syntax)
kotlinc KotlinBasics.kt -include-runtime -d KotlinBasics.jar
java -jar KotlinBasics.jar
```

## 📚 Konsep Utama yang harus dipahami:

### 1. **Null Safety**
```kotlin
var nullable: String? = null
val length = nullable?.length ?: 0
```

### 2. **Data Classes**
```kotlin
data class User(val name: String, val age: Int)
val user = User("John", 25)
val copy = user.copy(age = 26)
```

### 3. **Lambda & Higher-Order Functions**
```kotlin
val numbers = listOf(1, 2, 3, 4, 5)
val evenNumbers = numbers.filter { it % 2 == 0 }
```

### 4. **Coroutines (Async)**
```kotlin
suspend fun fetchData(): List<User> {
    delay(1000) // Non-blocking
    return userRepository.getUsers()
}
```

### 5. **Compose UI (Modern)**
```kotlin
@Composable
fun Greeting(name: String) {
    Text(text = "Hello $name!")
}
```

## 🎯 Next Steps:

1. **Jalankan Android Studio** di VNC
2. **Buat project baru** dengan template "Empty Activity"
3. **Copy syntax** dari file-file ini untuk belajar
4. **Test di emulator** atau HP Android langsung
5. **Build APK** dan install ke device

## 📱 Tips Development:

- Gunakan **View Binding** untuk akses UI elements
- Implementasikan **MVVM pattern** dengan ViewModel
- Gunakan **Coroutines** untuk operasi async
- Manfaatkan **Extension Functions** untuk cleaner code
- Adopt **Jetpack Compose** untuk UI modern

File-file syntax dasar sudah siap digunakan! 🚀