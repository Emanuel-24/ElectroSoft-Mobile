import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesChart extends StatefulWidget {
  final Map<int, double> ventasPorMes;
  final int year;

  const SalesChart({super.key, required this.ventasPorMes, required this.year});

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  static const _monthNames = [
    '',
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

  late int _endMonth;
  int? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _endMonth = _initialEndMonth(widget.year);
  }

  @override
  void didUpdateWidget(covariant SalesChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year) {
      _endMonth = _initialEndMonth(widget.year);
      _selectedMonth = null;
    }
  }

  int _initialEndMonth(int year) {
    final now = DateTime.now();
    return year == now.year ? now.month : 12;
  }

  int get _maxEndMonth => _initialEndMonth(widget.year);

  @override
  Widget build(BuildContext context) {
    final startMonth = _endMonth - 5;
    final visibleMonths = List.generate(6, (index) => startMonth + index);

    double maxVenta = 100000;
    for (final month in visibleMonths) {
      final value = widget.ventasPorMes[month] ?? 0;
      if (value > maxVenta) maxVenta = value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${_monthNames[startMonth]} - ${_monthNames[_endMonth]} ${widget.year}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _ChartArrowButton(
              icon: Icons.chevron_left,
              enabled: startMonth > 1,
              onPressed: startMonth > 1
                  ? () => setState(() {
                      _endMonth--;
                      _selectedMonth = null;
                    })
                  : null,
            ),
            _ChartArrowButton(
              icon: Icons.chevron_right,
              enabled: _endMonth < _maxEndMonth,
              onPressed: _endMonth < _maxEndMonth
                  ? () => setState(() {
                      _endMonth++;
                      _selectedMonth = null;
                    })
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVenta * 1.2,
              minY: 0,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.15),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) =>
                      const Color(0xFF1A1A1A).withValues(alpha: 0.9),
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 0,
                        locale: 'es_CO',
                      ).format(rod.toY),
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  final spot = response?.spot;
                  if (spot != null && spot.touchedBarGroupIndex < 6) {
                    setState(() {
                      _selectedMonth = visibleMonths[spot.touchedBarGroupIndex];
                    });
                  } else if (event is FlTapUpEvent) {
                    setState(() => _selectedMonth = null);
                  }
                },
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      final text = value >= 1000000
                          ? '${(value / 1000000).toStringAsFixed(1)}M'
                          : value >= 1000
                          ? '${(value / 1000).toStringAsFixed(0)}K'
                          : value.toStringAsFixed(0);

                      return SideTitleWidget(
                        meta: meta,
                        space: 4,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= visibleMonths.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          _monthNames[visibleMonths[index]],
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(visibleMonths.length, (index) {
                final month = visibleMonths[index];
                final value = widget.ventasPorMes[month] ?? 0;

                return BarChartGroupData(
                  x: index,
                  showingTooltipIndicators: _selectedMonth == month
                      ? const [0]
                      : const [],
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                      color: _selectedMonth == month
                          ? const Color(0xFFE0A800)
                          : const Color(0xFFFFCC00),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onPressed;

  const _ChartArrowButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 20,
      visualDensity: VisualDensity.compact,
      color: enabled ? const Color(0xFF1A6FA8) : Colors.grey.shade300,
      tooltip: enabled ? 'Cambiar periodo' : null,
    );
  }
}
