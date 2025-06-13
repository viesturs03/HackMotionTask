import 'package:flutter/material.dart';

class SwingDetailPage extends StatelessWidget {
  final String swingId;
  final int totalSwings;

  const SwingDetailPage({super.key, required this.swingId, required this.totalSwings});

  @override
  Widget build(BuildContext context) {
    final currentIndex = int.parse(swingId) - 1; // Assuming swingId is numeric (1-based)

    void navigateToSwing(int newIndex) {
      if (newIndex >= 0 && newIndex < totalSwings) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SwingDetailPage(
              swingId: (newIndex + 1).toString(),
              totalSwings: totalSwings,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Swing $swingId of $totalSwings'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex == 0 
                      ? null 
                      : () => navigateToSwing(currentIndex - 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentIndex == 0 ? Colors.grey : null,
                  ),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentIndex == totalSwings - 1 
                      ? null 
                      : () => navigateToSwing(currentIndex + 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentIndex == totalSwings - 1 ? Colors.grey : null,
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
            Card(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Flexion/Extension & Ulnar/Radial',
                      style: TextStyle(color: Colors.white),
                    ),
                    // Placeholder for graph
                    Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Center(child: Text('Graph Placeholder')),
                    ),
                    const Text('Mon Tue Wed Thu Fri Sat Sun', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Delete')),
          ],
        ),
      ),
    );
  }
}