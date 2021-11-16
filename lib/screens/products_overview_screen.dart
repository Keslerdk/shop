import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/products_grid.dart';

enum FilterOptions { favourites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourite = false;

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: [
          Consumer<Cart>(
            builder: (_, cartData, ch ) { return  Badge(
                child: ch!,
                value: cartData.itemCount.toString(),
                color: Theme.of(context).colorScheme.secondary);},
            child:  IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
              )
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text("Only Favourites"),
                value: FilterOptions.favourites,
              ),
              const PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.all,
              ),
            ],
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.all) {
                  _showFavourite = false;
                } else {
                  _showFavourite = true;
                }
              });
            },
          ),
        ],
      ),
      body: ProductsGrid(
        isFav: _showFavourite,
      ),
    );
  }
}
