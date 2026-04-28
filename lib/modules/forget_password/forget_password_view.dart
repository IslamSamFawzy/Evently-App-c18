import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/core/widgets/custom_app_bar.dart';
import 'package:evenrly/core/widgets/custom_button_widget.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final provider = Provider.of<AppSettingsController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomAppBar(),
        title: Text(local.forget_password, style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Assets.images.forgetPasswordDark.image(
                color: provider.isDark() ? Colors.white : AppColors.primary,
              ),
              SizedBox(height: 40),
              CustomButtonWidget(
                onPressed: () {
                  showResetPasswordDialog(context);
                },
                buttonTitle: local.reset_password,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showResetPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final local = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(local.reset_password, style: theme.textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                local.enter_your_email_to_receive_a_reset_link,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20),

              TextField(
                style: TextStyle(color: Colors.black),
                controller: emailController,
                decoration: InputDecoration(
                  hintText: local.enter_your_email,
                  hintStyle: theme.textTheme.bodyLarge,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(local.cancel,style: theme.textTheme.bodyMedium,),
            ),

            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(local.enter_your_email)),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: email,
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(local.check_your_email)),
                  );
                } on FirebaseAuthException catch (e) {
                  debugPrint("ERROR CODE: ${e.code}");
                  debugPrint("ERROR MESSAGE: ${e.message}");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? local.error)),
                  );
                }
              },
              child: Text(local.send,style: theme.textTheme.bodyMedium,),
            ),
          ],
        );
      },
    );
  }
}
