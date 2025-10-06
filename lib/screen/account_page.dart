import 'dart:math';

import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage('assets/images/groceryimg.png'),

                    // Placeholder for asset image
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Grocery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.edit, color: Colors.grey[600], size: 18),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'grocery@gmail.com',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Menu Items
              _buildAccountMenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Details',
                onTap: () {
                  Navigator.pushNamed(context, '/edit_detail');
                },
              ),

              _buildAccountMenuItem(
                icon: Icons.info_outline,
                title: 'About us',
                onTap: () {
                  // Navigate to the '/about_us' route
                  Navigator.pushNamed(context, '/about_us');
                },
              ),
              _buildAccountMenuItem(
                icon: Icons.feedback,
                title: 'feedback',
                onTap: () {
                  // Navigate to the '/feedback' route
                  Navigator.pushNamed(context, '/feedback');
                },
              ),
              const SizedBox(height: 40),

              // Log Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // LOGOUT NAVIGATION: Use named route to navigate to /login
                    // and remove all previous routes from the stack.
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                    // Add your session cleanup logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFF53B175),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF53B175), // Use the same green color
        unselectedItemColor: Colors.black,
        currentIndex: 4, // Set to account page index
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
            icon: Icon(Icons.favorite_outline),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          // Navigate to the respective named routes, replacing the current screen
          if (index == 0) {
            // Shop tab
            Navigator.pushReplacementNamed(context, '/home_screen');
          } else if (index == 1) {
            // Explore tab
            Navigator.pushReplacementNamed(context, '/explore_page');
          } else if (index == 2) {
            // Cart tab - **ADDED/CORRECTED LOGIC**
            Navigator.pushReplacementNamed(context, '/cart_page');
          } else if (index == 3) {
            // Favourite tab - **ADDED/CORRECTED LOGIC**
            Navigator.pushReplacementNamed(context, '/favourite_page');
          }
          // index 4 is the current page, so we do nothing.
        },
      ),
    );
  }

  Widget _buildAccountMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black, size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
