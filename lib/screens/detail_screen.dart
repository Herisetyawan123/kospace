import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';
import '../models/kos_listing.dart';
import '../widgets/listing_widgets.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.listing,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onOpenMap,
  });

  final KosListing listing;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenMap;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isFavorite = widget.isFavorite;

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              height: 285,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PlacePhoto(listing: listing),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.36),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.18),
                        ],
                        stops: const [0, 0.45, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 8,
                    left: 15,
                    child: _HeroButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Kembali',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 8,
                    right: 15,
                    child: _HeroButton(
                      icon: _isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      tooltip: _isFavorite
                          ? 'Hapus dari favorit'
                          : 'Simpan ke favorit',
                      onPressed: _toggleFavorite,
                      iconColor: _isFavorite ? BetahColors.orange : null,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 17,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: BetahColors.paper,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: BetahColors.green,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Diverifikasi Betah',
                              style: TextStyle(
                                color: BetahColors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            listing.name,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 23),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.star_rounded,
                          color: BetahColors.gold,
                          size: 20,
                        ),
                        Text(
                          listing.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: BetahColors.muted,
                          size: 17,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            listing.address,
                            style: const TextStyle(
                              color: BetahColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${listing.reviewCount} ulasan · Kos ${listing.type}',
                      style: const TextStyle(
                        color: BetahColors.muted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _DetailSectionTitle('Fasilitas kamar'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final amenity in listing.amenities)
                          _AmenityPill(label: amenity),
                      ],
                    ),
                    const SizedBox(height: 23),
                    const _DetailSectionTitle('Tentang kos ini'),
                    const SizedBox(height: 9),
                    Text(
                      listing.description,
                      style: const TextStyle(
                        color: BetahColors.muted,
                        height: 1.55,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _DetailSectionTitle('Lokasi'),
                    const SizedBox(height: 8),
                    Text(
                      '${listing.area}, Surabaya',
                      style: const TextStyle(
                        color: BetahColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Container(
                      height: 118,
                      decoration: BoxDecoration(
                        color: BetahColors.greenPale,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_on_rounded,
                          color: BetahColors.orange,
                          size: 34,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: const BoxDecoration(
                color: BetahColors.paper,
                border: Border(top: BorderSide(color: BetahColors.line)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            listing.priceLabel,
                            style: const TextStyle(
                              color: BetahColors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'per bulan',
                            style: TextStyle(
                              color: BetahColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: widget.onOpenMap,
                      style: FilledButton.styleFrom(
                        backgroundColor: BetahColors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Lihat lokasi'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(backgroundColor: BetahColors.paper),
      color: iconColor ?? BetahColors.ink,
      icon: Icon(icon),
    );
  }
}

class _DetailSectionTitle extends StatelessWidget {
  const _DetailSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
    );
  }
}

class _AmenityPill extends StatelessWidget {
  const _AmenityPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: BetahColors.paper,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: BetahColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_amenityIcon(label), color: BetahColors.green, size: 16),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  IconData _amenityIcon(String label) {
    if (label.contains('Wi-Fi')) return Icons.wifi_rounded;
    if (label.contains('AC')) return Icons.ac_unit_rounded;
    if (label.contains('Kasur')) return Icons.bed_outlined;
    if (label.contains('mandi')) return Icons.shower_outlined;
    if (label.contains('Dapur')) return Icons.soup_kitchen_outlined;
    if (label.contains('Parkir')) return Icons.two_wheeler_rounded;
    if (label.contains('Meja')) return Icons.desk_outlined;
    if (label.contains('CCTV')) return Icons.videocam_outlined;
    return Icons.local_laundry_service_outlined;
  }
}
