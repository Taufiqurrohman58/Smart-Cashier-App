import 'package:flutter/material.dart';
// import 'screens/checkout_screen.dart';
import 'screens/kasir_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/payment_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/tambah_pengeluaran_screen.dart';
import 'screens/lihat_laporan_screen.dart';
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
      initialRoute: '/login',
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
