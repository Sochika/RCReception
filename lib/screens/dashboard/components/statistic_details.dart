import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../data/sqlite.dart';
import 'storage_info_card.dart';

class StatisticDetails extends StatefulWidget {
  const StatisticDetails({Key? key}) : super(key: key);

  @override
  State<StatisticDetails> createState() => _StatisticDetailsState();
}

class _StatisticDetailsState extends State<StatisticDetails> {
   int numFemales = 0;
   int numMales = 0;

  @override
  void initState() {
    super.initState();
    fetchMemberCounts();
  }

  void fetchMemberCounts() async {
    DatabaseHelper db = DatabaseHelper();
    int femaleCount = await db.getMemberCount(female);
    int maleCount = await db.getMemberCount(male);
    setState(() {
      numFemales = femaleCount;
      numMales = maleCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistics Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          StorageInfoCard(
            svgSrc: "assets/icons/male.svg",
            title: "Males",
            colorSVG: Colors.blue,
            numOfAttendee: numMales,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/female.svg",
            title: "Females",
            colorSVG: Colors.pinkAccent,
            numOfAttendee: numFemales,
          ),
          const StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Officers",
            colorSVG: Colors.greenAccent,
            numOfAttendee: 0,
          ),
          const StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Visitors",
            colorSVG: Colors.blueGrey,
            numOfAttendee: 0,
          ),
        ],
      ),
    );
  }
}
