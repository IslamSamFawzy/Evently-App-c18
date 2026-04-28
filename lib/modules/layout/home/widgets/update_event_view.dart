import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/services/notification_service.dart';
import 'package:evenrly/core/utils/firebase_utils/firestore_utils.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/core/widgets/custom_app_bar.dart';
import 'package:evenrly/core/widgets/custom_button_widget.dart';
import 'package:evenrly/core/widgets/custom_text_form_filed.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:evenrly/models/category_data.dart';
import 'package:evenrly/models/event_data.dart';
import 'package:evenrly/modules/create_event/widgets/tab_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateEventView extends StatefulWidget {
  final EventData eventData;
  const UpdateEventView({super.key, required this.eventData});

  @override
  State<UpdateEventView> createState() => _UpdateEventViewState();
}

class _UpdateEventViewState extends State<UpdateEventView> {
  bool isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstLoad) {
      final event = widget.eventData;

      _eventTitle.text = event.eventTitle;
      _eventDescription.text = event.eventDescription;
      chosenDate = event.eventDate;
      chosenTime = event.eventTime;

      final provider = Provider.of<AppSettingsController>(
        context,
        listen: false,
      );
      final local = AppLocalizations.of(context)!;
      final List<CategoryData> categoriesList = [
        CategoryData(
          id: "sport",
          name: local.sport,
          icon: Assets.icons.bike.path,
          image: provider.isDark()
              ? Assets.images.sportDark.path
              : Assets.images.sport.path,
        ),
        CategoryData(
          id: "birthday",
          name: local.birthday,
          icon: Assets.icons.birthdayCake.path,
          image: provider.isDark()
              ? Assets.images.birthdayDark.path
              : Assets.images.birthday.path,
        ),
        CategoryData(
          id: "book_club",
          name: local.book_club,
          icon: Assets.icons.book.path,
          image: provider.isDark()
              ? Assets.images.bookClubDark.path
              : Assets.images.bookClub.path,
        ),
        CategoryData(
          id: "meeting",
          name: local.meeting,
          icon: Assets.icons.meeting.path,
          image: provider.isDark()
              ? Assets.images.meetingDark.path
              : Assets.images.meeting.path,
        ),
        CategoryData(
          id: "exhibition",
          name: local.exhibition,
          icon: Assets.icons.exhibition.path,
          image: provider.isDark()
              ? Assets.images.exhibitionDark.path
              : Assets.images.exhibition.path,
        ),
      ];
      selectedIndex = categoriesList.indexWhere(
        (cat) => cat.id == event.eventCategory,
      );

      if (selectedIndex == -1) selectedIndex = 0;

      isFirstLoad = false;
    }
  }

  int selectedIndex = 0;
  DateTime? chosenDate;
  TimeOfDay? chosenTime;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _eventTitle = TextEditingController();
  final TextEditingController _eventDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    final local = AppLocalizations.of(context)!;
    final List<CategoryData> categoriesList = [
      CategoryData(
        id: "sport",
        name: local.sport,
        icon: Assets.icons.bike.path,
        image: Assets.images.sport.path,
      ),
      CategoryData(
        id: "birthday",
        name: local.birthday,
        icon: Assets.icons.birthdayCake.path,
        image: Assets.images.birthday.path,
      ),
      CategoryData(
        id: "book_club",
        name: local.book_club,
        icon: Assets.icons.book.path,
        image: Assets.images.bookClub.path,
      ),
      CategoryData(
        id: "meeting",
        name: local.meeting,
        icon: Assets.icons.meeting.path,
        image: Assets.images.meeting.path,
      ),
      CategoryData(
        id: "exhibition",
        name: local.exhibition,
        icon: Assets.icons.exhibition.path,
        image: Assets.images.exhibition.path,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: CustomAppBar(),
        title: Text(
          local.edit_event,
          style: TextStyle(
            color: provider.isDark() ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: Image.asset(
                    getImageByTheme(
                      categoriesList[selectedIndex].image!,
                      provider.isDark(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DefaultTabController(
                  length: categoriesList.length,
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    labelPadding: EdgeInsets.symmetric(horizontal: 6),
                    indicator: BoxDecoration(),
                    dividerColor: Colors.transparent,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    isScrollable: true,
                    tabs: List.generate(categoriesList.length, (index) {
                      return TabItemWidget(
                        data: categoriesList[index],
                        isSelected:
                            selectedIndex ==
                            categoriesList.indexOf(categoriesList[index]),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  local.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                CustomTextFormFiled(
                  maxLines: 1,
                  controller: _eventTitle,
                  hintText: local.event_title,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return local.please_enter_event_title;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  local.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                CustomTextFormFiled(
                  controller: _eventDescription,
                  hintText: local.event_description,
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return local.please_enter_event_description;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  spacing: 8,
                  children: [
                    Assets.icons.calendarAdd.svg(
                      colorFilter: ColorFilter.mode(
                        provider.isDark()
                            ? AppColors.primaryDark
                            : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      local.event_date,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        chooseDate();
                      },
                      child: Text(
                        chosenDate != null
                            ? DateFormat('dd MMM yyyy').format(chosenDate!)
                            : local.choose_date,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.primaryColor,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  spacing: 8,
                  children: [
                    Assets.icons.clock.svg(
                      colorFilter: ColorFilter.mode(
                        provider.isDark()
                            ? AppColors.primaryDark
                            : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      local.event_time,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        chooseTime();
                      },
                      child: Text(
                        chosenTime != null
                            ? chosenTime!.format(context)
                            : local.choose_time,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.primaryColor,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                CustomButtonWidget(
                  buttonTitle: local.update_event,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (chosenDate == null || chosenTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(local.please_choose_date_and_time),
                          ),
                        );
                        return;
                      }
                      try {
                        int notificationId =
                            widget.eventData.notificationId ??
                                DateTime.now().millisecondsSinceEpoch ~/ 1000;

                        final updatedData = EventData(
                          eventID: widget.eventData.eventID,
                          userId: widget.eventData.userId,
                          eventTitle: _eventTitle.text,
                          eventDescription: _eventDescription.text,
                          eventDate: chosenDate!,
                          eventTime: chosenTime!,
                          eventCategory: categoriesList[selectedIndex].id,
                          eventCategoryImage: categoriesList[selectedIndex].image!,
                          notificationId: notificationId,
                        );

                        // 🟡 update DB
                        await FirestoreUtils.updateEvent(updatedData);

                        // 🟡 احسب الوقت
                        final eventDateTime = DateTime(
                          chosenDate!.year,
                          chosenDate!.month,
                          chosenDate!.day,
                          chosenTime!.hour,
                          chosenTime!.minute,
                        );

                        // ❌ امسح القديم
                        await NotificationService.cancelNotification(notificationId);
                        await NotificationService.cancelNotification(notificationId + 1);

                        // ⏰ اعمل الجديد
                        await NotificationService.scheduleNotification(
                          id: notificationId,
                          title: _eventTitle.text,
                          body: _eventDescription.text,
                          dateTime: eventDateTime,
                        );

                        // 🔔 reminder
                        await NotificationService.scheduleNotification(
                          id: notificationId + 1,
                          title: "Upcoming Event",
                          body: _eventTitle.text,
                          dateTime: eventDateTime.subtract(Duration(minutes: 10)),
                        );

                        // 🟢 رجوع
                        if (!mounted) return;
                        Navigator.pop(context);

                      } catch (e, stack) {
                        debugPrint("Update Error: $e");
                        debugPrint("Stack: $stack");

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Update failed")),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> chooseDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    setState(() {
      chosenDate = selectedDate;
    });
  }

  Future<void> chooseTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      chosenTime = selectedTime;
    });
  }

  String getImageByTheme(String basePath, bool isDark) {
    if (!isDark) return basePath;
    return basePath.replaceFirst('.png', '_dark.png');
  }
}
