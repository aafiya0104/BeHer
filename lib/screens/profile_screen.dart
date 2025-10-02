import 'package:flutter/material.dart';
import '../models/user_skin_profile.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserSkinProfile profile;
  const ProfileScreen({super.key, required this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserSkinProfile profile;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("Skin Type: ${profile.skinType ?? 'Not set'}"),
          Text("Concerns: ${profile.concerns.join(', ')}"),
          Text("Desired Effects: ${profile.desiredEffects.join(', ')}"),
          Text("Previous Products: ${profile.previousProducts.join(', ')}"),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final updatedProfile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OnboardingScreen(
                      initialPage: 1, // jump to Skin Type
                      existingProfile: profile,
                    ),
                  ),
                );

                if (updatedProfile != null && updatedProfile is UserSkinProfile) {
                  setState(() {
                    profile = updatedProfile;
                  });
                }
              },
              child: const Text("Edit Profile"),
            ),
          ),
        ],
      ),
    );
  }
}
