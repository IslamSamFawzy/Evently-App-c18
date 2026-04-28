import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/firebase_utils/firebase_auth.dart';
import 'package:evenrly/core/utils/firebase_utils/google_auth_services.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/core/widgets/custom_button_widget.dart';
import 'package:evenrly/core/widgets/custom_text_form_filed.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Assets.images.eventlyLogoImg.image(
          width: 142,
          color: theme.primaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  local.login_to_your_account,
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
                      return local.enter_your_email;
                    } else if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return local.enter_a_valid_email;
                    } else {
                      return null;
                    }
                  },
                  controller: _emailAddress,
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
                  controller: _password,
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enter_your_password;
                    } else if (value.length < 6) {
                      return local.password_must_be_at_least_6_characters;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PagesRouteName.forgetPassword);
                  },
                  child: Text(
                    local.forget_password,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.primaryColor,
                      decorationThickness: 2,
                    ),
                  ),
                ),
                SizedBox(height: 48),
                CustomButtonWidget(
                  buttonTitle: local.login,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                      bool success = await FirebaseAuthUtils.signInWithEmailAndPassword(
                        _emailAddress.text,
                        _password.text,
                      );

                      if (!mounted) return;

                      if (success) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          PagesRouteName.home,
                              (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Email or password is incorrect"),
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 48),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: local.don_t_have_an_account,
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
                            Navigator.of(
                              context,
                            ).pushNamed(PagesRouteName.signUp);
                          },
                          child: Text(
                            local.sign_up,
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
                          local.login_with_google,
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
