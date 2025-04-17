import 'package:attendance/constants.dart';
import 'package:flutter/material.dart';

import '../../../models/MyFiles.dart';
import 'file_info_card.dart';



class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(events.);
    return FutureBuilder<List<CloudStorageInfo>>(

      future: events,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while fetching events
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<CloudStorageInfo>? eventsList = snapshot.data;
        if (eventsList == null || eventsList.isEmpty) {
          return const Text('No events available'); // Handle case when no events are available
        }
        return Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     ElevatedButton.icon(
            //       onPressed: () {},
            //       icon: const Icon(Icons.arrow_downward),
            //       label: const Text("PDF"),
            //     ),
            //   ],
            // ),
            const SizedBox(height: defaultPadding),
            FileInfoCardGridView(events: eventsList),
          ],
        );
      },
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    required this.events,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final List<CloudStorageInfo> events;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length, // Use events.length as the itemCount
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        // Return FileInfoCard for each index
        return FileInfoCard(info: events[index]);
      },
    );
  }
}

