import 'package:flutter/material.dart';

import '../data/sample_listings.dart';
import '../models/kos_listing.dart';
import '../theme/betah_colors.dart';
import '../widgets/listing_widgets.dart';
import 'screen_callbacks.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
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
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _SurabayaMapPainter()),
              ),
              const Positioned(
                top: 15,
                left: 18,
                right: 18,
                child: _MapSearchBar(),
              ),
              Positioned(
                top: constraints.maxHeight * 0.25,
                left: 19,
                child: const _MapLabel(text: 'SUKOLILO'),
              ),
              Positioned(
                top: constraints.maxHeight * 0.34,
                right: 26,
                child: const _MapLabel(text: 'GUBENG'),
              ),
              Positioned(
                top: constraints.maxHeight * 0.49,
                left: 24,
                child: const _MapLabel(text: 'WONOKROMO'),
              ),
              Positioned(
                top: constraints.maxHeight * 0.19,
                right: 24,
                child: FloatingActionButton.small(
                  heroTag: 'map_location',
                  tooltip: 'Lokasi saya',
                  backgroundColor: BetahColors.paper,
                  foregroundColor: BetahColors.green,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Peta berpusat di Surabaya.')),
                  ),
                  child: const Icon(Icons.my_location_rounded),
                ),
              ),
              ..._buildMarkers(constraints),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _MapResults(
                  favorites: favorites,
                  onToggleFavorite: onToggleFavorite,
                  onOpenListing: onOpenListing,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildMarkers(BoxConstraints constraints) {
    const positions = [
      Offset(0.18, 0.37),
      Offset(0.75, 0.39),
      Offset(0.43, 0.31),
      Offset(0.69, 0.23),
      Offset(0.46, 0.47),
      Offset(0.22, 0.25),
    ];

    return [
      for (var index = 0; index < sampleListings.length; index++)
        Positioned(
          left: constraints.maxWidth * positions[index].dx,
          top: constraints.maxHeight * positions[index].dy,
          child: _PriceMapMarker(
            price: sampleListings[index].priceLabel,
            selected: index == 0,
            onTap: () => onOpenListing(sampleListings[index]),
          ),
        ),
    ];
  }
}

class _MapSearchBar extends StatelessWidget {
  const _MapSearchBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BetahColors.paper,
      borderRadius: BorderRadius.circular(15),
      elevation: 3,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: BetahColors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cari kos di sekitar sini',
                style: TextStyle(fontSize: 13),
              ),
            ),
            Icon(Icons.tune_rounded, size: 20, color: BetahColors.muted),
          ],
        ),
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF917F5D),
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _PriceMapMarker extends StatelessWidget {
  const _PriceMapMarker({
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? BetahColors.green : BetahColors.paper,
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Text(
            price,
            style: TextStyle(
              color: selected ? Colors.white : BetahColors.greenDeep,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _MapResults extends StatelessWidget {
  const _MapResults({
    required this.favorites,
    required this.onToggleFavorite,
    required this.onOpenListing,
  });

  final Set<String> favorites;
  final FavoriteToggle onToggleFavorite;
  final ListingOpen onOpenListing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      decoration: const BoxDecoration(
        color: BetahColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 13, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: BetahColors.line,
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kos di Surabaya',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              Text(
                '${sampleListings.length} ditemukan',
                style: const TextStyle(color: BetahColors.muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sampleListings.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final listing = sampleListings[index];
                return _MapListingCard(
                  listing: listing,
                  isFavorite: favorites.contains(listing.id),
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

class _MapListingCard extends StatelessWidget {
  const _MapListingCard({
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
      width: 210,
      child: Material(
        color: BetahColors.paper,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: SizedBox(
                  width: 78,
                  height: 82,
                  child: PlacePhoto(listing: listing),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.priceLabel,
                      style: const TextStyle(
                        color: BetahColors.orange,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                    IconButton(
                      onPressed: onToggleFavorite,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 28,
                        height: 28,
                      ),
                      tooltip: isFavorite
                          ? 'Hapus dari favorit'
                          : 'Simpan ke favorit',
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16,
                        color: isFavorite
                            ? BetahColors.orange
                            : BetahColors.muted,
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

class _SurabayaMapPainter extends CustomPainter {
  const _SurabayaMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF0E2C5),
    );
    final parkPaint = Paint()..color = const Color(0xFFC8DDC6);
    final park = Path()
      ..moveTo(size.width * 0.57, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.73,
        size.height * 0.12,
        size.width * 0.98,
        size.height * 0.25,
      )
      ..lineTo(size.width * 0.88, size.height * 0.43)
      ..quadraticBezierTo(
        size.width * 0.69,
        size.height * 0.48,
        size.width * 0.57,
        size.height * 0.2,
      )
      ..close();
    canvas.drawPath(park, parkPaint);

    final road = Paint()
      ..color = const Color(0xFFD8C28F)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final roadCenter = Paint()
      ..color = const Color(0xFFFFF7E7)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final roads = [
      Path()
        ..moveTo(-15, size.height * 0.16)
        ..cubicTo(
          size.width * 0.33,
          size.height * 0.2,
          size.width * 0.5,
          size.height * 0.12,
          size.width + 20,
          size.height * 0.23,
        ),
      Path()
        ..moveTo(-20, size.height * 0.32)
        ..cubicTo(
          size.width * 0.27,
          size.height * 0.29,
          size.width * 0.54,
          size.height * 0.38,
          size.width + 18,
          size.height * 0.31,
        ),
      Path()
        ..moveTo(size.width * 0.25, -20)
        ..cubicTo(
          size.width * 0.28,
          size.height * 0.25,
          size.width * 0.18,
          size.height * 0.43,
          size.width * 0.29,
          size.height * 0.69,
        ),
      Path()
        ..moveTo(size.width * 0.81, -15)
        ..cubicTo(
          size.width * 0.75,
          size.height * 0.25,
          size.width * 0.89,
          size.height * 0.44,
          size.width * 0.77,
          size.height * 0.67,
        ),
      Path()
        ..moveTo(-10, size.height * 0.53)
        ..cubicTo(
          size.width * 0.26,
          size.height * 0.46,
          size.width * 0.56,
          size.height * 0.58,
          size.width + 20,
          size.height * 0.48,
        ),
    ];
    for (final path in roads) {
      canvas.drawPath(path, road);
      canvas.drawPath(path, roadCenter);
    }

    final block = Paint()..color = const Color(0xFFE6D7B6);
    for (var row = 0; row < 5; row++) {
      for (var column = 0; column < 4; column++) {
        final left = size.width * (0.05 + column * 0.23);
        final top = size.height * (0.34 + row * 0.062);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, top, size.width * 0.1, size.height * 0.026),
            const Radius.circular(3),
          ),
          block,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
