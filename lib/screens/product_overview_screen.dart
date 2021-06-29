import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens.dart';
import '../widgets/widgets.dart';
import '../providers/provider.dart';

enum FilterOptions{
  Favourites,
  All
}
class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myShop'),
      actions: [
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue){
            setState(() {
              if(selectedValue == FilterOptions.Favourites){
                _showOnlyFavourite = true;
              }else{
                _showOnlyFavourite = false;
              }
            });
          },
          icon: Icon(
            Icons.more_vert,
          ),
          itemBuilder: (_) => [
          PopupMenuItem(
              child: Text('Only Favourites'),
              value: FilterOptions.Favourites),
          PopupMenuItem(
              child: Text('Show All'),
              value: FilterOptions.All),
        ]),
        Consumer<Cart>(builder:(ctx, cartData, ch) =>
           Badge(
               child: ch,
          value: cartData.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
      ],
      ),
      body: ProductsGrid(_showOnlyFavourite),
    );
  }
}

