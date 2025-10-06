import 'package:flutter/material.dart';
import 'package:grocery_app/screen/order_success.dart';

// ---------------------------------------------------------------------
// *** IMPORTANT: Replace this with the actual path to your OrderSuccessPage file ***
// ---------------------------------------------------------------------

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  // Defining the primary green color used in the design
  static const Color primaryGreen = Color(0xFF53B175);
  static const Color lightGreenBackground = Color(
    0xFFE5F1E9,
  ); // A lighter green for the image background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
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
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Ensure alignment for full-width elements
            children: [
              // --- Shopping Basket Image Section ---
              Container(
                width: double.infinity, // Takes full width
                height: 200, // Adjust height as needed
                decoration: BoxDecoration(
                  color:
                      lightGreenBackground, // Light green background for the image
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Center(
                  child: Image.asset(
                    // NOTE: Double-check this path in your project
                    'assets/images/grocery_checkout.jpeg',
                    fit: BoxFit.contain, // Adjust how the image fits
                    height:
                        180, // Slightly smaller than container to show background
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Delivery Section ---
              _buildCheckoutOptionRow(
                title: 'Delivery',
                value: 'Select Method',
                icon: Icons.flag, // Using a generic flag icon for demonstration
                iconColor: Colors.blue, // Example color for the flag icon
                onTap: () {
                  // TODO: Navigate to Delivery options page
                  debugPrint('Delivery tapped');
                },
              ),
              const Divider(),
              const SizedBox(height: 10),

              // --- Payment Section ---
              _buildCheckoutOptionRow(
                title: 'Payment',
                value:
                    ' ', // No explicit text value shown, maybe empty or default for card type
                icon: Icons
                    .credit_card_outlined, // Placeholder icon, image has no specific payment icon
                onTap: () {
                  // TODO: Navigate to Payment options page
                  debugPrint('Payment tapped');
                },
              ),
              const Divider(),
              const SizedBox(height: 10),

              // --- Total Cost Section ---
              _buildCheckoutOptionRow(
                title: 'Total Cost',
                value: '\$13.97',
                showArrow:
                    true, // Show arrow for navigation if it implies a summary page
                onTap: () {
                  // TODO: Maybe navigate to an order summary or breakdown page
                  debugPrint('Total Cost tapped');
                },
              ),
              const Divider(),
              const SizedBox(height: 20),

              // --- Terms and Conditions ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(text: 'By placing an order you agree to our '),
                      TextSpan(
                        text: 'Terms ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Darker for emphasis
                        ),
                      ),
                      TextSpan(text: 'And '),
                      TextSpan(
                        text: 'Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Darker for emphasis
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100), // Adds space above the fixed button
            ],
          ),
        ),
      ),

      // --- Place Order Button (Fixed at bottom) ---
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom:
              MediaQuery.of(context).padding.bottom +
              10.0, // Safe area + extra padding
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50, // Reduced button height
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the OrderSuccessPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  // *** USES YOUR IMPORTED OrderSuccessPage ***
                  builder: (context) => const OrderSuccessPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(83, 177, 117, 1), // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              elevation: 0,
            ),
            child: const Text(
              'Place Order',
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

  // Helper widget to build the rows for Delivery, Payment, Total Cost
  Widget _buildCheckoutOptionRow({
    required String title,
    required String value,
    IconData? icon,
    Color iconColor = Colors.black,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                if (showArrow) // Only show arrow if explicitly requested or for navigation
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
