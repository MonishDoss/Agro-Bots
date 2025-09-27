class PlantAnalysisModel {
  final String id;
  final String imagePath;
  final String diseaseName;
  final String diseaseType;
  final String cause;
  final String recommendedFertilizer;
  final DateTime analysisDate;
  final double confidence;

  PlantAnalysisModel({
    required this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.diseaseType,
    required this.cause,
    required this.recommendedFertilizer,
    required this.analysisDate,
    required this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diseaseName': diseaseName,
      'diseaseType': diseaseType,
      'cause': cause,
      'recommendedFertilizer': recommendedFertilizer,
      'analysisDate': analysisDate.toIso8601String(),
      'confidence': confidence,
    };
  }

  factory PlantAnalysisModel.fromJson(Map<String, dynamic> json) {
    return PlantAnalysisModel(
      id: json['id'] ?? '',
      imagePath: json['imagePath'] ?? '',
      diseaseName: json['diseaseName'] ?? '',
      diseaseType: json['diseaseType'] ?? '',
      cause: json['cause'] ?? '',
      recommendedFertilizer: json['recommendedFertilizer'] ?? '',
      analysisDate: DateTime.parse(json['analysisDate']),
      confidence: json['confidence']?.toDouble() ?? 0.0,
    );
  }
}
