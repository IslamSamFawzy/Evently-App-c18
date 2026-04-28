import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/provider/app_settings_controller.dart';

class CustomTextFormFiled extends StatefulWidget {
  final Widget? prefixIcon;
  final int? maxLines;
  final Widget? suffixIcon;
  final String? hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomTextFormFiled({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.maxLines,
  });

  @override
  State<CustomTextFormFiled> createState() => _CustomTextFormFiledState();
}

bool isPasswordVisible = true;

class _CustomTextFormFiledState extends State<CustomTextFormFiled> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);

    return TextFormField(
      maxLines: widget.maxLines,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.isPassword ? isPasswordVisible : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
          color: provider.isDark() ? Colors.white : Color(0x70686868),
          fontWeight: FontWeight.w400,
        ),
        enabled: true,
        filled: true,
        fillColor: provider.isDark() ? AppColors.unSelectedItem : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: provider.isDark()
                ? AppColors.strokeBorder
                : AppColors.strokeColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: provider.isDark()
                ? AppColors.strokeBorder
                : AppColors.strokeColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: provider.isDark()
                ? AppColors.strokeBorder
                : AppColors.strokeColor,
            width: 1,
          ),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.prefixIcon,
              )
            : null,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: provider.isDark() ? Colors.white : Color(0x50686868),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: widget.suffixIcon,
              ),
      ),
    );
  }
}
