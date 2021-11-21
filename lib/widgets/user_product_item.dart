import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  const UserProductItem(
      {Key? key, required this.title, required this.imgUrl, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id),
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
                onPressed: () {
                  Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ))
          ],
        ),
      ),
    );
  }
}
