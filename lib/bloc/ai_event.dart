abstract class AIEvent {}

class PerformImageRecognitionEvent extends AIEvent {
  final String imagePath;

  PerformImageRecognitionEvent({required this.imagePath});
}
