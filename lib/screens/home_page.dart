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
      body: BlocBuilder<SwingCubit, List<String>>(
        builder: (context, swings) {
          if (swings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: swings.length,
            itemBuilder: (context, index) {
              final swing = swings[index];
              return ListTile(
                title: Text('Swing $swing'),
                onTap: () {
                  context.read<SwingCubit>().selectSwing(swing);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwingDetailPage(swingId: swing, totalSwings: swings.length),
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