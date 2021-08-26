import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart' show Cart,Orders;
import '../widgets/widgets.dart';
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
                padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20.0),),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: (){
                    Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                    cart.clearCart();
                    }, child: Text('ORDER NOW',style: TextStyle(color: Theme.of(context).primaryColor,),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Expanded(child: ListView.builder(
            itemBuilder: (context, index){
              return CartItem(
                id:cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title:cart.items.values.toList()[index].title,
              );
            },

            itemCount: cart.items.length,))

        ],
      ),
    );
  }
}
