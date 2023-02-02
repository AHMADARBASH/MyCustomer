// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';

Widget? customSnackBar({
  required BuildContext context,
  required String content,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
          content,
        )),
      ],
    ),
    behavior: SnackBarBehavior.fixed,
  ));
}
