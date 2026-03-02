import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/food_item.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData {
  final String label;
  final List<double> values;
  final Color color;

  ChartData(this.label, this.values, this.color);
}

class ComparisonScreen extends StatefulWidget {
  final List<FoodItem> items;

  const ComparisonScreen({super.key, required this.items});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen>
    with SingleTickerProviderStateMixin {
  late List<FoodItem> selectedItems;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    selectedItems = widget.items;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _slideAnimation = Tween<double>(
      begin: 80.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: const Color(0xFFF2F2F7).withOpacity(0.8)),
          ),
        ),
        title: const Text(
          'Compare Items',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildComparisonTable(),
                    const SizedBox(height: 20),
                    _buildNutritionChart(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF34C759).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF34C759).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.compare_arrows,
                                color: Color(0xFF34C759),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Comparison Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Table(
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 0.5,
                                ),
                              ),
                              columnWidths: Map.fromEntries(
                                List.generate(
                                  selectedItems.length + 1,
                                  (index) => MapEntry(
                                    index,
                                    index == 0
                                        ? const FlexColumnWidth(1.2)
                                        : const FlexColumnWidth(1),
                                  ),
                                ),
                              ),
                              children: [
                                _buildTableRow(
                                  'Name',
                                  selectedItems.map((item) => item.name).toList(),
                                  isHeader: true,
                                ),
                                _buildTableRow(
                                  'Price',
                                  selectedItems
                                      .map((item) =>
                                          '₹${item.price.toStringAsFixed(2)}')
                                      .toList(),
                                ),
                                _buildTableRow(
                                  'Protein',
                                  selectedItems
                                      .map((item) => '${item.protein}g')
                                      .toList(),
                                ),
                                _buildTableRow(
                                  'Carbs',
                                  selectedItems
                                      .map((item) => '${item.carbs}g')
                                      .toList(),
                                ),
                                _buildTableRow(
                                  'Fat',
                                  selectedItems
                                      .map((item) => '${item.fat}g')
                                      .toList(),
                                ),
                                _buildTableRow(
                                  'Outlet',
                                  selectedItems.map((item) => item.outlet).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _buildTableRow(
    String attribute,
    List<String> values, {
    bool isHeader = false,
  }) {
    return TableRow(
      decoration: isHeader
          ? BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              attribute,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isHeader ? 14 : 13,
                color: const Color(0xFF1C1C1E),
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),
        ...values.map(
          (value) => TableCell(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isHeader ? 14 : 13,
                  color: const Color(0xFF3C3C43).withOpacity(0.9),
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadarChart(List<FoodItem> items, List<ChartData> chartData) {
    final maxValues = List<double>.generate(
      3,
      (i) => chartData[i].values.reduce((a, b) => a > b ? a : b),
    );

    return AspectRatio(
      aspectRatio: 1.2,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBorderData: BorderSide(color: Colors.grey[300]!, width: 1),
          gridBorderData: BorderSide(color: Colors.grey[200]!, width: 1),
          tickCount: 5,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          titleTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1C1E),
          ),
          getTitle: (index, angle) => RadarChartTitle(
            text: index == 0
                ? 'Protein'
                : index == 1
                    ? 'Carbs'
                    : 'Fat',
            angle: angle,
          ),
          titlePositionPercentageOffset: 0.2,
          dataSets: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return RadarDataSet(
              fillColor:
                  Colors.primaries[index % Colors.primaries.length].withOpacity(0.1),
              borderColor: Colors.primaries[index % Colors.primaries.length],
              entryRadius: 4,
              dataEntries: [
                RadarEntry(value: (item.protein / maxValues[0]) * 100),
                RadarEntry(value: (item.carbs / maxValues[1]) * 100),
                RadarEntry(value: (item.fat / maxValues[2]) * 100),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNutritionChart() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF007AFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF007AFF).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.radar,
                                color: Color(0xFF007AFF),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Nutrition Comparison',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: _buildRadarChart(selectedItems, [
                            ChartData(
                              'Protein',
                              selectedItems.map((item) => item.protein).toList(),
                              const Color(0xFF007AFF),
                            ),
                            ChartData(
                              'Carbs',
                              selectedItems.map((item) => item.carbs).toList(),
                              const Color(0xFF34C759),
                            ),
                            ChartData(
                              'Fat',
                              selectedItems.map((item) => item.fat).toList(),
                              const Color(0xFFFF9500),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}