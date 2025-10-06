import 'package:flutter/material.dart';
// Note: Removed unused import 'package:grocery_app/screen/account_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  // Define the consistent green color
  final Color primaryGreen = const Color(0xFF53B175);

  @override
  Widget build(BuildContext context) {
    // Determine the padding needed for the bottomSheet to not overlap content
    const double bottomSheetHeight = 80.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourite',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Add padding to the bottom of the body equal to the bottomSheet height
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, bottomSheetHeight),
        child: Column(
          children: [
            // NOTE: For a real app, this list should be dynamic (e.g., ListView.builder) 
            // and managed by state (StatefulWidget, Provider, BLoC, etc.)
            _buildFavoriteItem(
              context, // Pass context to use in the GestureDetector
              name: 'Pepsi Can',
              quantity: '330ml, Price',
              price: 4.99,
              imagePath: 'assets/images/pepsi.jpg',
            ),
            const Divider(thickness: 1, color: Colors.grey),
            _buildFavoriteItem(
              context,
              name: 'Coca Cola Can',
              quantity: '325ml, Price',
              price: 4.99,
              imagePath: 'assets/images/coco.jpg',
            ),
            const Divider(thickness: 1, color: Colors.grey),
            _buildFavoriteItem(
              context,
              name: 'Sprite Can',
              quantity: '325ml, Price',
              price: 1.50,
              imagePath: 'assets/images/sprite.jpg',
            ),
            const Divider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen, // Use consistent green color
        unselectedItemColor: Colors.black,
        currentIndex: 3, // Set to favorite page index
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
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            // Use filled icon to indicate current page
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
        // CORRECTED NAVIGATION LOGIC: Use named routes and pushReplacementNamed
        onTap: (index) {
          if (index == 0) {
            // Shop tab
            Navigator.pushReplacementNamed(context, '/home_screen');
          } else if (index == 1) {
            // Explore tab
            Navigator.pushReplacementNamed(context, '/explore_page');
          } else if (index == 2) {
            // Cart tab
            Navigator.pushReplacementNamed(context, '/cart_page');
          } else if (index == 4) {
            // Account tab
            Navigator.pushReplacementNamed(context, '/account_page');
          }
          // index 3 is the current page, so we do nothing.
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Add logic to move all items to cart and navigate to cart page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All items added to cart!")),
              );
              // Navigator.pushNamed(context, '/checkout'); // Example navigation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Add All To Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // UPDATED: Now takes BuildContext and wraps the close icon in a GestureDetector
  Widget _buildFavoriteItem(
    BuildContext context, {
    required String name,
    required String quantity,
    required double price,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 60, width: 60, fit: BoxFit.contain),
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
                Text(
                  quantity,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 10),
          // MAKE CROSS SIGN CLICKABLE
          GestureDetector(
            onTap: () {
              // In a real application, you would:
              // 1. Call a function to remove this item (e.g., Pepsi Can) from the list/database.
              // 2. Refresh the UI (requires converting to a StatefulWidget or using state management).

              // Placeholder action: Show a snackbar confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("$name removed from favourites."),
                    duration: const Duration(seconds: 2)),
              );
            },
            child: const Icon(
              Icons.close,
              size: 24,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}