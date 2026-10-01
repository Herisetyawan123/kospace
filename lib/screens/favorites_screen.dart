import 'package:flutter/material.dart';

import '../data/sample_listings.dart';
import '../theme/betah_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/listing_widgets.dart';
import 'screen_callbacks.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onOpenListing,
  });

  final Set<String> favorites;
  final FavoriteToggle onToggleFavorite;
  final ListingOpen onOpenListing;

  @override
  Widget build(BuildContext context) {
    final saved = sampleListings
        .where((listing) => favorites.contains(listing.id))
        .toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 5),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Kos tersimpan',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 18),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${saved.length} tempat yang kamu suka',
                style: const TextStyle(color: BetahColors.muted),
              ),
            ),
          ),
          if (saved.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 42, 22, 30),
              sliver: SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'Belum ada kos tersimpan',
                  subtitle:
                      'Ketuk ikon hati pada kos untuk menyimpannya di sini.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
              sliver: SliverList.separated(
                itemCount: saved.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 11),
                itemBuilder: (context, index) {
                  final listing = saved[index];
                  return ListingTile(
                    listing: listing,
                    isFavorite: true,
                    onToggleFavorite: () => onToggleFavorite(listing),
                    onTap: () => onOpenListing(listing),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
