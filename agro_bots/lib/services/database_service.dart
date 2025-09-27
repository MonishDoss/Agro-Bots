import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant_analysis_model.dart';

class DatabaseService {
  static const String _historyKey = 'plant_analysis_history';

  Future<List<PlantAnalysisModel>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      return historyJson
          .map((json) => PlantAnalysisModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveAnalysis(PlantAnalysisModel analysis) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      historyJson.insert(0, jsonEncode(analysis.toJson()));

      // Keep only last 50 entries
      if (historyJson.length > 50) {
        historyJson.removeRange(50, historyJson.length);
      }

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      throw Exception('Failed to save analysis: $e');
    }
  }

  Future<void> deleteAnalysis(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      historyJson.removeWhere((json) {
        final analysis = PlantAnalysisModel.fromJson(jsonDecode(json));
        return analysis.id == id;
      });

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      throw Exception('Failed to delete analysis: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }
}
