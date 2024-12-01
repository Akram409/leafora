import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_repository.dart';

class GeminiPlantGenusRepository extends AbstractPlantDiseaseRepository {
  final apiKey = dotenv.env['GEM_API_KEY'];

  @override
  Future<List<String>> detectPlantDisease(XFile image) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey!,
    );

    final prompt = '''
🌿 Plant Identification Expert 🔬

You are a world-class botanist and plant identification specialist. When presented with a plant image, your mission is to:

🌱 Detailed Plant Identification
- Precisely determine the plant genus and species
- Confirm the exact botanical classification
- Provide the scientific and common names

🔍 Comprehensive Plant Profile
- Describe the plant's natural habitat and origin
- Highlight unique botanical characteristics
- Share interesting ecological and cultural significance

🌍 Additional Insights
- Explain the plant's role in its ecosystem
- Mention any medicinal or practical uses
- Discuss conservation status if applicable

📝 Response Guidelines:
- Use a friendly, informative tone
- Format response in clear, engaging markdown
- Include emojis to make information visually appealing
- Provide scientifically accurate and fascinating details

Approach this identification as a botanical discovery adventure! 🌈🔬
''';

    final imageBytes = await image.readAsBytes();
    final mimetype = image.mimeType ?? 'image/jpeg';

    final response = await model.generateContent([
      Content.multi([TextPart(prompt), DataPart(mimetype, imageBytes)])
    ]);

    return [response.text!];
  }
}
