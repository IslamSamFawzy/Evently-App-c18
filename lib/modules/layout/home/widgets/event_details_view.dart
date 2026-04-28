import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/services/notification_service.dart';
import 'package:evenrly/core/utils/firebase_utils/firestore_utils.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/core/widgets/custom_app_bar.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:evenrly/models/event_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailsView extends StatefulWidget {
  final EventData eventData;

  const EventDetailsView({super.key, required this.eventData});

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final provider = Provider.of<AppSettingsController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomAppBar(),
        title: Text(local.event_details),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PagesRouteName.updateEvent,
                arguments: widget.eventData,
              );
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: provider.isDark()
                    ? AppColors.unSelectedItem
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.isDark()
                      ? AppColors.strokeBorder
                      : AppColors.strokeColor,
                ),
              ),
              child: Assets.icons.edit.svg(
                colorFilter: ColorFilter.mode(
                  provider.isDark() ? AppColors.primaryDark : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final eventId = widget.eventData.eventID.hashCode;
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Event"),
                  content: Text("Are you sure you want to delete this event?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await NotificationService.cancelNotification(eventId);
                await NotificationService.cancelNotification(eventId + 1);
                await FirestoreUtils.deleteEvent(widget.eventData);
                Navigator.pop(context);
              }
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: provider.isDark()
                    ? AppColors.unSelectedItem
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.isDark()
                      ? AppColors.strokeBorder
                      : AppColors.strokeColor,
                ),
              ),
              child: Assets.icons.trash.svg(
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<EventData>(
            stream: FirestoreUtils.getEventById(widget.eventData.eventID!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final event = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        getImageByTheme(event.eventCategoryImage, provider.isDark()),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      event.eventTitle,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: provider.isDark()
                            ? AppColors.mainDarkText
                            : AppColors.mainText,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: provider.isDark()
                            ? AppColors.unSelectedItem
                            : Colors.white,
                        borderRadius: BorderRadiusGeometry.circular(16),
                        border: Border.all(
                          color: provider.isDark()
                              ? AppColors.strokeBorder
                              : AppColors.strokeColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: provider.isDark()
                                    ? AppColors.unSelectedItem
                                    : AppColors.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: provider.isDark()
                                      ? AppColors.strokeBorder
                                      : AppColors.strokeColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Assets.icons.calendarAdd.svg(
                                  colorFilter: ColorFilter.mode(
                                    provider.isDark()
                                        ? AppColors.primaryDark
                                        : AppColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat(
                                    "dd MMMM",
                                  ).format(event.eventDate),
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: provider.isDark()
                                        ? AppColors.mainDarkText
                                        : AppColors.mainText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  event.eventTime.format(context),
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      local.description,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: provider.isDark()
                            ? AppColors.mainDarkText
                            : AppColors.mainText,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: provider.isDark()
                            ? AppColors.unSelectedItem
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: provider.isDark()
                              ? AppColors.strokeBorder
                              : AppColors.strokeColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          event.eventDescription,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
  String getImageByTheme(String basePath, bool isDark) {
    if (!isDark) return basePath;

    return basePath.replaceFirst('.png', '_dark.png');
  }
}
