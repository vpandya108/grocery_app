import 'package:flutter/material.dart';
import 'package:grocery_app/screen/about_us.dart';
import 'package:grocery_app/screen/category_products.dart';
import 'package:grocery_app/screen/checkout_page.dart';
import 'package:grocery_app/screen/edit_detail.dart';
import 'package:grocery_app/screen/forgot_password.dart';
import 'package:grocery_app/screen/home_screen.dart';
import 'package:grocery_app/screen/otp_verify.dart';
import 'package:grocery_app/screen/product_detail.dart';
import 'package:grocery_app/screen/splash_screen.dart';
import 'package:grocery_app/screen/welcome_screen.dart';
import 'package:grocery_app/screen/login_page.dart';
import 'package:grocery_app/screen/signup_page.dart';
import 'package:grocery_app/screen/explore_page.dart';
import 'package:grocery_app/screen/category_products.dart';
import 'package:grocery_app/screen/feedback.dart';

// --- NEW IMPORTS REQUIRED FOR THE FIX ---
// Assuming these classes exist in your project structure now.
import 'package:grocery_app/screen/cart_page.dart';
import 'package:grocery_app/screen/favourite_page.dart';
import 'package:grocery_app/screen/account_page.dart';
// ------------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App',
      theme: ThemeData(
        // Using the specific green color for consistency
        primaryColor: const Color(0xFF53B175),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(secondary: const Color(0xFF53B175)),
      ),
      initialRoute: '/',
      routes: {
        // --- Authentication/Splash Routes ---
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) =>
            const ForgotPassword(), // Assuming you renamed ForgotPassword to ForgotPasswordPage
        '/otp_verify': (context) =>
            const OtpVerify(), // Assuming you renamed OtpVerify to OtpVerifyPage
        // --- Main Bottom Navigation Tabs (CORRECTED & STANDARDIZED) ---
        // CORRECTED: Changed from '/homescreen' to '/home_screen' for consistency
        '/home_screen': (context) => const HomeScreen(),

        // Explore route standardized to match AccountPage logic
        '/explore_page': (context) => const ExplorePage(),
        '/category_products': (context) => CategoryProducts(
          categoryName: 'fruits & vegetables',
        ), // Assuming you want to navigate to ExplorePage for categories
        // ADDED: The missing routes for the Bottom Nav Bar
        '/cart_page': (context) => const CartPage(),
        '/favourite_page': (context) =>
            const FavoritePage(), // Assuming class name is FavouritePage
        '/account_page': (context) => const AccountPage(),

        // --- Utility/Detail Routes ---
        '/product_detail': (context) => const ProductDetail(),

        // --- Other Routes ---
        '/about_us': (context) => const AboutUs(),
        '/edit_detail': (context) => const EditDetail(),
        '/checkout': (context) => const CheckoutPage(),
        '/feedback': (context) =>
            const FeedbackPage(), // Placeholder for feedback page
        // Optional placeholder routes that might be needed:
        // '/reset_password': (context) => const ResetPasswordPage(),
        // '/orders_page': (context) => const OrdersPage(),
      },
    );
  }
}
