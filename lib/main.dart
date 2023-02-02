// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_customer/blocs/Theme/theme_cubit.dart';
import 'package:my_customer/blocs/Theme/theme_state.dart';
import 'package:my_customer/blocs/customer/customers_cubit.dart';
import 'package:my_customer/data/local/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_customer/data/local/sharedPreferences_helper.dart';
import 'package:my_customer/layout/screens/home_screen.dart';
import 'package:my_customer/utilities/routes.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DatabaseHelper.createDatabase();
  await CachedData.init();
  runApp(MyCustomer());
}

class MyCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyCustomerState();
}

class _MyCustomerState extends State<MyCustomer> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MultiBlocProvider(
        providers: [
          BlocProvider<CustomerCubit>(
            create: (context) => CustomerCubit(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocConsumer<ThemeCubit, ThemeState>(
          listener: (context, state) {},
          builder: (context, state) {
            ThemeCubit.get(context).setTheme();
            return MaterialApp(
              theme: ThemeCubit.get(context).appTheme,
              debugShowCheckedModeBanner: false,
              home: const HomeScreen(),
              onGenerateRoute: RouteGenerator.generatedRoute,
            );
          },
        ),
      ),
    );
  }
}
