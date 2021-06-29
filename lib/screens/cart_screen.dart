import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart' show Cart;
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
                    label: Text('\$${cart.totalAmount}', style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(onPressed: (){}, child: Text('ORDER NOW',style: TextStyle(color: Theme.of(context).primaryColor,),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Expanded(child: ListView.builder(
            itemBuilder: (context, index){
              return CartItem(
                cart.items.values.toList()[index].id,
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title,
              );
            },

            itemCount: cart.items.length,))

        ],
      ),
    );
  }
}
