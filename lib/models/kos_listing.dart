import 'package:flutter/material.dart';

class KosListing {
  const KosListing({
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.price,
    required this.priceLabel,
    required this.rating,
    required this.reviewCount,
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.amenities,
    required this.accent,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String area;
  final String address;
  final int price;
  final String priceLabel;
  final double rating;
  final int reviewCount;
  final String type;
  final String imageUrl;
  final String description;
  final List<String> amenities;
  final Color accent;
  final double latitude;
  final double longitude;
}
