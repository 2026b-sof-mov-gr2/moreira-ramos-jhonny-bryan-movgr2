import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Datos de ejemplo: las pantallas son solo interfaces, sin backend.
class Dish {
  final String name;
  final String description;
  final double price;
  final String category;
  final Color color;
  final IconData icon;
  final bool available;

  const Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.color,
    required this.icon,
    this.available = true,
  });
}

class PastOrder {
  final String code;
  final String date;
  final String items;
  final double total;
  final String status;

  const PastOrder({
    required this.code,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });
}

const categories = ['Almuerzo', 'Snacks', 'Bebidas', 'Postres'];

const dishes = <Dish>[
  Dish(
    name: 'Almuerzo del día',
    description: 'Sopa, arroz, pollo y jugo',
    price: 2.50,
    category: 'Almuerzo',
    color: AppColors.orange,
    icon: Icons.rice_bowl_rounded,
  ),
  Dish(
    name: 'Menú vegetariano',
    description: 'Crema de zapallo, menestra y ensalada',
    price: 2.75,
    category: 'Almuerzo',
    color: AppColors.green,
    icon: Icons.eco_rounded,
  ),
  Dish(
    name: 'Seco de pollo',
    description: 'Arroz, maduro y ensalada',
    price: 3.00,
    category: 'Almuerzo',
    color: AppColors.pink,
    icon: Icons.dinner_dining_rounded,
    available: false,
  ),
  Dish(
    name: 'Sánduche de pollo',
    description: 'Pan, pollo, lechuga y salsa',
    price: 1.75,
    category: 'Snacks',
    color: AppColors.green,
    icon: Icons.lunch_dining_rounded,
  ),
  Dish(
    name: 'Empanada de queso',
    description: 'Recién horneada',
    price: 0.80,
    category: 'Snacks',
    color: AppColors.yellow,
    icon: Icons.bakery_dining_rounded,
  ),
  Dish(
    name: 'Jugo natural',
    description: 'Mora, naranja o maracuyá',
    price: 0.75,
    category: 'Bebidas',
    color: AppColors.yellow,
    icon: Icons.local_drink_rounded,
  ),
  Dish(
    name: 'Café pasado',
    description: 'Con o sin leche',
    price: 0.60,
    category: 'Bebidas',
    color: AppColors.orange,
    icon: Icons.coffee_rounded,
  ),
  Dish(
    name: 'Torta de chocolate',
    description: 'Porción individual',
    price: 1.25,
    category: 'Postres',
    color: AppColors.pink,
    icon: Icons.cake_rounded,
  ),
];

const pastOrders = <PastOrder>[
  PastOrder(
    code: 'A-27',
    date: 'Hoy · 12:02',
    items: 'Almuerzo del día, Jugo natural x2',
    total: 4.25,
    status: 'Listo',
  ),
  PastOrder(
    code: 'B-14',
    date: 'Ayer · 13:10',
    items: 'Sánduche de pollo, Café pasado',
    total: 2.35,
    status: 'Entregado',
  ),
  PastOrder(
    code: 'C-08',
    date: '24 nov · 12:45',
    items: 'Menú vegetariano',
    total: 2.75,
    status: 'Entregado',
  ),
  PastOrder(
    code: 'A-03',
    date: '21 nov · 13:30',
    items: 'Empanada de queso x2, Jugo natural',
    total: 2.35,
    status: 'Cancelado',
  ),
];

String money(double value) => '\$${value.toStringAsFixed(2)}';
