import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showInfoDialog(
    {required BuildContext context,
    required String title,
    required String content,
    String boldContent = ''}) async {
  await Future.delayed(Duration.zero);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: RichText(
              text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  children: [
                    TextSpan(text: content),
                    TextSpan(
                        text: boldContent,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ))
                  ]),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                child: const Text(
                  'ok',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ));
}

Widget showConfirmationDialog(
    {required BuildContext context,
    required String title,
    required String content,
    String boldContent = '',
    required Widget elevatedButtonContent,
    required Color elevatedButtonColor,
    required VoidCallback action,
    Color titleColor = Colors.black}) {
  return AlertDialog(
    title: Text(
      title,
      style: TextStyle(color: titleColor),
    ),
    content: RichText(
      text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(text: content),
            TextSpan(
                text: boldContent,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ]),
    ),
    actions: [
      ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
            backgroundColor: elevatedButtonColor,
            textStyle: const TextStyle(color: Colors.white)),
        child: elevatedButtonContent,
      ),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'no',
            style: TextStyle(color: Colors.black),
          ))
    ],
  );
}
