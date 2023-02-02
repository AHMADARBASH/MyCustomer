// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:my_customer/blocs/customer/customers_cubit.dart';
import 'package:my_customer/blocs/customer/customers_state.dart';
import 'package:my_customer/layout/widgets/alret_dialog.dart';
import 'package:my_customer/layout/widgets/customer_widget.dart';
import 'package:my_customer/layout/widgets/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/searchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<void> searchCustomer({required String customerName}) async {
    await CustomerCubit.get(context)
        .searchForCustomers(customerName: customerName);
  }

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = CustomerCubit.get(context);
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
          title: const Text('Search for customer')),
      body: BlocConsumer<CustomerCubit, CustomersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CustomersLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, newSetState) => Expanded(
                        child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: searchController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor,
                                      width: 1)),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              hintText: 'customer name',
                              fillColor: Theme.of(context)
                                  .appBarTheme
                                  .backgroundColor!
                                  .withOpacity(0.4),
                              suffixIcon: searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        newSetState(() {
                                          searchController.clear();
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    ),
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                return;
                              }
                              newSetState(() {
                                searchCustomer(
                                    customerName: searchController.text);
                              });
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            }),
                      ),
                    ),
                    cubit.allCustomers.isEmpty
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              cubit.allCustomers.clear();
                              FocusScope.of(context).unfocus();
                              searchController.clear();
                              cubit.refresh();
                            },
                            icon: const Icon(
                              Icons.filter_list_off,
                              color: Colors.white,
                            ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                (state is CustomersLoadingState)
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: cubit.allCustomers.length,
                          itemBuilder: (context, index) => CustomerWidget(
                            customerKey: ValueKey<int>(index),
                            id: cubit.allCustomers[index].id,
                            customerName: cubit.allCustomers[index].name,
                            totalAccounts:
                                cubit.allCustomers[index].totalAccounts,
                            fee: cubit.allCustomers[index].fee,
                            paid: cubit.allCustomers[index].paid,
                            validDate: cubit
                                .allCustomers[index].subscriptionExpireDate,
                            isSuspend: cubit.allCustomers[index].isActive == 1
                                ? false
                                : true,
                            deleteAction: (_) {
                              showDialog(
                                  context: context,
                                  builder: (context) => showConfirmationDialog(
                                      context: context,
                                      title: 'Delete!',
                                      content:
                                          'Are you sure to delete ${cubit.allCustomers[index].name}\'s profile?',
                                      elevatedButtonContent: const Text(
                                        'yes',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      elevatedButtonColor:
                                          Theme.of(context).errorColor,
                                      action: () async {
                                        await cubit.deleteCustomer(
                                            customerId:
                                                cubit.allCustomers[index].id!);
                                        cubit.allCustomers.removeAt(index);
                                        customSnackBar(
                                            context: context,
                                            content:
                                                'customer deleted suessfully');
                                        Navigator.of(context).pop();
                                      }));
                            },
                            renewAction: (_) async {
                              showDialog(
                                  context: context,
                                  builder: (context) => showConfirmationDialog(
                                      context: context,
                                      title: 'Renew subsciption',
                                      content:
                                          'do you want to renew ${cubit.allCustomers[index].name}\'s subscription?',
                                      elevatedButtonContent: const Text(
                                        'yes',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      elevatedButtonColor: Colors.green,
                                      action: () async {
                                        var _selectedDate;
                                        _selectedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100));
                                        if (_selectedDate == null) {
                                          Navigator.of(context).pop();

                                          return;
                                        }

                                        await cubit.renewSubscription(
                                            customerId:
                                                cubit.allCustomers[index].id!,
                                            subscriptionExpireDate:
                                                _selectedDate);
                                        cubit.allCustomers[index]
                                                .subscriptionExpireDate =
                                            _selectedDate;
                                        Navigator.of(context).pop();
                                        customSnackBar(
                                            context: context,
                                            content:
                                                'subscription renewed successfully');
                                      }));
                            },
                            suspenseAction: (_) async {
                              await cubit.toggleAccountStatus(
                                  customerId: cubit.allCustomers[index].id!,
                                  accountStatus:
                                      cubit.allCustomers[index].isActive == 1
                                          ? 0
                                          : 1);
                              if (cubit.allCustomers[index].isActive == 1) {
                                cubit.allCustomers[index].isActive = 0;
                              } else {
                                cubit.allCustomers[index].isActive = 1;
                              }
                            },
                            paymentStatusFunction: () async {
                              await cubit.togglePaymentStatus(
                                  customerId: cubit.allCustomers[index].id!,
                                  paymentStatus:
                                      cubit.allCustomers[index].paid == 1
                                          ? 0
                                          : 1);
                              if (cubit.allCustomers[index].paid == 1) {
                                cubit.allCustomers[index].paid = 0;
                              } else {
                                cubit.allCustomers[index].paid = 1;
                              }
                            },
                          ),
                        ),
                      )
              ]),
            );
          }
        },
      ),
    );
  }
}
