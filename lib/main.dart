import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'screens/checkout_screen.dart';
import 'screens/kasir/kasir_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/admin&kasir/LoginScreen.dart';
import 'screens/admin/RegisterScreen.dart';
import 'screens/kasir/payment_screen.dart';
import 'screens/kasir/order_detail_screen.dart';
import 'screens/kasir/tambah_pengeluaran_screen.dart';
import 'screens/laporan_pengeluaran_screen.dart';
import 'screens/ai_insight_screen.dart';
import 'screens/stok_management_screen.dart';
import 'screens/master_data_screen.dart';

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
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/kasir': (context) => const KasirScreen(),
        '/admin': (context) => const AdminScreen(),
        '/order': (context) => OrderDetailScreen(),
        '/payment': (context) => PaymentScreen(),
        '/pengeluaran': (context) => const PengeluaranScreen(),
        '/laporan': (context) => const LaporanScreen(),
        '/ai-insight': (context) => const AiInsightScreen(),
        '/stok-management': (context) => const StokManagementScreen(),
        '/master-data': (context) => const MasterDataScreen(),
        // '/checkout': (context) => CheckoutScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    if (token != null && role != null) {
      if (role == 'kasir') {
        return const KasirScreen();
      } else {
        return const AdminScreen();
      }
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Error loading app')));
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
