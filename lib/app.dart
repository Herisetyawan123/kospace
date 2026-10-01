import 'package:flutter/material.dart';

import 'models/kos_listing.dart';
import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/betah_colors.dart';

class BetahApp extends StatelessWidget {
  const BetahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Betah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: BetahColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BetahColors.green,
          primary: BetahColors.green,
          secondary: BetahColors.orange,
          surface: BetahColors.paper,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: BetahColors.ink,
            fontFamily: 'Georgia',
            fontSize: 27,
            height: 1.12,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: BetahColors.ink,
            fontFamily: 'Georgia',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: BetahColors.ink, fontSize: 14),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedTab = 0;
  final Set<String> _favorites = {'mawar-rungkut', 'sukun-darmo'};

  void _toggleFavorite(KosListing listing) {
    setState(() {
      if (!_favorites.add(listing.id)) {
        _favorites.remove(listing.id);
      }
    });
  }

  void _openListing(KosListing listing) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DetailScreen(
          listing: listing,
          isFavorite: _favorites.contains(listing.id),
          onToggleFavorite: () => _toggleFavorite(listing),
          onOpenMap: () {
            Navigator.of(context).pop();
            setState(() => _selectedTab = 1);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        onOpenListing: _openListing,
        onExploreMap: () => setState(() => _selectedTab = 1),
      ),
      MapScreen(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        onOpenListing: _openListing,
      ),
      FavoritesScreen(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        onOpenListing: _openListing,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedTab, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        backgroundColor: BetahColors.paper,
        indicatorColor: const Color(0xFFFFD98B),
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Peta',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
