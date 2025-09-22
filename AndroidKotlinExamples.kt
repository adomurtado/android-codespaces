// ===== ANDROID-SPECIFIC KOTLIN SYNTAX =====

// 1. ACTIVITY CLASS EXAMPLE
class MainActivity : AppCompatActivity() {
    
    // Late initialization
    private lateinit var textView: TextView
    private lateinit var button: Button
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Initialize views
        initViews()
        setupClickListeners()
    }
    
    private fun initViews() {
        // View binding (modern approach)
        textView = findViewById(R.id.textView)
        button = findViewById(R.id.button)
        
        // Set initial text
        textView.text = "Hello Android with Kotlin!"
    }
    
    private fun setupClickListeners() {
        // Lambda expression for click listener
        button.setOnClickListener {
            showToast("Button clicked!")
            updateTextView("Button was pressed")
        }
        
        // Long click listener
        button.setOnLongClickListener {
            showToast("Long press detected")
            true // Return true to consume the event
        }
    }
    
    private fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }
    
    private fun updateTextView(newText: String) {
        textView.text = newText
    }
}

// 2. FRAGMENT EXAMPLE
class HomeFragment : Fragment() {
    
    // View binding (recommended approach)
    private var _binding: FragmentHomeBinding? = null
    private val binding get() = _binding!!
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        setupUI()
    }
    
    private fun setupUI() {
        binding.apply {
            titleTextView.text = "Welcome to Home Fragment"
            
            actionButton.setOnClickListener {
                navigateToNextScreen()
            }
        }
    }
    
    private fun navigateToNextScreen() {
        // Navigation component example
        findNavController().navigate(R.id.action_home_to_detail)
    }
    
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null // Prevent memory leaks
    }
}

// 3. DATA MODELS
data class User(
    val id: Int,
    val name: String,
    val email: String,
    val avatar: String? = null
)

data class ApiResponse<T>(
    val success: Boolean,
    val message: String,
    val data: T?
)

// Sealed classes for handling different states
sealed class UiState {
    object Loading : UiState()
    data class Success(val data: List<User>) : UiState()
    data class Error(val message: String) : UiState()
}

// 4. REPOSITORY PATTERN
class UserRepository {
    
    private val apiService = createApiService()
    
    suspend fun getUsers(): ApiResponse<List<User>> {
        return try {
            val response = apiService.getUsers()
            if (response.isSuccessful) {
                ApiResponse(true, "Success", response.body())
            } else {
                ApiResponse(false, "Failed to fetch users", null)
            }
        } catch (e: Exception) {
            ApiResponse(false, e.message ?: "Unknown error", null)
        }
    }
    
    suspend fun getUserById(id: Int): User? {
        return try {
            val response = apiService.getUserById(id)
            if (response.isSuccessful) {
                response.body()
            } else {
                null
            }
        } catch (e: Exception) {
            null
        }
    }
    
    private fun createApiService(): ApiService {
        // Retrofit service creation
        return Retrofit.Builder()
            .baseUrl("https://api.example.com/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ApiService::class.java)
    }
}

// 5. VIEWMODEL WITH COROUTINES
class UserViewModel(private val repository: UserRepository) : ViewModel() {
    
    private val _uiState = MutableLiveData<UiState>()
    val uiState: LiveData<UiState> = _uiState
    
    private val _selectedUser = MutableLiveData<User?>()
    val selectedUser: LiveData<User?> = _selectedUser
    
    fun loadUsers() {
        _uiState.value = UiState.Loading
        
        viewModelScope.launch {
            val response = repository.getUsers()
            if (response.success && response.data != null) {
                _uiState.value = UiState.Success(response.data)
            } else {
                _uiState.value = UiState.Error(response.message)
            }
        }
    }
    
    fun selectUser(userId: Int) {
        viewModelScope.launch {
            val user = repository.getUserById(userId)
            _selectedUser.value = user
        }
    }
    
    fun refreshUsers() {
        loadUsers()
    }
}

// 6. RECYCLERVIEW ADAPTER
class UserAdapter(
    private val onUserClick: (User) -> Unit
) : RecyclerView.Adapter<UserAdapter.UserViewHolder>() {
    
    private var users = emptyList<User>()
    
    fun updateUsers(newUsers: List<User>) {
        users = newUsers
        notifyDataSetChanged()
    }
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UserViewHolder {
        val binding = ItemUserBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return UserViewHolder(binding)
    }
    
    override fun onBindViewHolder(holder: UserViewHolder, position: Int) {
        holder.bind(users[position])
    }
    
    override fun getItemCount() = users.size
    
    inner class UserViewHolder(
        private val binding: ItemUserBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        
        fun bind(user: User) {
            binding.apply {
                nameTextView.text = user.name
                emailTextView.text = user.email
                
                // Load avatar image using Glide/Picasso
                user.avatar?.let { avatarUrl ->
                    Glide.with(itemView.context)
                        .load(avatarUrl)
                        .placeholder(R.drawable.ic_placeholder)
                        .into(avatarImageView)
                }
                
                // Set click listener
                root.setOnClickListener {
                    onUserClick(user)
                }
            }
        }
    }
}

// 7. UTILITY EXTENSIONS FOR ANDROID
fun Context.showToast(message: String, duration: Int = Toast.LENGTH_SHORT) {
    Toast.makeText(this, message, duration).show()
}

fun View.visible() {
    visibility = View.VISIBLE
}

fun View.gone() {
    visibility = View.GONE
}

fun View.invisible() {
    visibility = View.INVISIBLE
}

fun ImageView.loadUrl(url: String) {
    Glide.with(context)
        .load(url)
        .placeholder(R.drawable.ic_placeholder)
        .into(this)
}

// 8. SHARED PREFERENCES HELPER
class PreferenceManager(context: Context) {
    
    private val prefs = context.getSharedPreferences("app_prefs", Context.MODE_PRIVATE)
    
    fun saveString(key: String, value: String) {
        prefs.edit().putString(key, value).apply()
    }
    
    fun getString(key: String, defaultValue: String = ""): String {
        return prefs.getString(key, defaultValue) ?: defaultValue
    }
    
    fun saveBoolean(key: String, value: Boolean) {
        prefs.edit().putBoolean(key, value).apply()
    }
    
    fun getBoolean(key: String, defaultValue: Boolean = false): Boolean {
        return prefs.getBoolean(key, defaultValue)
    }
    
    fun saveInt(key: String, value: Int) {
        prefs.edit().putInt(key, value).apply()
    }
    
    fun getInt(key: String, defaultValue: Int = 0): Int {
        return prefs.getInt(key, defaultValue)
    }
    
    fun clear() {
        prefs.edit().clear().apply()
    }
}

// 9. NETWORK STATE CHECKER
class NetworkHelper(private val context: Context) {
    
    fun isNetworkAvailable(): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) 
                as ConnectivityManager
        
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork
            val capabilities = connectivityManager.getNetworkCapabilities(network)
            capabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
        } else {
            @Suppress("DEPRECATION")
            val networkInfo = connectivityManager.activeNetworkInfo
            networkInfo?.isConnected == true
        }
    }
    
    fun getNetworkType(): String {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) 
                as ConnectivityManager
        
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork
            val capabilities = connectivityManager.getNetworkCapabilities(network)
            when {
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true -> "WiFi"
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) == true -> "Mobile"
                else -> "Unknown"
            }
        } else {
            @Suppress("DEPRECATION")
            val networkInfo = connectivityManager.activeNetworkInfo
            networkInfo?.typeName ?: "Unknown"
        }
    }
}