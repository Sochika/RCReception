import 'package:attendance/responsive.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';


class MarkAttend extends StatelessWidget {
  const MarkAttend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;
    TextEditingController keyNumMController = TextEditingController();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90.0,
              width: 180,
              child: TextField(
                decoration: const InputDecoration(labelText: 'Key Number'),
                controller: keyNumMController,
                // textInputAction: TextInputAction.,

              ),
            ), const SizedBox(width: defaultPadding),

            // Text(
            //   "My Files",
            //   style: Theme.of(context).textTheme.titleMedium,
            // ),
            // ElevatedButton.icon(
            //   style: TextButton.styleFrom(
            //
            //     padding: EdgeInsets.symmetric(
            //       horizontal: defaultPadding * 1.5,
            //       vertical:
            //       defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            //     ),
            //   ),
            //   onPressed: () {},
            //   icon: Icon(Icons.arrow_downward),
            //   label: Text("PDF"),
            // ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add New"),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        // Responsive(
        //   mobile: FileInfoCardGridView(
        //     crossAxisCount: _size.width < 650 ? 2 : 4,
        //     childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
        //   ),
        //   tablet: FileInfoCardGridView(),
        //   desktop: FileInfoCardGridView(
        //     childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
        //   ),
        // ),
      ],
    );
  }
}