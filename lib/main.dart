import 'package:flutter/material.dart';
import 'package:shoppin_app_provider_implement/screens/screens.dart';
import './screens/product_overview_screen.dart';
import './providers/provider.dart';
import 'package:provider/provider.dart';
import './screens/screens.dart';

void main() {
  runApp(
      MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName:(ctx) => UserProductScreen(),
            EditProductScreen.routeName:(ctx) => EditProductScreen(),
          },
        ),
      );
  }
}

