import 'package:flutter/material.dart';
import '../providers/provider.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart' as ord;
import '../widgets/widgets.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder:(context, index){
            return ord.OrderItem(order: orderData.orders[index],);
          }
          ),
    );
  }
}
