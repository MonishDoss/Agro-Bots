import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/plant_analysis_model.dart';
import '../result/result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PlantAnalysisModel> _historyItems = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    // Mock history data
    _historyItems = [
      PlantAnalysisModel(
        id: '1',
        imagePath: '',
        diseaseName: 'Early Blight',
        diseaseType: 'Fungal Disease (Alternaria solani)',
        cause: 'Caused by the fungus Alternaria solani',
        recommendedFertilizer: 'Use copper-based fungicides',
        analysisDate: DateTime.now().subtract(const Duration(days: 2)),
        confidence: 0.85,
      ),
      PlantAnalysisModel(
        id: '2',
        imagePath: '',
        diseaseName: 'Late Blight',
        diseaseType: 'Fungal Disease (Phytophthora infestans)',
        cause: 'Caused by Phytophthora infestans',
        recommendedFertilizer: 'Use preventive fungicides',
        analysisDate: DateTime.now().subtract(const Duration(days: 5)),
        confidence: 0.92,
      ),
      PlantAnalysisModel(
        id: '3',
        imagePath: '',
        diseaseName: 'Leaf Curl',
        diseaseType: 'Viral Disease',
        cause: 'Transmitted by whiteflies',
        recommendedFertilizer: 'Control whitefly population',
        analysisDate: DateTime.now().subtract(const Duration(days: 10)),
        confidence: 0.78,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          AppStrings.history,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _historyItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: AppColors.textSecondary),
                  SizedBox(height: 20),
                  Text(
                    'No analysis history yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start analyzing plants to see your history here',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _historyItems.length,
              itemBuilder: (context, index) {
                final item = _historyItems[index];
                return _buildHistoryItem(item);
              },
            ),
    );
  }

  Widget _buildHistoryItem(PlantAnalysisModel analysis) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(analysis: analysis),
            ),
          );
        },
        child: Row(
          children: [
            // Plant image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.eco,
                color: AppColors.primaryGreen,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            // Analysis details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.diseaseName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    analysis.diseaseType,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(analysis.analysisDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(analysis.confidence * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow icon
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
