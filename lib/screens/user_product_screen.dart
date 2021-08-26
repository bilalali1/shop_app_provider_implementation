import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart';
import '../widgets/widgets.dart';
import './screens.dart';
class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon:const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context,index){
              return Column(children: [
              UserProductItem(
                  productsData.items[index].id,
              productsData.items[index].title,
                  productsData.items[index].imageUrl),
                Divider(),
              ],
              );
            }),
      ),
    );
  }
}
