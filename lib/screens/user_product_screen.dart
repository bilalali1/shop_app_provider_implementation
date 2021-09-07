import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart';
import '../widgets/widgets.dart';
import './screens.dart';
class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
  await Provider.of<Products>(context,listen: false)
      .fetchAndSetProducts(true);
  }


  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }, icon:const Icon(Icons.add,)),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(context,snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder:(context, productsData, child) => Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
          ),
        ),
      ),
    );
  }
}
