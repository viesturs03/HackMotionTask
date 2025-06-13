import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:developer' as developer;
import '../swing_data.dart'; 

class SwingState {
  final List<String> swingIds;
  final SwingData? selectedSwingData;
  final String? selectedSwingId;

  SwingState({
    this.swingIds = const [],
    this.selectedSwingData,
    this.selectedSwingId,
  });

  SwingState copyWith({
    List<String>? swingIds,
    SwingData? selectedSwingData,
    String? selectedSwingId,
  }) {
    return SwingState(
      swingIds: swingIds ?? this.swingIds,
      selectedSwingData: selectedSwingData ?? this.selectedSwingData,
      selectedSwingId: selectedSwingId ?? this.selectedSwingId,
    );
  }
}

class SwingCubit extends Cubit<SwingState> {
  SwingCubit() : super(SwingState());

  Future<void> loadSwingIds() async {
    try {
      developer.log('Loading swing manifest...');
      final manifestContent =
          await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestContent);
      final files = manifest.keys
          .where((key) => key.startsWith('data/swings/') && key.endsWith('.json'))
          .map((key) => key.split('/').last.replaceAll('.json', ''))
          .toList();

      if (files.isNotEmpty) {
        files.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
        emit(state.copyWith(swingIds: files));
        developer.log('Swing IDs loaded: $files');
      } else {
        developer.log('No swing files found');
        emit(state.copyWith(swingIds: []));
      }
    } catch (e) {
      developer.log('Error loading swing IDs: $e');
      emit(state.copyWith(swingIds: []));
    }
  }

  Future<void> selectSwing(String swingId) async {
    try {
      developer.log('Loading data for swing $swingId...');
      final String jsonString =
          await rootBundle.loadString('data/swings/$swingId.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final swingData = SwingData.fromJson(jsonMap);
      emit(state.copyWith(
          selectedSwingData: swingData, selectedSwingId: swingId));
      developer.log('Swing data for $swingId loaded and state emitted.');
    } catch (e) {
      developer.log('Error loading swing data for $swingId: $e');
    }
  }
}