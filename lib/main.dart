import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:leafora/components/authentication/splash_screen.dart';
import 'package:leafora/components/authentication/welcome_screen.dart';
import 'package:leafora/components/pages/article/article_details/article_details.dart';
import 'package:leafora/components/pages/article/article_details/article_details_by_id.dart';
import 'package:leafora/components/pages/article/popular_article_list/popular_article_list.dart';
import 'package:leafora/components/pages/diagnose/diagnose_analyse_file/plant_disease_page.dart';
import 'package:leafora/components/pages/diagnose/diagnose_analyse_file/plant_genus_page.dart';
import 'package:leafora/components/pages/diagnose/diagnose_page.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_cubit.dart';
import 'package:leafora/components/pages/diagnose/diseases/common_disease_list.dart';
import 'package:leafora/components/pages/diagnose/diseases/disease_details.dart';
import 'package:leafora/components/pages/diagnose/explore_diseases/category_disease_list.dart';
import 'package:leafora/components/pages/diagnose/explore_diseases/explore_diseases_list.dart';
import 'package:leafora/components/pages/expert/expert_page.dart';
import 'package:leafora/components/pages/my_account/my_account.dart';
import 'package:leafora/components/pages/my_account/payment_methods/payment_method_page.dart';
import 'package:leafora/components/pages/my_account/payment_methods/upgrade_plan_message.dart';
import 'package:leafora/components/pages/my_account/subscription/subscription_page.dart';
import 'package:leafora/components/pages/my_plants/diagnosis_history/diagnosis_history_details.dart';
import 'package:leafora/components/pages/plants/explore_plants/explore_plants.dart';
import 'package:leafora/components/pages/plants/plant_details/plant_details.dart';
import 'package:leafora/components/pages/plants/plant_details/plant_details_by_id.dart';
import 'package:leafora/components/pages/user/my_bookmark/my_bookmark_page.dart';
import 'package:leafora/firebase_database_dir/firebase/firebase_options.dart';
import 'package:leafora/layout/home_page.dart';
import 'package:leafora/services/gemini_ai/gemini_plant_disease.dart';
import 'package:leafora/services/gemini_ai/gemini_plant_genus.dart';
import 'package:leafora/services/notification_service.dart';



abstract class RoutesNames {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String plantDisease = '/plant-disease';
  static const String plantGenus = '/plant-genus';
  static const String myBookmark = '/myBookmark';
  static const String popularArticle = '/popularArticle';
  static const String articleDetails = '/articleDetails';
  static const String articleDetailsById = '/articleDetailsById';
  static const String plantDetails = '/plantDetails';
  static const String plantDetailsById = '/plantDetailsById';
  static const String diseaseDetails = '/diseaseDetails';
  static const String explorePlants = '/explorePlants';
  static const String commonDiseaseList = '/commonDiseaseList';
  static const String exploreDiseaseList = '/exploreDiseaseList';
  static const String categoryDiseaseList = '/categoryDiseaseList';
  static const String diagnosisHistoryDetails = '/diagnosisHistoryDetails';
  static const String myAccount = '/myAccount';
  static const String paymentMethod = '/paymentMethod';
  static const String askPlantExpert = '/askPlantExpert';
  static const String subscription = '/subscription';
  static const String upgradePlantMessage = '/upgradePlantMessage';
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await dotenv.load(fileName: ".env");
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      name: "lefora-ai",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  await NotificationService.instance.initialize();
  // initializeShurjopay(environment: 'sandbox');

  //for setting orientation to portrait only
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LeaFora',
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesNames.splash,
      getPages: [
        GetPage(
          name: RoutesNames.home,
          page: () => const HomePage(),
        ),
        GetPage(
          name: RoutesNames.welcome,
          page: () => const WelcomePage(),
        ),
        GetPage(
          name: RoutesNames.splash,
          page: () => const Splash(),
        ),
        GetPage(
          name: RoutesNames.myBookmark,
          page: () => const MyBookmarkPage(),
        ),
        GetPage(
          name: RoutesNames.articleDetails,
          page: () =>  ArticleDetails(),
        ),
        GetPage(
          name: RoutesNames.articleDetailsById,
          page: () =>  ArticleDetailsById(),
        ),GetPage(
          name: RoutesNames.plantDetailsById,
          page: () =>  PlantDetailsById(),
        ),
        GetPage(
          name: RoutesNames.diagnosisHistoryDetails,
          page: () =>  DiagnosisHistoryDetails(),
        ),
        GetPage(
          name: RoutesNames.myAccount,
          page: () =>  MyAccount(),
        ),
        GetPage(
          name: RoutesNames.subscription,
          page: () =>  SubscriptionPage(),
        ),GetPage(
          name: RoutesNames.upgradePlantMessage,
          page: () =>  UpgradePlanMessage(),
        ),
        GetPage(
          name: RoutesNames.paymentMethod,
          page: () =>  PaymentMethodPage(),
        ),
        GetPage(
          name: RoutesNames.explorePlants,
          page: () =>  ExplorePlants(),
        ),
        GetPage(
          name: RoutesNames.plantDetails,
          page: () =>  PlantDetails(),
        ),
        GetPage(
          name: RoutesNames.diseaseDetails,
          page: () =>  DiseaseDetails(),
        ),
        GetPage(
          name: RoutesNames.commonDiseaseList,
          page: () =>  CommonDiseaseList(),
        ),
        GetPage(
          name: RoutesNames.exploreDiseaseList,
          page: () =>  ExploreDiseasesList(),
        ),
        GetPage(
          name: RoutesNames.categoryDiseaseList,
          page: () =>  CategoryDiseaseList(),
        ),
        GetPage(
          name: RoutesNames.popularArticle,
          page: () => const PopularArticleList(),
        ),
        GetPage(
          name: RoutesNames.askPlantExpert,
          page: () => const ExpertPage(),
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
