// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_customer/blocs/Theme/theme_cubit.dart';
import 'package:my_customer/blocs/customer/customers_cubit.dart';
import 'package:my_customer/data/local/sharedPreferences_helper.dart';
import 'package:my_customer/layout/widgets/alret_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class CustomerWidget extends StatefulWidget {
  Key? customerKey;
  int? id;
  String? customerName;
  int? totalAccounts;
  double? fee;
  int? paid;
  DateTime? validDate;
  bool? isSuspend;
  String? phoneNumber;
  VoidCallback? paymentStatusFunction;
  VoidCallback? updateName;
  Function(BuildContext)? deleteAction;
  Function(BuildContext)? renewAction;
  Function(BuildContext)? suspenseAction;
  CustomerWidget({
    required this.customerKey,
    required this.id,
    required this.customerName,
    required this.totalAccounts,
    required this.fee,
    required this.paid,
    required this.validDate,
    required this.isSuspend,
    this.deleteAction,
    this.renewAction,
    this.paymentStatusFunction,
    this.suspenseAction,
    this.updateName,
    this.phoneNumber,
  });

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  String getCurrnetTheme() {
    return CachedData.getTheme()!;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.customerKey!,
      endActionPane: ActionPane(motion: const DrawerMotion(), children: [
        SlidableAction(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            icon: Icons.delete_forever,
            backgroundColor: Theme.of(context).colorScheme.error,
            autoClose: true,
            label: 'Delete',
            onPressed: widget.deleteAction),
        SlidableAction(
            icon: Icons.recycling,
            backgroundColor: Colors.green,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            autoClose: true,
            label: 'Renew',
            onPressed: widget.renewAction),
      ]),
      startActionPane: ActionPane(motion: const DrawerMotion(), children: [
        widget.isSuspend!
            ? SlidableAction(
                borderRadius: BorderRadius.circular(10),
                icon: Icons.play_arrow,
                backgroundColor: Colors.green,
                autoClose: true,
                label: 'Activate',
                onPressed: widget.suspenseAction)
            : SlidableAction(
                borderRadius: BorderRadius.circular(10),
                icon: Icons.pause,
                backgroundColor: Colors.deepOrange[400]!,
                autoClose: true,
                label: 'Suspend',
                onPressed: widget.suspenseAction),
      ]),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        widget.customerName!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: IconButton(
                    onPressed: () {
                      showInfoDialog(
                          context: context,
                          title: 'Phone number',
                          content: widget.phoneNumber ?? 'not available');
                    },
                    icon: Icon(
                      Icons.phone,
                      color: getCurrnetTheme() == 'blueTheme'
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white,
                    ),
                  )),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: widget.paymentStatusFunction,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Paid: ',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color),
                          ),
                          widget.paid == 1
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.cancel_outlined,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).canvasColor,
              endIndent: 15.sp,
              indent: 15.sp,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        FontAwesome5.calendar_check,
                        color: getCurrnetTheme() == 'blueTheme'
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(widget.validDate!),
                        style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                Theme.of(context).textTheme.bodySmall!.color),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.supervisor_account,
                        color: getCurrnetTheme() == 'blueTheme'
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                      ),
                      Text(
                        '${widget.totalAccounts}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                Theme.of(context).textTheme.bodySmall!.color),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        FontAwesome5.money_bill_alt,
                        color: getCurrnetTheme() == 'blueTheme'
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                      ),
                      Text(
                        '${widget.fee}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                Theme.of(context).textTheme.bodySmall!.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
