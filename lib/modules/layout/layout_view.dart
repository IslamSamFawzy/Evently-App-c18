import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:evenrly/modules/layout/favorite/favorite_view.dart';
import 'package:evenrly/modules/layout/home/home_view.dart';
import 'package:evenrly/modules/layout/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/provider/app_settings_controller.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [HomeView(), FavoriteView(), ProfileView()];
    var provider = Provider.of<AppSettingsController>(context);
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: provider.isDark() ? AppColors.primaryDark : AppColors.primary,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(100)
        ),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/create_event');
        },),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.home2.svg(
              colorFilter: ColorFilter.mode(AppColors.subText, BlendMode.srcIn),
            ),
            label: local.home,
            activeIcon: Assets.icons.home.svg(
              colorFilter: ColorFilter.mode(
                provider.isDark() ? AppColors.primaryDark : AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.heart.svg(
              colorFilter: ColorFilter.mode(AppColors.subText, BlendMode.srcIn),
            ),
            label: local.favorite,
            activeIcon: Assets.icons.heartFilled.svg(
              colorFilter: ColorFilter.mode(
                provider.isDark() ? AppColors.primaryDark : AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.user.svg(
              colorFilter: ColorFilter.mode(AppColors.subText, BlendMode.srcIn)
            ),
            label: local.profile,
            activeIcon: Assets.icons.userOn.svg(
              colorFilter: ColorFilter.mode(
                provider.isDark() ? AppColors.primaryDark : AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
