import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:developer' as developer;

class SwingCubit extends Cubit<List<String>> {
  SwingCubit() : super([]);

  Future<void> loadSwings() async {
    try {
      developer.log('Loading swings...');
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      developer.log('Manifest loaded: $manifestContent');
      
      final Map<String, dynamic> manifest = json.decode(manifestContent);
      developer.log('Manifest parsed, keys: ${manifest.keys.toList()}');
      
      final files = manifest.keys
          .where((key) => key.startsWith('data/swings/') && key.endsWith('.json'))
          .map((key) => key.split('/').last.replaceAll('.json', ''))
          .toList();
      
      developer.log('Found swings: $files');
      
      if (files.isNotEmpty) {
        // Sort the files to ensure consistent order
        files.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
        emit(files);
        developer.log('State emitted with: $files');
      } else {
        developer.log('No swing files found');
        emit([]); 
      }
    } catch (e) {
      developer.log('Error loading swings: $e');
      emit([]); 
    }
  }

  void selectSwing(String swingId) {
    emit(state); // Placeholder for now
  }
}