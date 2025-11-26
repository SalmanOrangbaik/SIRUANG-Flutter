import 'package:flutter/material.dart';
import 'package:siruangflutter/screens/ruangan_screen.dart';
import 'home_screen.dart';
import 'booking_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  String _username = ""; // Menyimpan nama user setelah login

  final List<Widget> _pages = [
    const HomeScreen(),
    const RuangScreen(),
    const BookingScreen(),
  ];

  // Controllers untuk text field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk menampilkan dialog login
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _performLogin();
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk melakukan login
  void _performLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi sederhana
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulasi login berhasil
    setState(() {
      _isLoggedIn = true;
      _username = username; // Simpan username untuk ditampilkan
    });

    _clearForm();
    Navigator.of(context).pop(); // Tutup dialog

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login berhasil! Selamat datang, $username'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi untuk logout
  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _username = "";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout berhasil!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Membersihkan form
  void _clearForm() {
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siruang App'),
        actions: [
          if (!_isLoggedIn)
            // TOMBOL LOGIN - Muncul saat belum login
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: _showLoginDialog,
              tooltip: 'Login',
            ),
          if (_isLoggedIn)
            // MENU PROFIL - Muncul setelah login
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _logout();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 8),
                      Text('Profil: $_username'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 4),
                    Text(
                      _username,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room), label: 'Ruang'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'Booking'),
        ],
      ),
    );
  }
}
