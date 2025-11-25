import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/services/database_service.dart';
import 'package:grocery_app/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> bannerImages = const [
    'assets/images/grocery_back.jpg',
    'assets/images/banner5.webp',
    'assets/images/banner7.jpeg',
  ];

  final List<Map<String, dynamic>> products = const [
    {
      'id': 'product_1',
      'name': 'Organic Bananas',
      'quantity': '7pcs',
      'price': 4.99,
      'imagePath': 'assets/images/banana.jpg',
      'section': 'exclusive',
      'description':
          'Premium organic bananas, naturally sweet and packed with potassium. Perfect for smoothies or a quick, healthy snack.',
    },
    {
      'id': 'product_2',
      'name': 'Red Apple',
      'quantity': '1kg',
      'price': 4.99,
      'imagePath': 'assets/images/apple.jpg',
      'section': 'exclusive',
      'description': 'Crisp and juicy red apples, perfect for snacking.',
    },
    {
      'id': 'product_6',
      'name': 'Organic Cucumber',
      'quantity': '1pc',
      'price': 1.99,
      'imagePath': 'assets/images/cucumber.jpg',
      'section': 'exclusive',
      'description': 'Fresh organic cucumbers, crisp and refreshing.',
    },
    {
      'id': 'product_3',
      'name': 'Bell Pepper Red',
      'quantity': '1kg',
      'price': 4.99,
      'imagePath': 'assets/images/bell_paper.jpeg',
      'section': 'best_selling',
      'description':
          'Crisp and vibrant red bell peppers, rich in vitamins A and C. Ideal for salads, stir-fries, and adding a sweet crunch to any dish.',
    },
    {
      'id': 'product_4',
      'name': 'Ginger',
      'quantity': '250gm',
      'price': 4.99,
      'imagePath': 'assets/images/ginger.jpeg',
      'section': 'best_selling',
      'description': 'Fresh ginger root, perfect for cooking and tea.',
    },
    {
      'id': 'product_5',
      'name': 'Watermelon',
      'quantity': '1pc',
      'price': 3.50,
      'imagePath': 'assets/images/watermelon.jpg',
      'section': 'best_selling',
      'description': 'Sweet and juicy watermelon, perfect for summer.',
    },
  ];

  // Store favorite status for each product
  Map<String, bool> _favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    Map<String, bool> status = {};
    for (var product in products) {
      final productId = product['id']?.toString() ?? '';
      if (productId.isNotEmpty) {
        final isFav = await _databaseService.isFavorite(currentUser.uid, productId);
        status[productId] = isFav;
      }
    }

    setState(() {
      _favoriteStatus = status;
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
      final isFavorite = _favoriteStatus[productId] ?? false;

      if (isFavorite) {
        await _databaseService.removeFromFavorites(currentUser.uid, productId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        await _databaseService.addToFavorites(currentUser.uid, productId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }

      setState(() {
        _favoriteStatus[productId] = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _quickAddToCart(Map<String, dynamic> product) async {
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
      final productId = product['id']?.toString() ?? 'product_${DateTime.now().millisecondsSinceEpoch}';
      final cartItemId = '${currentUser.uid}_$productId';

      final cartItem = CartItem(
        id: cartItemId,
        userId: currentUser.uid,
        productId: productId,
        productName: product['name'] ?? 'Unknown Product',
        productImage: product['imagePath'] ?? 'assets/images/placeholder.jpg',
        price: (product['price'] ?? 0.0).toDouble(),
        quantity: product['quantity'] ?? 'N/A',
        itemCount: 1,
        addedAt: DateTime.now(),
      );

      await _databaseService.addToCart(currentUser.uid, cartItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product['name']} added to cart!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = '/home_screen';
        break;
      case 1:
        routeName = '/explore_page';
        break;
      case 2:
        routeName = '/cart_page';
        break;
      case 3:
        routeName = '/favourite_page';
        break;
      case 4:
        routeName = '/account_page';
        break;
      default:
        return;
    }

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/grocery.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) => const Text(
                'GROCERY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text(
                  'rajkot,360020',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UPDATED SEARCH BAR - Now navigates to search page
              GestureDetector(
                onTap: () {
                  // Navigate to search page
                  Navigator.pushNamed(context, '/search_page');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        'Search Store',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Banner Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 1.0,
                ),
                items: bannerImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(i),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Exclusive Offer Section
              _buildSectionTitle(context, 'Exclusive Offer', 'exclusive'),
              const SizedBox(height: 10),
              _buildProductList(context, section: 'exclusive'),
              const SizedBox(height: 20),

              // Best Selling Section
              _buildSectionTitle(context, 'Best Selling', 'best_selling'),
              const SizedBox(height: 10),
              _buildProductList(context, section: 'best_selling'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    String sectionKey,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            debugPrint('Navigating to See All for $title');
            Navigator.pushNamed(
              context,
              '/product_list_page',
              arguments: {'category': title, 'section': sectionKey},
            );
          },
          child: const Text(
            'See all',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(BuildContext context, {required String section}) {
    final filteredProducts = products.where((p) => p['section'] == section).toList();

    return SizedBox(
      height: 245,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: _buildProductCard(context, product),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final productId = product['id']?.toString() ?? '';
    final isFavorite = _favoriteStatus[productId] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product_detail', arguments: product);
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 80,
                      child: Image.asset(
                        product['imagePath'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.shopping_basket,
                          size: 80,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['quantity'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _quickAddToCart(product);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(40, 40),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Favorite Button (Heart Icon)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _toggleFavorite(productId),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}