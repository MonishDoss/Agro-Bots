import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../widgets/custom_button.dart';
import '../result/result_screen.dart';
import '../../models/plant_analysis_model.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isAnalyzing = true);

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 3));

    // Create mock analysis result
    final analysis = PlantAnalysisModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: _selectedImage!.path,
      diseaseName: 'Early Blight',
      diseaseType: 'Fungal Disease (Alternaria solani)',
      cause:
          'Caused by the fungus Alternaria solani, it creates black, circular leaf spots with a bull\'s-eye pattern',
      recommendedFertilizer:
          'Use copper-based fungicides and ensure proper plant spacing for air circulation',
      analysisDate: DateTime.now(),
      confidence: 0.85,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(analysis: analysis),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Upload Plant Image',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 80,
                            color: AppColors.primaryGreen.withOpacity(0.5),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Select an image of your plant',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Upload from gallery or take a photo',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // Upload buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Gallery',
                    onPressed: () => _pickImage(ImageSource.gallery),
                    backgroundColor: AppColors.lightGreen,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomButton(
                    text: 'Camera',
                    onPressed: () => _pickImage(ImageSource.camera),
                    backgroundColor: AppColors.lightGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Analyze button
            if (_selectedImage != null)
              CustomButton(
                text: _isAnalyzing ? 'Analyzing...' : 'Analyze Plant',
                onPressed: _analyzeImage,
                isLoading: _isAnalyzing,
              ),
          ],
        ),
      ),
    );
  }
}
