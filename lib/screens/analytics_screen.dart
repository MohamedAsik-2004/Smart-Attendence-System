import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String,int>> _fetchCounts() async {
    final snap = await _firestore.collection('attendance').get();
    final map = <String,int>{};
    for (final d in snap.docs) {
      final method = d['method'] ?? 'unknown';
      map[method] = (map[method] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchCounts(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Unable to load analytics: ${snap.error}'));
          }

          final data = snap.data ?? const <String, int>{};
          final items = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
          if (items.isEmpty) return const Center(child: Text('No attendance data'));

          final colors = <Color>[
            Colors.blue,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.red,
            Colors.teal,
          ];
          final spots = List.generate(
            items.length,
            (i) => PieChartSectionData(
              value: items[i].value.toDouble(),
              title: items[i].key,
              color: colors[i % colors.length],
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 260,
                  child: PieChart(
                    PieChartData(
                      sections: spots,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Text(items[i].key),
                      trailing: Text('${items[i].value}'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
