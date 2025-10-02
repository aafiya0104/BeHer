import 'package:flutter/material.dart';
import '../models/user_skin_profile.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final int initialPage; 
  final UserSkinProfile? existingProfile; 
  const OnboardingScreen({
    super.key,
    this.initialPage = 0,
    this.existingProfile,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  late UserSkinProfile profile;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);

    profile = widget.existingProfile ?? UserSkinProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildGetStartedStep(),
          buildSkinTypeStep(),
          buildConcernsStep(),
          buildDesiredEffectsStep(),
          buildPreviousProductsStep(),
        ],
      ),
    );
  }

  Widget buildGetStartedStep() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: const Text("Get Started"),
      ),
    );
  }

  Widget buildSkinTypeStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Select your skin type:", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ...['Oily', 'Dry', 'Combination'].map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  profile.skinType = type;
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(type),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }

  Widget buildConcernsStep() {
    List<String> options = [
      'Acne',
      'Wrinkles',
      'Dark Circles',
      'Pigmentation',
      'Sensitivity',
    ];
    return buildMultiSelectStep(
      title: "Select your skin concerns:",
      options: options,
      selectedList: profile.concerns,
      onNext: () => _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      showBack: true,
    );
  }

  Widget buildDesiredEffectsStep() {
    List<String> options = [
      'Glow',
      'Hydration',
      'Anti-Aging',
      'Even Tone',
      'Reduce Oiliness',
    ];
    return buildMultiSelectStep(
      title: "Select your desired effects:",
      options: options,
      selectedList: profile.desiredEffects,
      onNext: () => _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      showBack: true,
    );
  }

  Widget buildPreviousProductsStep() {
    TextEditingController controller = TextEditingController(
      text: profile.previousProducts.join(", "),
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Previous products or brands that worked for you:",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "E.g., Cetaphil, Neutrogena",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text("Back"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    profile.previousProducts = controller.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                  }

                  // ✅ if editing → pop back with updated profile
                  if (widget.existingProfile != null) {
                    Navigator.pop(context, profile);
                  } else {
                    // ✅ first time → go to home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(profile: profile),
                      ),
                    );
                  }
                },
                child: const Text("Finish"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMultiSelectStep({
    required String title,
    required List<String> options,
    required List<String> selectedList,
    required VoidCallback onNext,
    bool showBack = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          ...options.map((option) {
            bool isSelected = selectedList.contains(option);
            return ListTile(
              title: Text(option),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedList.remove(option);
                  } else {
                    selectedList.add(option);
                  }
                });
              },
            );
          }).toList(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBack)
                ElevatedButton(
                  onPressed: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text("Back"),
                ),
              ElevatedButton(onPressed: onNext, child: const Text("Next")),
            ],
          ),
        ],
      ),
    );
  }
}
