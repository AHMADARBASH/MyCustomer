// ignore_for_file: depend_on_referenced_packages

import 'package:my_customer/data/models/customer.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _instance;
  static Database get instance => _instance;

  static Future<void> createDatabase() async {
    await openDatabase(
      'customers.db',
      version: 1,
      onCreate: (db, version) async {
        await db
            .execute(
                'CREATE TABLE Customer (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,paid INTEGER,paymentDate TEXT,subscriptionExpireDate TEXT,totalAccounts INTEGER,fee INTEGER NULL,isActive INTEGER,phoneNumber TEXT NULL)')
            .catchError((error) {});
      },
      onOpen: (db) => _instance = db,
    );
  }

  static Future<void> insertIntoDatabase({required Customer c}) async {
    await _instance.insert('customer', {
      'name': c.name,
      'paid': c.paid,
      'paymentDate': c.paymentDate.toString(),
      'subscriptionExpireDate': c.subscriptionExpireDate.toString(),
      'totalAccounts': c.totalAccounts,
      'fee': c.fee,
      'isActive': '1',
      'phoneNumber': c.phoneNumber,
    });
  }

  static Future<void> deleteFromDatabase({required int c}) async {
    await _instance.delete('customer', where: 'id=?', whereArgs: [c]);
  }

  // static Future<void> updateCusomterProfiler(
  //     {required Customer c, required String newName}) async {
  //   final old_data = c.toJson();
  //   old_data['name'] = newName;
  //   await _instance
  //       .update('customer', old_data, where: 'id=?', whereArgs: [c.id!]);
  // }

  static Future<List<Map<String, dynamic>>> getDatafromDatabse(
      {String? query}) async {
    List<Map<String, dynamic>> data = [];
    if (query != null) {
      data = await _instance.rawQuery(query);
    } else {
      data = await _instance.rawQuery('Select * from Customer');
    }
    return data;
  }
}
