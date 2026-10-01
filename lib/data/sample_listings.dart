import 'package:flutter/material.dart';

import '../models/kos_listing.dart';

const sampleListings = <KosListing>[
  KosListing(
    id: 'melati-ngagel',
    name: 'Kost Melati Residence',
    area: 'Ngagel',
    address: 'Jl. Ngagel Jaya Selatan No. 18, Wonokromo',
    price: 1250000,
    priceLabel: 'Rp1,25 jt',
    rating: 4.9,
    reviewCount: 32,
    type: 'Putri',
    imageUrl:
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1000&q=85',
    description:
        'Kamar bersih dan terang di lingkungan tenang, dekat pusat kuliner Ngagel dan akses transportasi. Cocok untuk mahasiswi maupun pekerja yang ingin tinggal nyaman di tengah kota.',
    amenities: ['Wi-Fi', 'AC', 'Kasur', 'Kamar mandi dalam'],
    accent: Color(0xFF9EC9B8),
    latitude: -7.2926,
    longitude: 112.7412,
  ),
  KosListing(
    id: 'mawar-rungkut',
    name: 'Kost Mawar Indah',
    area: 'Rungkut',
    address: 'Jl. Medokan Ayu No. 7, Rungkut',
    price: 950000,
    priceLabel: 'Rp950 rb',
    rating: 4.8,
    reviewCount: 24,
    type: 'Putri',
    imageUrl:
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1000&q=85',
    description:
        'Hunian nyaman dengan suasana seperti rumah sendiri. Dekat kawasan industri Rungkut, kampus, dan berbagai pilihan makan sehari-hari.',
    amenities: ['Wi-Fi', 'AC', 'Dapur bersama', 'Parkir motor'],
    accent: Color(0xFFE2A18B),
    latitude: -7.3338,
    longitude: 112.7796,
  ),
  KosListing(
    id: 'sukun-darmo',
    name: 'Kost Sukun Darmo',
    area: 'Darmo',
    address: 'Jl. Raya Darmo Permai II No. 4, Dukuh Pakis',
    price: 1800000,
    priceLabel: 'Rp1,8 jt',
    rating: 4.9,
    reviewCount: 18,
    type: 'Campur',
    imageUrl:
        'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1000&q=85',
    description:
        'Kost modern dengan akses mudah ke pusat kota Surabaya. Area bersama yang lapang, pengelola tinggal di lokasi, dan lingkungan yang tertata.',
    amenities: ['Wi-Fi', 'AC', 'CCTV', 'Laundry'],
    accent: Color(0xFFD7BC7E),
    latitude: -7.2852,
    longitude: 112.7091,
  ),
  KosListing(
    id: 'paviliun-keputih',
    name: 'Paviliun Keputih Asri',
    area: 'Sukolilo',
    address: 'Jl. Keputih Tegal No. 21, Sukolilo',
    price: 850000,
    priceLabel: 'Rp850 rb',
    rating: 4.7,
    reviewCount: 41,
    type: 'Putra',
    imageUrl:
        'https://images.unsplash.com/photo-1617104678098-de229db51175?auto=format&fit=crop&w=1000&q=85',
    description:
        'Pilihan pas untuk mahasiswa ITS dan pekerja di Surabaya Timur. Kamar fungsional, area komunal rapi, dan akses warung makan sangat dekat.',
    amenities: ['Wi-Fi', 'Kasur', 'Meja kerja', 'Parkir motor'],
    accent: Color(0xFF84AFA1),
    latitude: -7.2868,
    longitude: 112.7981,
  ),
  KosListing(
    id: 'graha-manyar',
    name: 'Graha Manyar Living',
    area: 'Manyar',
    address: 'Jl. Manyar Kertoarjo No. 36, Gubeng',
    price: 1550000,
    priceLabel: 'Rp1,55 jt',
    rating: 4.8,
    reviewCount: 29,
    type: 'Campur',
    imageUrl:
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1000&q=85',
    description:
        'Kamar berperabot dengan lokasi strategis di kawasan Manyar. Nikmati lingkungan yang hidup, banyak kafe, dan akses cepat menuju pusat bisnis.',
    amenities: ['Wi-Fi', 'AC', 'Kamar mandi dalam', 'CCTV'],
    accent: Color(0xFFE6B67F),
    latitude: -7.2772,
    longitude: 112.7628,
  ),
  KosListing(
    id: 'puri-wiyung',
    name: 'Puri Wiyung House',
    area: 'Wiyung',
    address: 'Jl. Menganti Wiyung No. 12, Wiyung',
    price: 1100000,
    priceLabel: 'Rp1,1 jt',
    rating: 4.6,
    reviewCount: 16,
    type: 'Putri',
    imageUrl:
        'https://images.unsplash.com/photo-1615874694520-474822394e73?auto=format&fit=crop&w=1000&q=85',
    description:
        'Rumah kos mungil dengan kamar privat dan area santai yang nyaman. Berada di lingkungan perumahan yang tenang, dekat pusat belanja dan akses tol.',
    amenities: ['Wi-Fi', 'Kasur', 'Dapur bersama', 'Parkir motor'],
    accent: Color(0xFFD9947B),
    latitude: -7.3156,
    longitude: 112.6894,
  ),
];
