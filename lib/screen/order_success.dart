import 'package:flutter/material.dart';
import 'package:grocery_app/screen/home_screen.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({Key? key}) : super(key: key);

  // Defining the primary green color used in the design
  static const Color primaryGreen = Color(0xFF53B175);

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen for centering the content
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // The background color is white by default, matching the design
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer to push content to the center (or slightly higher)
              SizedBox(height: size.height * 0.15),

              // --- Success Icon (Green checkmark badge) ---
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: primaryGreen, // Outer green ring/shape
                  shape: BoxShape.circle,
                  // Using a slight shadow to enhance the 3D badge look from the image
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8DCF9C), // Lighter inner green circle
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 70),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // --- Title Text ---
              const Text(
                'Your Order has been accepted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              // --- Subtitle Text (corrected) ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Your items have been placed and are on their way to being processed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(), // Pushes the button to the bottom
              // --- Back to Home Button ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to HomePage and remove all previous routes (clears the cart/checkout flow)
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back to home',
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
      ),
    );
  }
}
