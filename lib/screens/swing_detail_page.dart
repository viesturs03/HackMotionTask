import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/swing_cubit.dart';
import 'swing_chart.dart';

class SwingDetailPage extends StatelessWidget {
  final String swingId;
  final int totalSwings;

  const SwingDetailPage({
    super.key,
    required this.swingId,
    required this.totalSwings,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = int.parse(swingId) - 1;

    void navigateToSwing(int newIndex) {
      if (newIndex >= 0 && newIndex < totalSwings) {
        final newSwingId = (newIndex + 1).toString();
        context.read<SwingCubit>().selectSwing(newSwingId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SwingDetailPage(
              swingId: newSwingId,
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
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentIndex == totalSwings - 1
                      ? null
                      : () => navigateToSwing(currentIndex + 1),
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Flexion/Extension & Ulnar/Radial',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: BlocBuilder<SwingCubit, SwingState>(
                        builder: (context, state) {
                          if (state.selectedSwingData != null &&
                              state.selectedSwingId == swingId) {
                            return SwingChart(
                              flexionExtensionData: state
                                  .selectedSwingData!.flexionExtension,
                              ulnarRadialData:
                                  state.selectedSwingData!.ulnarRadial,
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement delete functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
