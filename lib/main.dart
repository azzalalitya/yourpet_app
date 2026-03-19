import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'views/login_page.dart';
import 'views/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'YourPet',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) {
            print('📱 Membangun LoginPage');
            return const LoginPage();
          },
          '/dashboard': (context) {
            print('📱 Membangun DashboardPage');
            return const DashboardPage();
          },
        },
      ),
    );
  }
}
