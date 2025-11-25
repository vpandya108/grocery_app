import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ADD THIS LINE
import 'package:grocery_app/screen/splash_screen.dart';
import 'package:grocery_app/screen/welcome_screen.dart';
import 'package:grocery_app/screen/login_page.dart';
import 'package:grocery_app/screen/signup_page.dart';
import 'package:grocery_app/screen/forgot_password.dart';
import 'package:grocery_app/screen/otp_verify.dart';
import 'package:grocery_app/screen/home_screen.dart';
import 'package:grocery_app/screen/explore_page.dart';
import 'package:grocery_app/screen/cart_page.dart';
import 'package:grocery_app/screen/favourite_page.dart';
import 'package:grocery_app/screen/account_page.dart';
import 'package:grocery_app/screen/product_detail.dart';
import 'package:grocery_app/screen/category_products.dart';
import 'package:grocery_app/screen/checkout_page.dart';
import 'package:grocery_app/screen/order_success.dart';
import 'package:grocery_app/screen/edit_detail.dart';
import 'package:grocery_app/screen/about_us.dart';
import 'package:grocery_app/screen/feedback.dart';
import 'package:grocery_app/screen/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // UPDATE THIS LINE - Add options parameter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/otp_verify': (context) => const OtpVerify(),
        '/home_screen': (context) => const HomeScreen(),
        '/explore_page': (context) => const ExplorePage(),
        '/cart_page': (context) => const CartPage(),
        '/favourite_page': (context) => const FavoritePage(),
        '/account_page': (context) => const AccountPage(),
        '/product_detail': (context) => const ProductDetail(),
        '/checkout': (context) => const CheckoutPage(),
        '/order_success': (context) => const OrderSuccessPage(),
        '/edit_detail': (context) => const EditDetail(),
        '/about_us': (context) => const AboutUs(),
        '/feedback': (context) => const FeedbackPage(),
        '/search_page': (context) => const SearchPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/category_products') {
          final String categoryName = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CategoryProducts(categoryName: categoryName),
          );
        }
        return null;
      },
    );
  }
}