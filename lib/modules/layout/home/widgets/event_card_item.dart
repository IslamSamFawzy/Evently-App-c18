import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/firebase_utils/firestore_utils.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/models/event_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventCardItem extends StatefulWidget {
  final EventData eventData;
  final Set<String>? favIds;

  const EventCardItem({super.key, required this.eventData, this.favIds});

  @override
  State<EventCardItem> createState() => _EventCardItemState();
}

class _EventCardItemState extends State<EventCardItem> {

  @override
  Widget build(BuildContext context) {
    bool isFav = widget.favIds?.contains(widget.eventData.eventID ?? "") ?? false;
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PagesRouteName.eventDetails,
          arguments: widget.eventData, // ✔️ هنا صح
        );
      },
      child: Container(
        height: 220,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: provider.isDark()
                ? AppColors.strokeBorder
                : AppColors.strokeColor,
          ),
          image: DecorationImage(
            image: AssetImage(getImageByTheme(widget.eventData.eventCategoryImage, provider.isDark()),),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: provider.isDark()
                    ? AppColors.scaffoldDarkBackgroundColor
                    : Color(0xffF4F7FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.isDark()
                      ? AppColors.strokeBorder
                      : AppColors.strokeColor,
                ),
              ),
              child: Text(
                DateFormat("dd MMM").format(widget.eventData.eventDate),
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: provider.isDark()
                      ? AppColors.primaryDark
                      : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: provider.isDark()
                    ? AppColors.scaffoldDarkBackgroundColor
                    : Color(0xffF4F7FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.isDark()
                      ? AppColors.strokeBorder
                      : AppColors.strokeColor,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    widget.eventData.eventTitle,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: provider.isDark()
                          ? AppColors.mainDarkText
                          : AppColors.mainText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async{
                      await FirestoreUtils.toggleFavourite(widget.eventData);
                    },
                    child: isFav
                        ? Assets.icons.heartFilled.svg(
                      colorFilter: ColorFilter.mode(
                        provider.isDark()
                            ? AppColors.primaryDark
                            : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    )
                        : Assets.icons.heart.svg(
                      colorFilter: ColorFilter.mode(
                        provider.isDark()
                            ? AppColors.primaryDark
                            : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getImageByTheme(String basePath, bool isDark) {
    if (!isDark) return basePath;

    return basePath.replaceFirst('.png', '_dark.png');
  }
}
