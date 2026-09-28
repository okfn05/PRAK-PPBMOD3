// import 'package:flutter/material.dart';
// import '../screens/home.dart';
// import '../screens/profile.dart';

// class NavigationPage extends StatefulWidget {
//   const NavigationPage({super.key});

//   @override
//   State<NavigationPage> createState() => _NavigationPageState();
// }

// class _NavigationPageState extends State<NavigationPage> {
//   int _currentIndex = 0;

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       const HomePage(),
//       ProfilePage(onHomeTap: () => _onTabTapped(0)),
//     ];

//     return Scaffold(
//       body: pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/favorite.dart';
import '../screens/history.dart';
import '../screens/profile.dart';
import '../screens/detail.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  final List<Country> _favoriteCountries = [];
  final List<Country> _historyCountries = [];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // =========================
  // FAVORIT
  // =========================

  void _toggleFavorite(Country country) {
    setState(() {
      if (_favoriteCountries.contains(country)) {
        _favoriteCountries.remove(country);
      } else {
        _favoriteCountries.add(country);
      }
    });
  }

  bool _isFavorite(Country country) {
    return _favoriteCountries.contains(country);
  }

  // =========================
  // RIWAYAT
  // =========================

  void _addToHistory(Country country) {
    setState(() {
      // Jika sudah ada, hapus terlebih dahulu
      // agar negara yang baru dibuka berada di paling atas.
      _historyCountries.remove(country);

      // Tambahkan sebagai riwayat terbaru.
      _historyCountries.insert(0, country);
    });
  }

  // Hard delete satu riwayat
  void _deleteHistory(Country country) {
    setState(() {
      _historyCountries.remove(country);
    });
  }

  // Hard delete seluruh riwayat
  void _clearHistory() {
    setState(() {
      _historyCountries.clear();
    });
  }

  // Membuka detail dari menu lain
  void _openDetail(Country country) {
    _addToHistory(country);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          country: country,
          isFavorite: _isFavorite(country),
          onFavoriteToggle: () => _toggleFavorite(country),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        favoriteCountries: _favoriteCountries,
        onFavoriteToggle: _toggleFavorite,
        isFavorite: _isFavorite,
        onCountryTap: _openDetail,
      ),

      FavoritePage(
        favoriteCountries: _favoriteCountries,
        onFavoriteToggle: _toggleFavorite,
        isFavorite: _isFavorite,
        onCountryTap: _openDetail,
      ),

      HistoryPage(
        historyCountries: _historyCountries,
        onDelete: _deleteHistory,
        onClear: _clearHistory,
        onCountryTap: _openDetail,
      ),

      ProfilePage(
        onHomeTap: () => _onTabTapped(0),
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}