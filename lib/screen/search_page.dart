import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/services/database_service.dart';
import 'package:grocery_app/models/product_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  final Color primaryGreen = const Color(0xFF53B175);

  // Hardcoded products matching home_screen.dart
  final List<Map<String, dynamic>> hardcodedProducts = const [
    {
      'id': 'product_1',
      'name': 'Organic Bananas',
      'quantity': '7pcs',
      'price': 4.99,
      'imagePath': 'assets/images/banana.jpg',
      'section': 'exclusive',
      'description': 'Premium organic bananas, naturally sweet and packed with potassium.',
      'category': 'Fresh Fruits & Vegetable',
    },
    {
      'id': 'product_2',
      'name': 'Red Apple',
      'quantity': '1kg',
      'price': 4.99,
      'imagePath': 'assets/images/apple.jpg',
      'section': 'exclusive',
      'description': 'Crisp and juicy red apples, perfect for snacking.',
      'category': 'Fresh Fruits & Vegetable',
    },
    {
      'id': 'product_6',
      'name': 'Organic Cucumber',
      'quantity': '1pc',
      'price': 1.99,
      'imagePath': 'assets/images/cucumber.jpg',
      'section': 'exclusive',
      'description': 'Fresh organic cucumbers, crisp and refreshing.',
      'category': 'Fresh Fruits & Vegetable',
    },
    {
      'id': 'product_3',
      'name': 'Bell Pepper Red',
      'quantity': '1kg',
      'price': 4.99,
      'imagePath': 'assets/images/bell_paper.jpeg',
      'section': 'best_selling',
      'description': 'Crisp and vibrant red bell peppers, rich in vitamins A and C.',
      'category': 'Fresh Fruits & Vegetable',
    },
    {
      'id': 'product_4',
      'name': 'Ginger',
      'quantity': '250gm',
      'price': 4.99,
      'imagePath': 'assets/images/ginger.jpeg',
      'section': 'best_selling',
      'description': 'Fresh ginger root, perfect for cooking and tea.',
      'category': 'Fresh Fruits & Vegetable',
    },
    {
      'id': 'product_5',
      'name': 'Watermelon',
      'quantity': '1pc',
      'price': 3.50,
      'imagePath': 'assets/images/watermelon.jpg',
      'section': 'best_selling',
      'description': 'Sweet and juicy watermelon, perfect for summer.',
      'category': 'Fresh Fruits & Vegetable',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    // Convert hardcoded products to ProductModel
    _allProducts = hardcodedProducts.map((product) {
      return ProductModel(
        id: product['id'],
        name: product['name'],
        description: product['description'],
        price: product['price'],
        quantity: product['quantity'],
        imagePath: product['imagePath'],
        category: product['category'],
        section: product['section'],
        inStock: true,
        stockCount: 100,
        rating: 4.5,
        reviewCount: 20,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  void _searchProducts(String query) {
    setState(() {
      _hasSearched = true;
      if (query.isEmpty) {
        _filteredProducts = [];
      } else {
        _filteredProducts = _allProducts.where((product) {
          final nameLower = product.name.toLowerCase();
          final categoryLower = product.category.toLowerCase();
          final descriptionLower = product.description.toLowerCase();
          final searchLower = query.toLowerCase();
          
          return nameLower.contains(searchLower) ||
                 categoryLower.contains(searchLower) ||
                 descriptionLower.contains(searchLower);
        }).toList();
        
        // Add to recent searches if not empty and not already exists
        if (!_recentSearches.contains(query)) {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        }
      }
    });
  }

  Future<void> _toggleFavorite(String productId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add favorites'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final isFav = await _databaseService.isFavorite(currentUser.uid, productId);
      
      if (isFav) {
        await _databaseService.removeFromFavorites(currentUser.uid, productId);
      } else {
        await _databaseService.addToFavorites(currentUser.uid, productId);
      }
      
      setState(() {}); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _addToCart(ProductModel product) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add items to cart'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final cartItemId = '${currentUser.uid}_${product.id}';
      final cartItem = CartItem(
        id: cartItemId,
        userId: currentUser.uid,
        productId: product.id,
        productName: product.name,
        productImage: product.imagePath,
        price: product.price,
        quantity: product.quantity,
        itemCount: 1,
        addedAt: DateTime.now(),
      );

      await _databaseService.addToCart(currentUser.uid, cartItem);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _searchProducts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _searchProducts,
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Show recent searches if no search has been performed
    if (!_hasSearched || _searchController.text.isEmpty) {
      return _buildRecentSearches();
    }

    // Show loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show no results
    if (_filteredProducts.isEmpty) {
      return _buildNoResults();
    }

    // Show results
    return _buildSearchResults();
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Search for products',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try "banana", "apple", or "vegetables"',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(color: primaryGreen),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final search = _recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(search),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _recentSearches.removeAt(index);
                    });
                  },
                ),
                onTap: () {
                  _searchController.text = search;
                  _searchProducts(search);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product_detail',
          arguments: {
            'id': product.id,
            'name': product.name,
            'quantity': product.quantity,
            'price': product.price,
            'imagePath': product.imagePath,
            'description': product.description,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  product.imagePath,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.shopping_basket,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.quantity,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // Add to Cart Button
              Column(
                children: [
                  FutureBuilder<bool>(
                    future: _auth.currentUser != null
                        ? _databaseService.isFavorite(
                            _auth.currentUser!.uid, product.id)
                        : Future.value(false),
                    builder: (context, snapshot) {
                      final isFav = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(product.id),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      minimumSize: const Size(45, 45),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}