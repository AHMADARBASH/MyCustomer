class Customer {
  int? id;
  String? name;
  int? isActive;
  int? paid;
  DateTime? paymentDate;
  DateTime? subscriptionExpireDate;
  int? totalAccounts;
  String? phoneNumber;
  double? fee;

  Customer({
    this.id,
    required this.isActive,
    required this.name,
    required this.paid,
    required this.paymentDate,
    required this.subscriptionExpireDate,
    required this.totalAccounts,
    required this.fee,
    this.phoneNumber,
  });

  Customer.fromJson(Map<String, dynamic> customer) {
    id = customer['id'];
    name = customer['name'];
    isActive = customer['isActive'];
    paid = customer['paid'];
    if (customer['paymentDate'] != 'null') {
      paymentDate = DateTime.parse(customer['paymentDate']);
    }
    subscriptionExpireDate = DateTime.parse(customer['subscriptionExpireDate']);
    totalAccounts = customer['totalAccounts'];
    fee = double.parse(customer['fee'].toString());
    if (customer['phoneNumber'] != 'null' || customer['phoneNumber'] != null) {
      phoneNumber = customer['phoneNumber'];
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> object = {};
    object['id'] = id;
    object['name'] = name;
    object['paid'] = paid;
    object['paymentDate'] = paymentDate.toString();
    object['isActive'] = isActive;
    object['subscriptionExpireDate'] = subscriptionExpireDate.toString();
    object['totalAccounts'] = totalAccounts;
    object['fee'] = fee;
    object['phoneNumber'] = phoneNumber;
    return object;
  }
}
