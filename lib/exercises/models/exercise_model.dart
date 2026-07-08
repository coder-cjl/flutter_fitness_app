import 'package:flutter/material.dart';

import 'localized_value.dart';

class ExerciseModel {
  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.bodyPart,
    required this.equipment,
    required this.instructions,
    required this.instructionSteps,
    required this.muscleGroup,
    required this.secondaryMuscles,
    required this.target,
    required this.image,
    required this.gifUrl,
    required this.mediaId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String category;
  final String bodyPart;
  final String equipment;
  final LocalizedText instructions;
  final LocalizedTextList instructionSteps;
  final String muscleGroup;
  final List<String> secondaryMuscles;
  final String target;
  final String? image;
  final String? gifUrl;
  final String mediaId;
  final DateTime? createdAt;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    final secondaryMusclesRaw = json['secondary_muscles'];
    final secondaryMuscles = secondaryMusclesRaw is List
        ? secondaryMusclesRaw.map((e) => '$e').toList(growable: false)
        : const <String>[];

    return ExerciseModel(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      category: '${json['category'] ?? ''}',
      bodyPart: '${json['body_part'] ?? ''}',
      equipment: '${json['equipment'] ?? ''}',
      instructions: LocalizedText.fromJson(
        json['instructions'] as Map<String, dynamic>?,
      ),
      instructionSteps: LocalizedTextList.fromJson(
        json['instruction_steps'] as Map<String, dynamic>?,
      ),
      muscleGroup: '${json['muscle_group'] ?? ''}',
      secondaryMuscles: secondaryMuscles,
      target: '${json['target'] ?? ''}',
      image: json['image'] as String?,
      gifUrl: json['gif_url'] as String?,
      mediaId: '${json['media_id'] ?? ''}',
      createdAt: DateTime.tryParse('${json['created_at'] ?? ''}'),
    );
  }

  String instruction(Locale locale, {String fallbackLanguage = 'en'}) {
    return instructions.resolve(locale, fallbackLanguage: fallbackLanguage);
  }

  List<String> steps(Locale locale, {String fallbackLanguage = 'en'}) {
    return instructionSteps.resolve(locale, fallbackLanguage: fallbackLanguage);
  }
}
