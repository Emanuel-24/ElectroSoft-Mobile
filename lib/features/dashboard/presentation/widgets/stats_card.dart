import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'sales_chart_painter.dart';

class StatsCard extends StatefulWidget {
  // Cambiado a StatefulWidget para manejar el estado del mes
  final String title;
  final String value;
  final String? percentage;
  final String? subtitle;
  final IconData? icon;
  final Color accentColor;
  final bool isMain;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.percentage,
    this.subtitle,
    this.icon,
    this.accentColor = const Color(0xFFFFCC00),
    this.isMain = false,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  String selectedMonth = 'Ene';

  final List<String> months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (!widget.isMain)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isMain) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      Row(
                        children: [
                          if (widget.percentage != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.percentage!,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),

                          // 👇 SELECTOR DE MES ESTILIZADO
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            height: 30,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedMonth,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppTheme.textDark,
                                ),
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                dropdownColor:
                                    Colors.white, // Color del menú desplegable
                                focusColor: Colors.transparent,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.bold,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() => selectedMonth = newValue);
                                  }
                                },
                                // El secreto del "hover" y contraste está en el mapping de los items:
                                items: months.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                                // Propiedad para el efecto visual al seleccionar
                                selectedItemBuilder: (BuildContext context) {
                                  return months.map<Widget>((String item) {
                                    return Center(child: Text(item));
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: CustomPaint(painter: SalesChartPainter()),
                  ),
                ] else ...[
                  // Contenido para tarjetas secundarias...
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                      if (widget.icon != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.accentColor,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
