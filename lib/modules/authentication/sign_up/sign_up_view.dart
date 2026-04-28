import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/firebase_utils/firebase_auth.dart';
import 'package:evenrly/core/utils/firebase_utils/google_auth_services.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/core/widgets/custom_app_bar.dart';
import 'package:evenrly/core/widgets/custom_button_widget.dart';
import 'package:evenrly/core/widgets/custom_text_form_filed.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    final local = AppLocalizations.of(context)!;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailAddress = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController name = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: CustomAppBar(),
        title: Assets.images.eventlyLogoImg.image(
          width: 142,
          color: theme.primaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  local.create_your_account,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: provider.isDark()
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                ),
                SizedBox(height: 24),
                CustomTextFormFiled(
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enter_your_name;
                    } else {
                      return null;
                    }
                  },
                  controller: name,
                  prefixIcon: Assets.icons.user.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      provider.isDark() ? Colors.white : Color(0x50686868),
                      BlendMode.srcIn,
                    ),
                  ),
                  hintText: local.enter_your_name,
                ),
                SizedBox(height: 16),
                CustomTextFormFiled(
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enter_your_email;
                    } else if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return local.enter_a_valid_email;
                    } else {
                      return null;
                    }
                  },
                  controller: emailAddress,
                  prefixIcon: Assets.images.sms.image(
                    width: 20,
                    height: 20,
                    color: provider.isDark() ? Colors.white : Color(0x50686868),
                  ),
                  hintText: local.enter_your_email,
                ),
                SizedBox(height: 16),
                CustomTextFormFiled(
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enter_your_password;
                    } else if (value.length < 6) {
                      return local.password_must_be_at_least_6_characters;
                    } else {
                      return null;
                    }
                  },
                  controller: password,
                  prefixIcon: Assets.icons.lock.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      provider.isDark() ? Colors.white : Color(0x50686868),
                      BlendMode.srcIn,
                    ),
                  ),
                  hintText: local.enter_your_password,
                  isPassword: true,
                ),
                SizedBox(height: 16),
                CustomTextFormFiled(
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enter_your_password;
                    } else if (value != password.text) {
                      return local.passwords_do_not_match;
                    } else {
                      return null;
                    }
                  },
                  prefixIcon: Assets.icons.lock.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      provider.isDark() ? Colors.white : Color(0x50686868),
                      BlendMode.srcIn,
                    ),
                  ),
                  hintText: local.confirm_your_password,
                  isPassword: true,
                ),
                SizedBox(height: 56),
                CustomButtonWidget(
                  buttonTitle: local.sign_up,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseAuthUtils.signUpWithEmailAndPassword(
                        emailAddress.text,
                        password.text,
                        name.text,
                      );
                      return setState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                ),
                SizedBox(height: 48),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: local.already_have_an_account,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: provider.isDark()
                              ? Colors.white
                              : Color(0xff686868),
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: 3)),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(PagesRouteName.signIn);
                          },
                          child: Text(
                            local.login,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.primaryColor,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        endIndent: 20,
                        thickness: 0.5,
                        color: provider.isDark()
                            ? theme.primaryColor
                            : Color(0x70686868),
                      ),
                    ),
                    Text(
                      local.or,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 20,
                        thickness: 0.5,
                        color: provider.isDark()
                            ? theme.primaryColor
                            : Color(0x70686868),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: provider.isDark()
                        ? AppColors.unSelectedItem
                        : Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: provider.isDark()
                            ? AppColors.strokeBorder
                            : AppColors.strokeColor,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await GoogleAuthServices.signInWithGoogle();

                      if (!mounted) return;

                      Navigator.pushReplacementNamed(
                        context,
                        PagesRouteName.home,
                      );

                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Google login failed")),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.googleImg.image(width: 24, height: 24),
                        SizedBox(width: 10),
                        Text(
                          local.sign_up_with_google,
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
