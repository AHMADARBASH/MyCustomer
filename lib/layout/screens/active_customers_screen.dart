import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_customer/blocs/customer/customers_cubit.dart';
import 'package:my_customer/blocs/customer/customers_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_customer/layout/widgets/alret_dialog.dart';
import 'package:my_customer/layout/widgets/customer_widget.dart';

import 'package:my_customer/layout/widgets/custom_snackbar.dart';
import 'package:sizer/sizer.dart';

class ActiveCustomersScreen extends StatefulWidget {
  static const String routeName = '/ActiveCustomersScreen';
  const ActiveCustomersScreen({super.key});

  @override
  State<ActiveCustomersScreen> createState() => _ActiveCustomersScreenState();
}

class _ActiveCustomersScreenState extends State<ActiveCustomersScreen> {
  DateTime validtoDate = DateTime.now();
  @override
  void initState() {
    CustomerCubit.get(context).getActiveCustomers();
    super.initState();
  }

  Future<void> deleteCustomer(
      {required BuildContext context, required int itemIndex}) async {
    final cCubit = CustomerCubit.get(context);
    showDialog(
      context: context,
      builder: (context) => showConfirmationDialog(
        context: context,
        title: 'Delete!',
        content:
            'Are you sure to delete ${cCubit.activeCustomers[itemIndex].name}\'s profile?',
        elevatedButtonContent: const Text(
          'Yes',
          style: TextStyle(color: Colors.white),
        ),
        elevatedButtonColor: Theme.of(context).colorScheme.error,
        action: () async {
          showDialog(
              context: context,
              builder: (_) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ));

          await cCubit.deleteCustomer(
              customerId: cCubit.activeCustomers[itemIndex].id!);
          cCubit.activeCustomers.removeAt(itemIndex);
          customSnackBar(
              context: context, content: 'Customer deleted Successfully');

          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> renewSubscription(
      {required BuildContext context,
      required int customerId,
      required DateTime subscriptionExpireDate,
      required int index}) async {
    final cCubit = CustomerCubit.get(context);
    showDialog(
      context: context,
      builder: (context) => showConfirmationDialog(
        context: context,
        title: 'Renew',
        content:
            'do you want to renew ${cCubit.activeCustomers[index].name}\'s subscription?',
        elevatedButtonContent: const Text(
          'Yes',
          style: TextStyle(color: Colors.white),
        ),
        elevatedButtonColor: Colors.green,
        action: () async {
          final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));
          validtoDate = selectedDate!;
          showDialog(
              context: context,
              builder: (_) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ));

          await cCubit.renewSubscription(
            subscriptionExpireDate: selectedDate,
            customerId: customerId,
          );

          customSnackBar(context: context, content: 'updated successfully');
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> togglePaymentStatus(
      {required BuildContext context,
      required int customerId,
      required int paymentStatus}) async {
    final cCubit = CustomerCubit.get(context);
    final bit = paymentStatus == 1 ? 0 : 1;
    await cCubit.togglePaymentStatus(
        customerId: customerId, paymentStatus: bit);
  }

  Future<void> toggleAccountStatus(
      {required BuildContext context,
      required int customerId,
      required int accountStatus}) async {
    final cCubit = CustomerCubit.get(context);
    final bit = accountStatus == 1 ? 0 : 1;
    await cCubit.toggleAccountStatus(
        customerId: customerId, accountStatus: bit);
  }

  @override
  Widget build(BuildContext context) {
    final cCubit = CustomerCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text('Active Customers'),
      ),
      body: BlocConsumer<CustomerCubit, CustomersState>(
          listener: (context, state) {},
          builder: (context, state) => state is CustomersLoadingState
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    cCubit.activeCustomers.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45.h,
                              ),
                              Center(
                                child: Text(
                                  'You don\'t have active customers',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  itemCount: cCubit.activeCustomers.length,
                                  itemBuilder: (context, index) =>
                                      CustomerWidget(
                                        isSuspend: cCubit.activeCustomers[index]
                                                    .isActive ==
                                                1
                                            ? false
                                            : true,
                                        customerKey: ValueKey<int>(index),
                                        id: cCubit.activeCustomers[index].id,
                                        customerName:
                                            cCubit.activeCustomers[index].name,
                                        fee: cCubit.activeCustomers[index].fee,
                                        paid:
                                            cCubit.activeCustomers[index].paid,
                                        totalAccounts: cCubit
                                            .activeCustomers[index]
                                            .totalAccounts,
                                        validDate: cCubit.activeCustomers[index]
                                            .subscriptionExpireDate,
                                        phoneNumber: cCubit
                                            .activeCustomers[index].phoneNumber,
                                        deleteAction: (context) {
                                          deleteCustomer(
                                              context: context,
                                              itemIndex: index);
                                        },
                                        renewAction: (context) async {
                                          await renewSubscription(
                                              context: context,
                                              customerId: cCubit
                                                  .activeCustomers[index].id!,
                                              subscriptionExpireDate: cCubit
                                                  .activeCustomers[index]
                                                  .subscriptionExpireDate!,
                                              index: index);
                                        },
                                        suspenseAction: (context) async {
                                          await toggleAccountStatus(
                                              context: context,
                                              customerId: cCubit
                                                  .activeCustomers[index].id!,
                                              accountStatus: cCubit
                                                  .activeCustomers[index]
                                                  .isActive!);
                                        },
                                        paymentStatusFunction: () async {
                                          try {
                                            await togglePaymentStatus(
                                                context: context,
                                                customerId: cCubit
                                                    .activeCustomers[index].id!,
                                                paymentStatus: cCubit
                                                    .activeCustomers[index]
                                                    .paid!);
                                            if (cCubit.activeCustomers[index]
                                                    .paid ==
                                                1) {
                                              cCubit.activeCustomers[index]
                                                  .paid = 0;
                                            } else {
                                              cCubit.activeCustomers[index]
                                                  .paid = 1;
                                            }
                                          } catch (e) {
                                            showInfoDialog(
                                                context: context,
                                                title: 'Error',
                                                content: 'an error occured');
                                          }
                                        },
                                      )),
                            ),
                          ),
                  ],
                )),
    );
  }
}
