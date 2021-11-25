import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/products_grid.dart';

enum FilterOptions { favourites, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/product_screen";

  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourite = false;
  bool _isInit = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Provider.of<ProductsProvider>(context)
          .fetchAndSetData()
          .then((_) => _isLoading = false);
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: [
          Consumer<Cart>(
              builder: (_, cartData, ch) {
                return Badge(
                    child: ch!,
                    value: cartData.itemCount.toString(),
                    color: Theme.of(context).colorScheme.secondary);
              },
              child: IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, CartScreen.routeName),
                icon: const Icon(Icons.shopping_cart),
              )),
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
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              isFav: _showFavourite,
            ),
    );
  }
}
