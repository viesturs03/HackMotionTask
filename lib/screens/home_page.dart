import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/swing_cubit.dart';
import 'swing_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HackMotion')),
      body: BlocBuilder<SwingCubit, SwingState>(
        builder: (context, state) {
          if (state.swingIds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: state.swingIds.length,
            itemBuilder: (context, index) {
              final swingId = state.swingIds[index];
              return ListTile(
                title: Text('Swing $swingId'),
                onTap: () {
                  context.read<SwingCubit>().selectSwing(swingId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwingDetailPage(
                        swingId: swingId,
                        totalSwings: state.swingIds.length,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}