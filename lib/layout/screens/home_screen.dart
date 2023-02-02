// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_customer/blocs/Theme/theme_cubit.dart';
import 'package:my_customer/blocs/customer/customers_cubit.dart';
import 'package:my_customer/blocs/customer/customers_state.dart';
import 'package:my_customer/data/local/sharedPreferences_helper.dart';
import 'package:my_customer/layout/screens/active_customers_screen.dart';
import 'package:my_customer/layout/screens/search_screen.dart';
import 'package:my_customer/layout/screens/susped_customers_screen.dart';
import 'package:my_customer/layout/widgets/alret_dialog.dart';
import 'package:my_customer/layout/widgets/custom_snackbar.dart';
import 'package:my_customer/layout/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../data/models/customer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final customerPhoneNumberController = TextEditingController();
  final paymentAmountController = TextEditingController();
  final totalAccountsController = TextEditingController();
  final newNameController = TextEditingController();
  bool paidSwitchValue = false;
  DateTime validtoDate = DateTime.now();

  IconData fabIcon = Icons.add;
  bool isBottomSheetShown = false;
  void showBottomSheet(
      BuildContext context, StateSetter newSetState, Color primaryColor) {
    _scaffoldKey.currentState!
        .showBottomSheet(
          (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: 41.h,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(
                              height: 25,
                            ),
                            CustomTextField(
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                              controller: customerNameController,
                              hint: 'customer name',
                              textAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter a user name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                              controller: customerPhoneNumberController,
                              hint: 'customer phone',
                              textAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    borderColor:
                                        Theme.of(context).colorScheme.secondary,
                                    controller: paymentAmountController,
                                    hint: 'payment amount',
                                    textAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter a valid amout';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomTextField(
                                    borderColor:
                                        Theme.of(context).colorScheme.secondary,
                                    controller: totalAccountsController,
                                    hint: 'total accounts',
                                    textAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter a valid amout';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      height: 8.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, switchState) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Paied',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Switch.adaptive(
                                                activeColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                value: paidSwitchValue,
                                                onChanged: (value) {
                                                  switchState(
                                                    () =>
                                                        paidSwitchValue = value,
                                                  );
                                                }),
                                          ],
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: StatefulBuilder(
                                    builder: (context, dateState) => Container(
                                      height: 8.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Valid to',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(DateFormat('yyyy-MM-dd')
                                              .format(validtoDate)),
                                          IconButton(
                                              onPressed: () async {
                                                final selectedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2020),
                                                        lastDate:
                                                            DateTime(2100));
                                                dateState(
                                                  () => validtoDate =
                                                      selectedDate ??
                                                          DateTime.now(),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.calendar_month,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          enableDrag: true,
        )
        .closed
        .then((value) {
          customerNameController.clear();
          paymentAmountController.clear();
          totalAccountsController.clear();
          customerPhoneNumberController.clear();
          paidSwitchValue = false;
          validtoDate = DateTime.now();
          newSetState(
            () {
              isBottomSheetShown = false;
              fabIcon = Icons.add;
            },
          );
        });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await CustomerCubit.get(context).validateActiveCustomers();
      await CustomerCubit.get(context).getTotalCustomersCount();
      await CustomerCubit.get(context).getActiveCustomers();
      await CustomerCubit.get(context).getSuspendAccounts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = CustomerCubit.get(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.style,
                color: !CachedData.containsTheme()
                    ? Colors.white
                    : CachedData.getTheme() == 'blueTheme'
                        ? Colors.white
                        : CachedData.getTheme() == 'darkTheme'
                            ? Colors.white
                            : Colors.black,
              ),
              title: Text(
                'Change App Theme',
                style: TextStyle(
                  color: !CachedData.containsTheme()
                      ? Colors.white
                      : CachedData.getTheme() == 'blueTheme'
                          ? Colors.white
                          : CachedData.getTheme() == 'darkTheme'
                              ? Colors.white
                              : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text('Pick a theme'),
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            ListTile(
                                title: const Text('white Theme'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  ThemeCubit.get(context)
                                      .changeTheme(themeName: 'whiteTheme');
                                  setState(() {});
                                },
                                trailing: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.blue, width: 3)))),
                            // ListTile(
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //     ThemeCubit.get(context)
                            //         .changeTheme(themeName: 'darkTheme');
                            //     setState(() {});
                            //   },
                            //   title: const Text('Dark Theme'),
                            //   trailing: Container(
                            //       width: 50,
                            //       height: 50,
                            //       decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           color: Colors.black,
                            //           border: Border.all(
                            //               color: Colors.blue, width: 3))),
                            // ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).pop();
                                ThemeCubit.get(context)
                                    .changeTheme(themeName: 'blueTheme');
                                setState(() {});
                              },
                              title: const Text('Blue Theme'),
                              trailing: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff30475E),
                                      border: Border.all(
                                          color: Colors.blue, width: 3))),
                            ),
                          ]),
                        ));
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.dehaze,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text('My Customer'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(SearchScreen.routeName)
                    .then((value) {
                  cubit.allCustomers.clear();
                  cubit.getTotalCustomersCount();
                  cubit.getActiveCustomers();
                  cubit.getSuspendAccounts();
                });
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: BlocConsumer<CustomerCubit, CustomersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CustomersLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      const Expanded(
                          flex: 2,
                          child: Center(
                              child: Icon(
                            Icons.groups,
                            color: Colors.blue,
                            size: 60,
                          ))),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Customers',
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                            state is CustomersValidatingState
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    cubit.totalCustomersCount.toString(),
                                    style: TextStyle(fontSize: 15.sp),
                                  )
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ActiveCustomersScreen.routeName)
                          .then((value) {
                        cubit.getSuspendAccounts();
                        cubit.getActiveCustomers();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.10,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        const Expanded(
                            flex: 2,
                            child: Center(
                                child: Icon(
                              Icons.play_arrow,
                              color: Colors.greenAccent,
                              size: 60,
                            ))),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Active Customers',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              state is CustomersValidatingState
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      cubit.activeCustomers.length.toString(),
                                      style: TextStyle(fontSize: 15.sp),
                                    )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(SuspendAccountsScreen.routeName)
                        .then((value) {
                      cubit.getSuspendAccounts();
                      cubit.getActiveCustomers();
                    }),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.10,
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        const Expanded(
                            flex: 2,
                            child: Center(
                                child: Icon(
                              Icons.pause,
                              color: Colors.orangeAccent,
                              size: 60,
                            ))),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Suspend Customers',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              state is CustomersValidatingState
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      cubit.suspendCustomers.length.toString(),
                                      style: TextStyle(fontSize: 15.sp),
                                    )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: BlocConsumer<CustomerCubit, CustomersState>(
          listener: (context, state) {},
          builder: (context, state) {
            return StatefulBuilder(
              builder: (context, newSetState) => FloatingActionButton(
                  onPressed: () async {
                    newSetState(() => () {});
                    if (!isBottomSheetShown) {
                      isBottomSheetShown = true;
                      fabIcon = Icons.save;
                      showBottomSheet(context, newSetState,
                          Theme.of(context).colorScheme.primary);
                    } else {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      } else {
                        _formKey.currentState!.save();
                        try {
                          await cubit
                              .insertCustomer(
                                  c: Customer(
                                      name: customerNameController.text,
                                      isActive: 1,
                                      paid: paidSwitchValue ? 1 : 0,
                                      paymentDate: paidSwitchValue
                                          ? DateTime.now()
                                          : null,
                                      subscriptionExpireDate: validtoDate,
                                      totalAccounts: int.parse(
                                          totalAccountsController.text),
                                      phoneNumber:
                                          customerPhoneNumberController.text,
                                      fee: double.parse(
                                          paymentAmountController.text)))
                              .then((value) => cubit.getActiveCustomers());

                          customSnackBar(
                            context: context,
                            content: 'Customer addedd Successfully',
                          );
                        } catch (_) {
                          showInfoDialog(
                              context: context,
                              title: 'Error',
                              content: 'an Error occured');
                        }
                        newSetState(
                          () {
                            Navigator.of(context).pop();
                            fabIcon = Icons.add;
                            isBottomSheetShown = false;
                          },
                        );
                      }
                    }
                  },
                  child: state is CustomersLoadingState
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Icon(fabIcon)),
            );
          }),
    );
  }
}
