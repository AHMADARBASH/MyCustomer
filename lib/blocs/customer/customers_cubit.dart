// ignore_for_file: depend_on_referenced_packages, unused_local_variable, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_customer/data/local/database_helper.dart';
import 'package:my_customer/data/models/customer.dart';
import 'package:my_customer/blocs/customer/customers_state.dart';

class CustomerCubit extends Cubit<CustomersState> {
  CustomerCubit() : super(CustomersInitialState());

  static CustomerCubit get(context) => BlocProvider.of<CustomerCubit>(context);

  List<Customer> activeCustomers = [];
  List<Customer> suspendCustomers = [];
  List<Customer> allCustomers = [];

  int validCustomersCount = 0;
  int totalCustomersCount = 0;

  // Future<void> getSavedCustomers() async {
  //   emit(CustomersLoadingState());
  //   List<Map<String, dynamic>> db_customers =
  //       await DatabaseHelper.getDatafromDatabse();
  //   List<Customer> db_items = [];
  //   db_customers.forEach((e) {
  //     db_items.add(Customer.fromJson(e));
  //     allCustomers = db_items;
  //   });
  //   emit(CustomersLoadedState());
  // }

  Future<void> searchForCustomers({required String customerName}) async {
    emit(CustomersLoadingState());
    List<Customer> _customers = [];
    List<Map<String, dynamic>> data = await DatabaseHelper.getDatafromDatabse(
        query: 'select * from customer where name like \'%$customerName%\'');
    if (data.isNotEmpty) {
      data.forEach((e) {
        _customers.add(Customer.fromJson(e));
      });
    }
    allCustomers = _customers;
    emit(CustomersLoadedState());
  }

  void refresh() {
    // emit(CustomersLoadingState());
    emit(CustomersLoadedState());
  }

  Future<void> getSuspendAccounts() async {
    emit(CustomersLoadingState());
    List<Map<String, dynamic>> data = await DatabaseHelper.getDatafromDatabse(
        query: 'Select * from Customer where isActive = 0');
    List<Customer> customers = [];
    data.map((e) => customers.add(Customer.fromJson(e))).toList();
    suspendCustomers = customers;
    emit(CustomersLoadedState());
  }

  Future<void> getAllCsutomers() async {
    emit(CustomersLoadingState());
    List<Customer> customers = [];
    final List<Map<String, dynamic>> data =
        await DatabaseHelper.instance.rawQuery('Select * from Customer');
    data.forEach((e) => customers.add(Customer.fromJson(e)));
    activeCustomers = customers;

    emit(CustomersLoadedState());
  }

  Future<void> getActiveCustomers() async {
    emit(CustomersLoadingState());
    List<Customer> customers = [];
    final List<Map<String, dynamic>> data = await DatabaseHelper.instance
        .rawQuery('SELECT * FROM Customer where isActive = 1');
    data.forEach((e) => customers.add(Customer.fromJson(e)));
    activeCustomers = customers;
    emit(CustomersLoadedState());
  }

  Future<void> deleteSuspendAccount({required int cusomerId}) async {
    emit(CustomersLoadedState());
    await DatabaseHelper.instance
        .rawQuery('Delete From customer where id = $cusomerId');
    suspendCustomers.removeWhere(
      (element) => element.id == cusomerId,
    );
    await getValidCustomerCount(currentDate: DateTime.now());
    await getTotalCustomersCount();
    emit(CustomersLoadedState());
  }

  Future<void> insertCustomer({required Customer c}) async {
    emit(CustomersLoadingState());
    DatabaseHelper.insertIntoDatabase(c: c);
    await getTotalCustomersCount();
    await getValidCustomerCount(currentDate: DateTime.now());
    emit(CustomersLoadedState());
  }

  Future<void> renewSubscription({
    required int customerId,
    required DateTime subscriptionExpireDate,
  }) async {
    emit(CustomersLoadingState());

    await DatabaseHelper.instance.rawQuery(
        'Update customer set subscriptionExpireDate = \'${subscriptionExpireDate.toString()}\' where id = $customerId');

    await getValidCustomerCount(currentDate: DateTime.now());

    emit(CustomersLoadedState());
  }

  Future<void> togglePaymentStatus(
      {required int customerId, required int paymentStatus}) async {
    emit(CustomersLoadingState());
    await DatabaseHelper.instance.rawQuery(
        'Update customer set paid = $paymentStatus where id = $customerId');
    emit(CustomersLoadedState());
  }

  Future<void> toggleAccountStatus(
      {required int customerId, required int accountStatus}) async {
    emit(CustomersLoadingState());
    await DatabaseHelper.instance.rawQuery(
        'Update customer set isActive = $accountStatus where id = $customerId');
    if (accountStatus == 0) {
      activeCustomers.removeWhere((element) => element.id == customerId);
    }

    await getValidCustomerCount(currentDate: DateTime.now());
  }

  Future<void> deleteCustomer({required int customerId}) async {
    emit(CustomersLoadingState());
    DatabaseHelper.deleteFromDatabase(c: customerId);
    await getValidCustomerCount(currentDate: DateTime.now());
  }

  Future<void> getValidCustomerCount({required DateTime currentDate}) async {
    emit(CountValidCustomerState());
    List<Map<String, dynamic>> customers =
        await DatabaseHelper.getDatafromDatabse();
    List<Customer> validCustomers =
        customers.map((e) => Customer.fromJson(e)).toList();
    validCustomers = validCustomers
        .where((element) =>
            element.subscriptionExpireDate!.isAfter(currentDate) &&
            element.isActive == 1)
        .toList();
    validCustomersCount = validCustomers.length;
    await getTotalCustomersCount();
    emit(CustomersLoadedState());
  }

  Future<void> getTotalCustomersCount() async {
    emit(CountValidCustomerState());
    List<Map<String, dynamic>> customers =
        await DatabaseHelper.getDatafromDatabse();
    totalCustomersCount = customers.length;
    emit(CustomersLoadedState());
  }

  Future<void> validateActiveCustomers() async {
    emit(CustomersValidatingState());
    List<Map<String, dynamic>> data = await DatabaseHelper.getDatafromDatabse();
    List<Customer> _allCustomers = [];
    data.forEach((e) {
      _allCustomers.add(Customer.fromJson(e));
    });
    for (int i = 0; i < _allCustomers.length; i++) {
      if (_allCustomers[i].subscriptionExpireDate!.isBefore(DateTime.now())) {
        _allCustomers[i].isActive = 0;
      }
    }
    for (int i = 0; i < _allCustomers.length; i++) {
      DatabaseHelper.instance.rawQuery(
          'Update customer set isActive = ${_allCustomers[i].isActive} where id=${_allCustomers[i].id}');
    }
    emit(CustomersLoadedState());
  }
}
