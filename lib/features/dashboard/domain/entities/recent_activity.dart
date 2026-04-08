// MODELO PARA LA LISTA INFERIOR DE ACTIVIDADES RECIENTES EN EL DASHBOARD

import 'package:flutter/material.dart';

class RecentActivity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const RecentActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}