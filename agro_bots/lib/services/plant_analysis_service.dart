import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_analysis_model.dart';

class PlantAnalysisService {
  // Replace with your actual API endpoint
  static const String _baseUrl = 'https://your-api-endpoint.com';

  Future<PlantAnalysisModel> analyzeImage(File imageFile) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/analyze'),
      );

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';

      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseData);
        return PlantAnalysisModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for demo purposes
      return _getMockAnalysis(imageFile.path);
    }
  }

  PlantAnalysisModel _getMockAnalysis(String imagePath) {
    final diseases = [
      {
        'name': 'Early Blight',
        'type': 'Fungal Disease (Alternaria solani)',
        'cause':
            'Caused by the fungus Alternaria solani, it creates black, circular leaf spots with a bull\'s-eye pattern',
        'fertilizer':
            'Use copper-based fungicides and ensure proper plant spacing for air circulation',
        'confidence': 0.85,
      },
      {
        'name': 'Late Blight',
        'type': 'Fungal Disease (Phytophthora infestans)',
        'cause':
            'Caused by Phytophthora infestans, appears as water-soaked lesions that quickly enlarge',
        'fertilizer': 'Apply preventive fungicides and avoid overhead watering',
        'confidence': 0.92,
      },
      {
        'name': 'Leaf Curl',
        'type': 'Viral Disease',
        'cause':
            'Transmitted by whiteflies, causes leaves to curl and become yellow',
        'fertilizer': 'Control whitefly population and remove affected plants',
        'confidence': 0.78,
      },
    ];

    final randomDisease =
        diseases[DateTime.now().millisecond % diseases.length];

    return PlantAnalysisModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      diseaseName: randomDisease['name'] as String,
      diseaseType: randomDisease['type'] as String,
      cause: randomDisease['cause'] as String,
      recommendedFertilizer: randomDisease['fertilizer'] as String,
      analysisDate: DateTime.now(),
      confidence: randomDisease['confidence'] as double,
    );
  }
}
