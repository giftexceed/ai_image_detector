import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:tflite/tflite.dart';
import 'ai_event.dart';
import 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  AIBloc() : super(AIInitial()) {
    on<PerformImageRecognitionEvent>(_onPerformImageRecognition);
  }

  Future<void> _onPerformImageRecognition(
      PerformImageRecognitionEvent event, Emitter<AIState> emit) async {
    emit(AILoading());
    try {
      // Run the model on the selected image
      List<dynamic>? results = await Tflite.runModelOnImage(
        path: event.imagePath,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5,
      );

      // Persist results in Hive
      var box = Hive.box('recognition_results');
      await box.put('last_results', results);

      emit(AIImageRecognitionSuccess(results: results ?? []));
    } catch (e) {
      emit(AIError(message: 'Error: $e'));
    }
  }
}
