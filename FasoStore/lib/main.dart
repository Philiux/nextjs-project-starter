import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'screens/common/splash_screen.dart';
import 'screens/common/onboarding_screens.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/phone_auth_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/buyer/home_screen.dart';
import 'screens/buyer/product_list_screen.dart';
import 'screens/buyer/product_detail_screen.dart';
import 'screens/buyer/cart_screen.dart';
import 'screens/buyer/order_history_screen.dart';
import 'screens/buyer/profile_screen.dart';
import 'screens/seller/dashboard_screen.dart';
import 'screens/seller/product_management_screen.dart';
import 'screens/seller/order_management_screen.dart';
import 'screens/seller/image_processing_tools.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/product_management_screen.dart';
import 'screens/admin/order_management_screen.dart';
import 'screens/common/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter E-commerce',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreens(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/phone_auth': (context) => const PhoneAuthScreen(),
          '/forgot_password': (context) => const ForgotPasswordScreen(),
          '/buyer_home': (context) => const HomeScreen(),
          '/product_list': (context) => const ProductListScreen(),
          '/product_detail': (context) => const ProductDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/order_history': (context) => const OrderHistoryScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/seller_dashboard': (context) => const SellerDashboardScreen(),
          '/seller_product_management': (context) => const ProductManagementScreen(),
          '/seller_order_management': (context) => const OrderManagementScreen(),
          '/seller_image_tools': (context) => const ImageProcessingTools(),
          '/admin_dashboard': (context) => const AdminDashboardScreen(),
          '/admin_user_management': (context) => const UserManagementScreen(),
          '/admin_product_management': (context) => const AdminProductManagementScreen(),
          '/admin_order_management': (context) => const AdminOrderManagementScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
