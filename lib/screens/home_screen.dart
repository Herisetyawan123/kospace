import 'package:flutter/material.dart';

import '../data/sample_listings.dart';
import '../models/kos_listing.dart';
import '../theme/betah_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/listing_widgets.dart';
import 'screen_callbacks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onOpenListing,
    required this.onExploreMap,
  });

  final Set<String> favorites;
  final FavoriteToggle onToggleFavorite;
  final ListingOpen onOpenListing;
  final VoidCallback onExploreMap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'Semua';
  String _query = '';

  List<KosListing> get _filteredListings => sampleListings.where((listing) {
    final matchesCategory = _category == 'Semua' || listing.type == _category;
    final searchable = '${listing.name} ${listing.area} ${listing.address}'
        .toLowerCase();
    return matchesCategory && searchable.contains(_query.toLowerCase());
  }).toList();

  @override
  Widget build(BuildContext context) {
    final listings = _filteredListings;
    final featured = listings.take(4).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const BetahMark(size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELAMAT DATANG',
                          style: TextStyle(
                            color: BetahColors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Damar, cari kos di mana?',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Notifikasi',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belum ada notifikasi baru.'),
                      ),
                    ),
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Temukan tempat\npulang di Surabaya.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                onChanged: (value) => setState(() => _query = value.trim()),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Cari area, nama kos, atau kampus',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    tooltip: 'Lihat peta',
                    onPressed: widget.onExploreMap,
                    icon: const Icon(Icons.tune_rounded),
                  ),
                  filled: true,
                  fillColor: BetahColors.paper,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: BetahColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: BetahColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: BetahColors.green),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 56,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                scrollDirection: Axis.horizontal,
                children: [
                  for (final category in ['Semua', 'Putra', 'Putri', 'Campur'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                        selectedColor: BetahColors.green,
                        backgroundColor: BetahColors.paper,
                        side: BorderSide(
                          color: _category == category
                              ? BetahColors.green
                              : BetahColors.line,
                        ),
                        labelStyle: TextStyle(
                          color: _category == category
                              ? BetahColors.paper
                              : BetahColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        showCheckmark: false,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeading(
                title: 'Pilihan minggu ini',
                actionLabel: 'Lihat peta',
                onAction: widget.onExploreMap,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 236,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 8),
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final listing = featured[index];
                  return _FeaturedListingCard(
                    listing: listing,
                    isFavorite: widget.favorites.contains(listing.id),
                    onToggleFavorite: () => widget.onToggleFavorite(listing),
                    onTap: () => widget.onOpenListing(listing),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeading(
                title: 'Kos dekat kamu',
                actionLabel: '${listings.length} ditemukan',
              ),
            ),
          ),
          if (listings.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 20, 22, 24),
              sliver: SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Belum ada kos yang cocok',
                  subtitle: 'Coba kata kunci atau kategori lain.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
              sliver: SliverList.separated(
                itemCount: listings.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return ListingTile(
                    listing: listing,
                    isFavorite: widget.favorites.contains(listing.id),
                    onToggleFavorite: () => widget.onToggleFavorite(listing),
                    onTap: () => widget.onOpenListing(listing),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _FeaturedListingCard extends StatelessWidget {
  const _FeaturedListingCard({
    required this.listing,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  final KosListing listing;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 268,
      child: Material(
        color: BetahColors.paper,
        borderRadius: BorderRadius.circular(17),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PlacePhoto(listing: listing),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: BetahColors.paper,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            'KOS ${listing.type.toUpperCase()}',
                            style: const TextStyle(
                              color: BetahColors.green,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton.filled(
                        tooltip: isFavorite
                            ? 'Hapus dari favorit'
                            : 'Simpan ke favorit',
                        onPressed: onToggleFavorite,
                        style: IconButton.styleFrom(
                          backgroundColor: BetahColors.paper,
                          foregroundColor: isFavorite
                              ? BetahColors.orange
                              : BetahColors.ink,
                        ),
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 19,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${listing.area} · Surabaya',
                            style: const TextStyle(
                              color: BetahColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      listing.priceLabel,
                      style: const TextStyle(
                        color: BetahColors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
