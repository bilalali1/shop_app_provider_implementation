import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../providers/provider.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavs;
  ProductsGrid(this._showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = _showFavs ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3/2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemCount: products.length,
        itemBuilder: (ctx, index){
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(
                // products[index].id,
                // products[index].title,
                // products[index].imageUrl
            ),
          );
        }
    );
  }
}
