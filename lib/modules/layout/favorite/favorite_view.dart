import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/firebase_utils/firestore_utils.dart';
import 'package:evenrly/core/widgets/custom_text_form_filed.dart';
import 'package:evenrly/models/event_data.dart';
import 'package:evenrly/modules/layout/home/widgets/event_card_item.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CustomTextFormFiled(
              suffixIcon: Assets.icons.searchNormal.svg(),
              hintText: 'Search For Events',
            ),
            const SizedBox(height: 16),

            /// 🔥 مهم: Expanded هنا
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PagesRouteName.eventDetails);
                },
                child: StreamBuilder(
                  stream: FirestoreUtils.getFavouriteStream(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    /// ✅ تحويل الداتا
                    List<EventData> dataList = snapshot.data!.docs
                        .map((e) => e.data())
                        .toList();

                    Set<String> favIds = snapshot.data!.docs
                        .map((doc) => doc.id)
                        .toSet();

                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return EventCardItem(
                          eventData: dataList[index],
                          favIds: favIds,
                        );
                      },
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                      itemCount: dataList.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}