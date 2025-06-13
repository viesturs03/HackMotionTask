import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SwingChart extends StatelessWidget {
  final List<double> flexionExtensionData;
  final List<double> ulnarRadialData;

  const SwingChart({
    super.key,
    required this.flexionExtensionData,
    required this.ulnarRadialData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: -60,
              maxY: 60,  
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  );
                },
                checkToShowHorizontalLine: (value) {
                  return value % 20 == 0;
                },
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      if (value > 40 || value < -40) {
                        return Container();
                      }
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      );
                    },
                    reservedSize: 35,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              lineBarsData: [
                _buildLineChartBarData(flexionExtensionData, Colors.blue, 'Flex/Ext'),
                _buildLineChartBarData(ulnarRadialData, Colors.red, 'Ulnar/Radial'),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot;
                      String text;
                      if (barSpot.barIndex == 0) {
                        text = 'Flex/Ext:';
                      } else if (barSpot.barIndex == 1) {
                        text = 'Ulnar/Radial:';
                      } else {
                        throw Error();
                      }
                      return LineTooltipItem(
                        '$text ${flSpot.y.toStringAsFixed(2)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.blue, "Flex/Ext"),
        const SizedBox(width: 20),
        _legendItem(Colors.red, "Ulnar/Radial"),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  LineChartBarData _buildLineChartBarData(
      List<double> data, Color color, String name) {
    return LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value);
      }).toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}