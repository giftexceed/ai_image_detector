abstract class AIState {}

class AIInitial extends AIState {}

class AILoading extends AIState {}

class AIImageRecognitionSuccess extends AIState {
  final List<dynamic> results;

  AIImageRecognitionSuccess({required this.results});
}

class AIError extends AIState {
  final String message;

  AIError({required this.message});
}
