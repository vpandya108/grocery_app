import 'package:flutter/material.dart';

class EditDetail extends StatelessWidget {
  const EditDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the primary color from the logo (a shade of green)
    const Color primaryGreen = Color(0xFF53B175);

    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      // The AppBar is simple with a back arrow
      appBar: AppBar(
        // The back arrow on your image looks like a custom icon or a simple forward arrow turned left
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Logo Image ---
            Image.asset(
              'assets/images/groceryimg.png', // **Make sure this path is correct**
              height: 100, // Adjust height as needed
            ),
            const SizedBox(height: 30),

            // --- Title ---
            const Text(
              'Edit personal details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),

            // --- Form Fields ---
            // Username Field
            _buildTextField(
              label: 'Username',
              initialValue: 'Grocery', // Example data
            ),
            const SizedBox(height: 20),

            // Email Field
            _buildTextField(
              label: 'Email I\'d',
              initialValue: 'grocery@gmail.com', // Example data
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Phone Number Field
            _buildTextField(
              label: 'Phone Number',
              initialValue: '+91 98765 43210', // Example data
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Password Field
            _buildTextField(
              label: 'Password',
              initialValue: '********',
              obscureText: true,
            ),
            const SizedBox(height: 50),

            // --- Update Button ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add your update logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Details Updated!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget for a cleaner form
  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 15,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.grey, // Border color
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF53B175), // Green border when focused
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
