import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return Consumer<Product>(
      builder: (context, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              leading: IconButton(
                icon: Icon(
                  (product.isFavourite)? Icons.favorite: Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => product.toggleFavouriteStatus(),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
