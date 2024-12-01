import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_repository.dart';


class GeminiPlantDiseaseRepository extends AbstractPlantDiseaseRepository {
  final apiKey = dotenv.env['GEM_API_KEY'];

  @override
  Future<List<String>> detectPlantDisease(XFile image) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey!,
    );

    final prompt = '''
🌿 Plant Health Diagnostic Expert 🍃

Your mission is to provide a comprehensive plant health assessment:

🔬 Detailed Disease Analysis
- Precisely identify the specific plant disease
- Determine the exact pathogen or condition
- Assess the severity and potential spread of the disease

🩺 In-Depth Diagnosis
- Explain the root cause of the disease
- Identify symptoms and visual indicators
- Discuss potential environmental or genetic factors

🌈 Comprehensive Care Guide
- Provide step-by-step treatment methods
- Recommend organic and chemical intervention strategies
- Suggest immediate and long-term plant care techniques

🛡️ Prevention and Maintenance
- Share expert prevention tips
- Explain how to create optimal growing conditions
- Provide guidance on soil health, watering, and nutrition

💡 Bonus Insights
- Offer scientific background about the disease
- Explain potential impact on plant health and ecosystem
- Provide gardening expert-level insights

📝 Response Guidelines:
- Use a professional yet approachable tone
- Format in clear, structured markdown
- Include practical, actionable advice
- Prioritize plant's overall health and recovery

Treat each plant diagnosis as a unique healing journey! 🌱🌟
''';

    final imageBytes = await image.readAsBytes();
    final mimetype = image.mimeType ?? 'image/jpeg';

    final response = await model.generateContent([
      Content.multi([TextPart(prompt), DataPart(mimetype, imageBytes)])
    ]);

    return [response.text!];
  }
}