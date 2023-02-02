import 'package:flutter/material.dart';
import 'package:my_customer/layout/screens/active_customers_screen.dart';
import 'package:my_customer/layout/screens/home_screen.dart';
import 'package:my_customer/layout/screens/search_screen.dart';
import 'package:my_customer/layout/screens/susped_customers_screen.dart';

class RouteGenerator {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case SuspendAccountsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SuspendAccountsScreen());
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case ActiveCustomersScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const ActiveCustomersScreen(),
        );
      case SearchScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
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
            title: const Text('Error Route')),
        body: const Center(child: Text('Error Route')),
      );
    });
  }
}
