import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/firebase_utils/token_service.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/core/widgets/custom_container_button.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = _user ?? FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final provider = Provider.of<AppSettingsController>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 32),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Assets.images.accountPicture.image(
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              user?.displayName ?? 'User',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              user?.email ?? 'Email',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32),
            CustomContainerButton(
              text: local.dark_mode,
              svgPic: provider.isDark()
                  ? Assets.icons.toggleBaseDark.path
                  : Assets.icons.toggleBase.path,
              onTap: () {
                provider.setCurrentTheme(
                  provider.isDark() ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
            SizedBox(height: 16),
            CustomContainerButton(
              text: local.language,
              svgPic: provider.isArabic()
                  ? Assets.icons.arrowLeft.path
                  : Assets.icons.arrowRight.path,
              onTap: () {
                showLanguageBottomSheet(context);
              },
            ),
            SizedBox(height: 16),
            CustomContainerButton(
              text: local.logout,
              svgPic: Assets.icons.logout2.path,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await TokenService.clearToken();
                Navigator.pushReplacementNamed(context, PagesRouteName.signIn);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final local = AppLocalizations.of(context)!;
        final provider = Provider.of<AppSettingsController>(context);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                local.choose_language,
                style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: 20),

              ListTile(
                title: Text("English"),
                onTap: () {
                  provider.setCurrentLanguage(
                    'en',
                  );
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: Text("العربية"),
                onTap: () {
                  provider.setCurrentLanguage(
                    'ar',
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
