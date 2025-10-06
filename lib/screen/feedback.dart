import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  // Define the consistent green color from your app's theme
  final Color primaryGreen = const Color(0xFF53B175);
  final Color darkGreen = const Color(0xFF4C9868); // A slightly darker shade for contrast

  @override
  Widget build(BuildContext context) {
    // Determine current index for BottomNavigationBar (assuming Account is index 4)
    const int currentIndex = 4; 

    return Scaffold(
      appBar: AppBar(
        // Green background for the AppBar
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // White card container for the feedback form
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "We'd Love to Hear\nFrom You!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle/Description
                  const Text(
                    "Share your thoughts, suggestions, or report issue.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Rating Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      // Example: show 4 out of 5 stars filled
                      final isFilled = index < 4; 
                      return Icon(
                        isFilled ? Icons.star : Icons.star_border,
                        color: isFilled ? darkGreen : Colors.grey,
                        size: 38,
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  
                  // Overall Experience Text
                  const Center(
                    child: Text(
                      "Overall experience",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 1. Feedback Text Field
                  _buildTextField(
                    hintText: 'Tell us what you think',
                    maxLines: 5, // Allow multiple lines for feedback
                  ),
                  const SizedBox(height: 15),

                  // 2. Email Text Field (Optional)
                  _buildTextField(
                    hintText: 'Your email (optional)...',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Placeholder logic for submitting feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Feedback Submitted! Thank you.")),
                        );
                        // Typically, you would pop the page after submission
                        // Navigator.pop(context); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Submit Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar (reused from your previous files)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen, 
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
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
            icon: Icon(Icons.person), // Filled icon for the current tab
            label: 'Account',
          ),
        ],
        onTap: (index) {
          // Add navigation logic here if needed
        },
      ),
    );
  }

  // Helper function to build the consistent text field design
  Widget _buildTextField({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: darkGreen, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        filled: true,
        fillColor: Colors.grey[50], // Very light background for the text field
      ),
    );
  }
}