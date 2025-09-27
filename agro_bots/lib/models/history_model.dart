class HistoryModel {
  final String id;
  final List<String> analysisIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  HistoryModel({
    required this.id,
    required this.analysisIds,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'analysisIds': analysisIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      analysisIds: List<String>.from(json['analysisIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  HistoryModel copyWith({
    String? id,
    List<String>? analysisIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      analysisIds: analysisIds ?? this.analysisIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
