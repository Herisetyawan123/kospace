import 'package:flutter/material.dart';

import '../models/kos_listing.dart';
import '../theme/betah_colors.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.displayName,
    this.email,
    this.onSignOut,
    this.onUpdateDisplayName,
  });

  final String? displayName;
  final String? email;
  final Future<void> Function()? onSignOut;
  final Future<void> Function(String value)? onUpdateDisplayName;

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
      ProfileScreen(
        displayName: widget.displayName,
        email: widget.email,
        onSignOut: widget.onSignOut,
        onUpdateDisplayName: widget.onUpdateDisplayName,
        onOpenFavorites: () => setState(() => _selectedTab = 2),
      ),
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
