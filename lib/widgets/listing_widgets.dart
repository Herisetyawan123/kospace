import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/betah_colors.dart';
import '../models/kos_listing.dart';

class BetahMark extends StatelessWidget {
  const BetahMark({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/brand/betah_mark.svg',
      width: size,
      height: size,
    );
  }
}

class PlacePhoto extends StatelessWidget {
  const PlacePhoto({super.key, required this.listing, this.fit = BoxFit.cover});

  final KosListing listing;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      listing.imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          _PhotoFallback(accent: listing.accent),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _PhotoFallback(accent: listing.accent);
      },
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.72), accent],
        ),
      ),
      child: const Center(
        child: Icon(Icons.home_work_outlined, size: 42, color: Colors.white),
      ),
    );
  }
}

class ListingTile extends StatelessWidget {
  const ListingTile({
    super.key,
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
    return Material(
      color: BetahColors.paper,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BetahColors.line),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 104,
                  child: PlacePhoto(listing: listing),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listing.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints.tightFor(
                            width: 34,
                            height: 34,
                          ),
                          tooltip: isFavorite
                              ? 'Hapus dari favorit'
                              : 'Simpan ke favorit',
                          onPressed: onToggleFavorite,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite
                                ? BetahColors.orange
                                : BetahColors.muted,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: BetahColors.muted,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${listing.area}, Surabaya',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: BetahColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: BetahColors.gold,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${listing.rating} (${listing.reviewCount})',
                          style: const TextStyle(fontSize: 11),
                        ),
                        const Spacer(),
                        Text(
                          listing.priceLabel,
                          style: const TextStyle(
                            color: BetahColors.orange,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          '/bln',
                          style: TextStyle(
                            color: BetahColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
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

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: BetahColors.orange),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
