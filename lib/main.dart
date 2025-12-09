import 'package:flutter/material.dart';
// import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/payment_screen.dart';
import 'screens/order_detail_screen.dart';

// ✅ TAMBAHKAN INI
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ✅ PASANG DI SINI
      navigatorKey: navigatorKey,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/order':(context) => OrderDetailScreen(),
        '/payment':(context)=> PaymentScreen()
        // '/checkout': (context) => CheckoutScreen(),
      },
    );
  }
}
