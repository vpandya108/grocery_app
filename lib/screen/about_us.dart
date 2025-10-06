import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // Back button color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: [
            // Top Image Section
            Container(
              height: 250, // Adjust height as needed
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // *** CHANGED TO AssetImage ***
                  image: AssetImage(
                    'assets/images/grocery_back.jpg',
                  ), // Path to your downloaded background image asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing below the image

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align logo and text at the top
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/groceryimg.png', // Path to your logo asset
                    height: 80, // Adjust logo size as needed
                  ),
                  const SizedBox(width: 20),

                  // Mission Text
                  Expanded(
                    // Ensures the text takes up remaining space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Our Mission:',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Freshress, Community, Convenince.', // Typo from image retained
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'our mission is simple: bringing the freshest produce and essential groceries directly to your door. We partner with local suppliers to ensure quality, making healthy choices easy, affordable, and convenient for your whole family.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
