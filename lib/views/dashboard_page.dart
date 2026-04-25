import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔵 Dashboard page terbuka!');
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    print('===== DASHBOARD =====');
    print('User: $user');
    print('=====================');

    return Scaffold(
      appBar: AppBar(
        title: const Text('YourPet - Dashboard'),
        backgroundColor: const Color(0xFF4ECDC4), // Warna toska sesuai UI mockup
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        authProvider.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo icon
            const Icon(
              Icons.pets,
              size: 100,
              color: Color(0xFF4ECDC4),
            ),
            const SizedBox(height: 20),
            
            // Sapaan
            Text(
              'Selamat datang,',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Text(
              user != null ? user['name'].toString() : 'User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5F5D),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user != null ? 'Email: ${user['email']}' : 'Email: -',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),

            // ⬇️ TOMBOL BARU: KONSULTASI DOKTER
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/doctors');
              },
              icon: const Icon(Icons.local_hospital),
              label: const Text(
                'Konsultasi Dokter',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECDC4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 16),

            // Tombol kedua (placeholder untuk fitur lain)
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Marketplace: coming soon!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text(
                'Marketplace',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4ECDC4),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF4ECDC4)),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              '✨ Fitur lain akan segera hadir! ✨',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}