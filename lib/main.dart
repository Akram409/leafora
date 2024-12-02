import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:leafora/components/pages/diagnose/diagnose_analyse_file/plant_disease_page.dart';
import 'package:leafora/components/pages/diagnose/diagnose_analyse_file/plant_genus_page.dart';
import 'package:leafora/components/pages/diagnose/diagnose_page.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_cubit.dart';
import 'package:leafora/components/pages/user/my_bookmark/my_bookmark_page.dart';
import 'package:leafora/layout/home_page.dart';
import 'package:leafora/services/gemini_ai/gemini_plant_disease.dart';
import 'package:leafora/services/gemini_ai/gemini_plant_genus.dart';


abstract class RoutesNames {
  static const String home = '/';
  static const String plantDisease = '/plant-disease';
  static const String plantGenus = '/plant-genus';
  static const String myBookmark = '/myBookmark';
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LeaFora',
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesNames.home,
      getPages: [
        GetPage(
          name: RoutesNames.home,
          page: () => const HomePage(),
        ),
        GetPage(
          name: RoutesNames.myBookmark,
          page: () => const MyBookmarkPage(),
        ),
        GetPage(
          name: RoutesNames.plantDisease,
          page: () => BlocProvider(
            create: (context) => PlantDiseaseCubit(GeminiPlantDiseaseRepository()),
            child: const PlantDiseasePage(),
          ),
        ),
        GetPage(
          name: RoutesNames.plantGenus,
          page: () => BlocProvider(
            create: (context) => PlantDiseaseCubit(GeminiPlantGenusRepository()),
            child: const PlantGenusPage(),
          ),
        ),
      ],
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
    );
  }
}
