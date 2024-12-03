/*
USER PROFILE STATS

displayed on all user profile pages:
- number of following
*/

import 'package:flutter/material.dart';

class UserProfileStats extends StatelessWidget {
  final int followingCount;

  const UserProfileStats({
    super.key,
    required this.followingCount,
  });

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // style for count
    var textStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);

    // style for text
    var textStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // following
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                followingCount.toString(),
                style: textStyleForCount,
              ),
              Text(
                "Following",
                style: textStyleForText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
