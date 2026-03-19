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
        backgroundColor: Colors.blue,
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
            const Icon(Icons.pets, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Selamat datang,',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Text(
              user != null ? user['name'].toString() : 'User', // HAPUS '!' NYA
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user != null
                  ? 'Email: ${user['email']}'
                  : 'Email: -', // HAPUS '!' NYA
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            const Text(
              '✨ Fitur akan segera hadir! ✨',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
