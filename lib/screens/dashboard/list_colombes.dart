import 'package:attendance/responsive.dart';
import 'package:attendance/screens/dashboard/components/colombe_records.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';
import 'action/importMembers.dart';
import 'components/header.dart';


import 'components/members_records.dart';
import 'components/statistic_details.dart';

class ColombeList extends StatelessWidget {
  const ColombeList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(title: 'Colombe List',),
            const SizedBox(height: defaultPadding),
            // const ImportMembers(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // MyFiles(),
                      // SizedBox(height: defaultPadding),
                      // MarkAttend(),
                      const SizedBox(height: defaultPadding),
                      ColombeRecord(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StatisticDetails(),
                    ],
                  ),
                ),
                // if (!Responsive.isMobile(context))
                //   const SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we don't want to show it
                // if (!Responsive.isMobile(context))
                //   const Expanded(
                //     flex: 2,
                //     child: StatisticDetails(),
                //   ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
