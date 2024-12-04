class OnboardingModel {
  final String lottieURL;
  final String title;
  final String subtitle;

  OnboardingModel(
    this.lottieURL,
    this.title,
    this.subtitle,
  );
}

List<OnboardingModel> OnboardingItem = [
  OnboardingModel(
    'assets/images/1.json',
    ' Identify the Green World Around You',
    "Turn your smartphone into a plant expert.Scan any plant using your camera and let Lefora identify for you",
  ),
  OnboardingModel(
    'assets/images/2.json',
    'Your All-in-One Plant Care Companion',
    "Lefora helps you care for your plants.Diagnosis diseases with a quick camera scan.",
  ),
  OnboardingModel(
    'assets/images/3.json',
    'Explore the Green World',
    "Explore tips, articles, and expert advice for your garden.From beginners to experts, there’s something for everyone.",
  ),
];
