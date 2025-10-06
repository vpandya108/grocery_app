import 'package:flutter/material.dart';
//import 'package:grocery_app/screen/favourite_page.dart';
// ---------------------------------------------------------------------
//import 'package:grocery_app/screen/checkout_page.dart';
// ---------------------------------------------------------------------

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  // Define the consistent green color
  final Color primaryGreen = const Color(0xFF53B175); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'cart',
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCartItem(
                name: 'Bell Pepper Red',
                quantity: '1kg, Price',
                price: 4.99,
                imagePath: 'assets/images/bell_paper.jpeg',
              ),
              const Divider(),
              _buildCartItem(
                name: 'Organic Bananas',
                quantity: '12kg, Price',
                price: 3.00,
                imagePath: 'assets/images/banana.jpg',
              ),
              const Divider(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primaryGreen, // Use consistent green
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      // Note: This total is hardcoded, it should be calculated dynamically
                      '\$12.96', 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Using the named route for Checkout from main.dart
                    Navigator.pushNamed(context, '/checkout'); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen, // Use consistent green
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Go to Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen, // Use consistent green
        unselectedItemColor: Colors.black,
        currentIndex: 2, // Cart is index 2
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            // Use filled icon to indicate current page
            icon: Icon(Icons.shopping_cart), 
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
        // CORRECTED NAVIGATION LOGIC: Handles all five tabs using named routes
        onTap: (index) {
          if (index == 0) {
            // Shop tab
            Navigator.pushReplacementNamed(context, '/home_screen');
          } else if (index == 1) {
            // Explore tab
            Navigator.pushReplacementNamed(context, '/explore_page');
          } else if (index == 3) {
            // Favourite tab
            Navigator.pushReplacementNamed(context, '/favourite_page');
          } else if (index == 4) {
            // Account tab
            Navigator.pushReplacementNamed(context, '/account_page');
          }
          // index 2 (Cart) is the current page, so we do nothing.
        },
      ),
    );
  }

  Widget _buildCartItem({
    required String name,
    required String quantity,
    required double price,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.contain),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(quantity, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('1', style: TextStyle(fontSize: 18)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              const Icon(Icons.close, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



