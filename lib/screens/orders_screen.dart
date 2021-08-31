import 'package:flutter/material.dart';
import '../providers/provider.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart' as ord;
import '../widgets/widgets.dart';
import '../providers/orders.dart';
class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';


//make this widget statefull
//Future _ordersFuture;
//Future _obtainOrdersFuture() {
//return  Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
//}
  //@override
  //initState(){
    //_obtainFuture = _obtainOrdersFuture();
    //super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('orders');
  //  final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
      future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
        builder: (BuildContext ctx, dataSnapshot){
        if(dataSnapshot.connectionState == ConnectionState.waiting)
          {
            return  Center(child: CircularProgressIndicator());
          }else{
          if(dataSnapshot.error != null){
            return Center(child: Text('An error occurred!'),);
          }
          else{
            return Consumer<Orders>(
              builder: (context,orderData,child) =>  ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder:(context, index){
                    return ord.OrderItem(order: orderData.orders[index],);
                  }
              ),
            );
          }
        }
        },
      ),
    );
  }
}
