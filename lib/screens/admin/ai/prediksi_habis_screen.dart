import 'package:flutter/material.dart';
import '../../../widgets/admin_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrediksiHabisScreen extends StatefulWidget {
  const PrediksiHabisScreen({super.key});

  @override
  State<PrediksiHabisScreen> createState() => _PrediksiHabisScreenState();
}

class _PrediksiHabisScreenState extends State<PrediksiHabisScreen> {
  int selectedDrawerIndex = 19; // Prediksi Habis
  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: AdminDrawer(
        userName: userName,
        userRole: userRole,
        selectedIndex: selectedDrawerIndex,
        onIndexChanged: (index) {
          setState(() {
            selectedDrawerIndex = index;
          });
          Navigator.pop(context);
          // Handle navigation here
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              const Text(
                "Prediksi Habis",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text("Prediksi Habis Screen", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
