// ===== KOTLIN BASICS FOR ANDROID DEVELOPMENT =====

// 1. VARIABLES & DATA TYPES
fun variablesAndDataTypes() {
    // Immutable (val) vs Mutable (var)
    val name: String = "Android Developer" // Cannot be changed
    var age: Int = 25 // Can be changed
    
    // Type inference (Kotlin can detect type automatically)
    val city = "Jakarta" // String
    val height = 175.5   // Double
    val isStudent = true // Boolean
    
    // Nullable types
    var email: String? = null
    email = "user@example.com"
    
    // Safe call operator
    println("Email length: ${email?.length}")
    
    // Elvis operator (default value if null)
    val displayEmail = email ?: "No email provided"
    println(displayEmail)
}

// 2. FUNCTIONS
fun greetUser(name: String, age: Int = 18): String {
    return "Hello $name, you are $age years old"
}

// Single expression function
fun calculateArea(width: Double, height: Double) = width * height

// Function with no return value
fun printMessage(message: String): Unit {
    println(message)
}

// 3. CLASSES & OBJECTS
class User(val name: String, var age: Int) {
    // Properties
    var email: String = ""
    
    // Secondary constructor
    constructor(name: String, age: Int, email: String) : this(name, age) {
        this.email = email
    }
    
    // Methods
    fun getDisplayName(): String = "User: $name"
    
    fun updateAge(newAge: Int) {
        if (newAge > 0) {
            age = newAge
        }
    }
}

// Data class (automatically generates equals, hashCode, toString, copy)
data class Product(val id: Int, val name: String, val price: Double)

// 4. COLLECTIONS
fun collectionsExample() {
    // Lists
    val fruits = listOf("Apple", "Banana", "Orange") // Immutable list
    val mutableFruits = mutableListOf("Apple", "Banana") // Mutable list
    mutableFruits.add("Orange")
    
    // Maps
    val userMap = mapOf(
        "id" to 1,
        "name" to "John",
        "email" to "john@example.com"
    )
    
    // Sets
    val uniqueNumbers = setOf(1, 2, 3, 2, 1) // Will contain [1, 2, 3]
    
    // Iteration
    for (fruit in fruits) {
        println("Fruit: $fruit")
    }
    
    // Lambda expressions with collections
    val uppercaseFruits = fruits.map { it.uppercase() }
    val longFruits = fruits.filter { it.length > 5 }
}

// 5. CONTROL FLOW
fun controlFlowExamples() {
    val score = 85
    
    // If-else expressions
    val grade = if (score >= 90) {
        "A"
    } else if (score >= 80) {
        "B"
    } else if (score >= 70) {
        "C"
    } else {
        "F"
    }
    
    // When expression (similar to switch)
    when (grade) {
        "A" -> println("Excellent!")
        "B" -> println("Good job!")
        "C" -> println("Keep trying!")
        else -> println("Need improvement")
    }
    
    // For loops
    for (i in 1..5) {
        println("Number: $i")
    }
    
    for (i in 10 downTo 1 step 2) {
        println("Countdown: $i")
    }
    
    // While loop
    var counter = 0
    while (counter < 3) {
        println("Counter: $counter")
        counter++
    }
}

// 6. HIGHER-ORDER FUNCTIONS
fun operateOnNumbers(a: Int, b: Int, operation: (Int, Int) -> Int): Int {
    return operation(a, b)
}

fun functionalProgrammingExample() {
    // Using lambda
    val sum = operateOnNumbers(5, 3) { x, y -> x + y }
    val multiply = operateOnNumbers(5, 3) { x, y -> x * y }
    
    println("Sum: $sum, Multiply: $multiply")
    
    // Collection operations
    val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    
    val evenNumbers = numbers.filter { it % 2 == 0 }
    val doubledNumbers = numbers.map { it * 2 }
    val sumOfAll = numbers.reduce { acc, num -> acc + num }
    
    println("Even numbers: $evenNumbers")
    println("Doubled: $doubledNumbers")
    println("Sum of all: $sumOfAll")
}

// 7. EXTENSION FUNCTIONS
fun String.isValidEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}

fun Int.isEven(): Boolean = this % 2 == 0

// Usage example
fun extensionExample() {
    val email = "user@example.com"
    println("Is valid email: ${email.isValidEmail()}")
    
    val number = 42
    println("Is even: ${number.isEven()}")
}

// 8. MAIN FUNCTION
fun main() {
    println("=== Kotlin Basics Demo ===")
    
    variablesAndDataTypes()
    
    val greeting = greetUser("Alice", 30)
    println(greeting)
    
    val user = User("Bob", 25, "bob@example.com")
    println(user.getDisplayName())
    
    val product = Product(1, "Laptop", 999.99)
    println(product)
    
    collectionsExample()
    controlFlowExamples()
    functionalProgrammingExample()
    extensionExample()
    
    println("=== Demo Complete ===")
}