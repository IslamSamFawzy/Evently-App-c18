import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/firebase_utils/firestore_utils.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:evenrly/models/category_data.dart';
import 'package:evenrly/models/event_data.dart';
import 'package:evenrly/modules/layout/home/widgets/event_card_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/tab_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
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
    final User? user = _user;
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    final local = AppLocalizations.of(context)!;

    final List<CategoryData> categoriesList = [
      CategoryData(id: 'all', name: local.all, icon: Assets.icons.element.path),
      CategoryData(
        id: 'sport',
        name: local.sport,
        icon: Assets.icons.bike.path,
        image: Assets.images.sport.path,
      ),
      CategoryData(
        id: 'birthday',
        name: local.birthday,
        icon: Assets.icons.birthdayCake.path,
        image: Assets.images.birthday.path,
      ),
      CategoryData(
        id: 'book_club',
        name: local.book_club,
        icon: Assets.icons.book.path,
        image: Assets.images.bookClub.path,
      ),
      CategoryData(
        id: 'meeting',
        name: local.meeting,
        icon: Assets.icons.meeting.path,
        image: Assets.images.meeting.path,
      ),
      CategoryData(
        id: 'exhibition',
        name: local.exhibition,
        icon: Assets.icons.exhibition.path,
        image: Assets.images.exhibition.path,
      ),
    ];

    final String? selectedCategory = categoriesList[selectedIndex].id == 'all'
        ? null
        : categoriesList[selectedIndex].id;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Column(
          spacing: 24,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.welcome_back,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.subText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(user?.displayName ?? 'User', style: theme.textTheme.titleLarge),
                  ],
                ),
                const Spacer(),
                Row(
                  spacing: 4,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.setCurrentTheme(
                          provider.isDark() ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                      child: provider.isDark()
                          ? Assets.icons.moon.svg(
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryDark,
                          BlendMode.srcIn,
                        ),
                      )
                          : Assets.icons.sunUnfilled.svg(
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.setCurrentLanguage(
                          provider.isArabic() ? 'en' : 'ar',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: provider.isDark() ? AppColors.primaryDark : AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          provider.isArabic() ? 'AR' : 'EN',
                          style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            DefaultTabController(
              length: categoriesList.length,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                isScrollable: true,
                tabs: List.generate(categoriesList.length, (index) {
                  return TabItem(
                    data: categoriesList[index],
                    isSelected: selectedIndex == index,
                  );
                }),
              ),
            ),
            Expanded(
              child: StreamBuilder<Set<String>>(
                stream: FirestoreUtils.getFavouriteIdsStream(),
                builder: (context, favSnapshot) {
                  if (favSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final favIds = favSnapshot.data ?? <String>{};

                  return StreamBuilder<QuerySnapshot<EventData>>(
                    stream: FirestoreUtils.getEventsStream(category: selectedCategory),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Something went wrong'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text(local.no_data_found));
                      }

                      final List<EventData> dataList =
                      snapshot.data!.docs.map((e) => e.data()).toList();

                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return EventCardItem(eventData: dataList[index], favIds: favIds);
                        },
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemCount: dataList.length,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
