import 'package:flutter/material.dart';
import 'package:my_customer/blocs/customer/customers_cubit.dart';
import 'package:my_customer/blocs/customer/customers_state.dart';
import 'package:my_customer/data/models/customer.dart';
import 'package:my_customer/layout/widgets/alret_dialog.dart';
import 'package:my_customer/layout/widgets/customer_widget.dart';
import 'package:my_customer/layout/widgets/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SuspendAccountsScreen extends StatefulWidget {
  static const String routeName = '/SuspendAccountsScreens';
  const SuspendAccountsScreen({super.key});

  @override
  State<SuspendAccountsScreen> createState() => _SuspendAccountsScreenState();
}

class _SuspendAccountsScreenState extends State<SuspendAccountsScreen> {
  @override
  void initState() {
    CustomerCubit.get(context).getSuspendAccounts();
    super.initState();
  }

  DateTime validtoDate = DateTime.now();
  Future<void> deleteCustomer(
      {required BuildContext context, required int itemIndex}) async {
    final cCubit = CustomerCubit.get(context);
    showDialog(
      context: context,
      builder: (context) => showConfirmationDialog(
        context: context,
        title: 'Delete!',
        content:
            'Are you sure to delete ${cCubit.suspendCustomers[itemIndex].name}\'s profile?',
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
              customerId: cCubit.suspendCustomers[itemIndex].id!);
          cCubit.suspendCustomers.removeAt(itemIndex);
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
            'do you want to renew ${cCubit.suspendCustomers[index].name}\'s subscription?',
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
          if (selectedDate == null) {
            Navigator.of(context).pop();
            return;
          }
          validtoDate = selectedDate;
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
          cCubit.suspendCustomers[index].subscriptionExpireDate = validtoDate;
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
          title: const Text('Suspend Accounts'),
        ),
        body: BlocConsumer<CustomerCubit, CustomersState>(
            listener: (context, state) {},
            builder: (context, state) => state is CustomersLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : cCubit.suspendCustomers.isEmpty
                    ? Center(
                        child: Text(
                          'you don\'t have suspend accounts',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  itemCount: cCubit.suspendCustomers.length,
                                  itemBuilder: ((context, index) {
                                    return CustomerWidget(
                                      isSuspend: true,
                                      customerKey: ValueKey<int>(index),
                                      id: cCubit.suspendCustomers[index].id,
                                      customerName:
                                          cCubit.suspendCustomers[index].name,
                                      totalAccounts: cCubit
                                          .suspendCustomers[index]
                                          .totalAccounts,
                                      fee: cCubit.suspendCustomers[index].fee,
                                      paid: cCubit.suspendCustomers[index].paid,
                                      validDate: cCubit.suspendCustomers[index]
                                          .subscriptionExpireDate,
                                      deleteAction: (context) {
                                        deleteCustomer(
                                            context: context, itemIndex: index);
                                      },
                                      renewAction: (context) async {
                                        await renewSubscription(
                                            context: context,
                                            customerId: cCubit
                                                .suspendCustomers[index].id!,
                                            subscriptionExpireDate: cCubit
                                                .suspendCustomers[index]
                                                .subscriptionExpireDate!,
                                            index: index);
                                      },
                                      suspenseAction: (context) async {
                                        await toggleAccountStatus(
                                            context: context,
                                            customerId: cCubit
                                                .suspendCustomers[index].id!,
                                            accountStatus: cCubit
                                                .suspendCustomers[index]
                                                .isActive!);
                                        cCubit.suspendCustomers.removeAt(index);
                                      },
                                      paymentStatusFunction: () async {
                                        try {
                                          await togglePaymentStatus(
                                              context: context,
                                              customerId: cCubit
                                                  .suspendCustomers[index].id!,
                                              paymentStatus: cCubit
                                                  .suspendCustomers[index]
                                                  .paid!);
                                          if (cCubit.suspendCustomers[index]
                                                  .paid ==
                                              1) {
                                            cCubit.suspendCustomers[index]
                                                .paid = 0;
                                          } else {
                                            cCubit.suspendCustomers[index]
                                                .paid = 1;
                                          }
                                        } catch (e) {
                                          showInfoDialog(
                                              context: context,
                                              title: 'Error',
                                              content: 'an error occured');
                                        }
                                      },
                                    );
                                  })),
                            ),
                          ),
                        ],
                      )));
  }
}
