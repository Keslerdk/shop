import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit_product_screen";

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState!.validate()) _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    label: const Text("Title"),
                    errorStyle:
                        Theme.of(context).inputDecorationTheme.errorStyle),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field cant be empty!";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: "",
                      title: value!,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Price")),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field cant be empty!";
                  }

                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) return "Enter valid number";
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: "",
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Description")),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) return "This field can't be empty!";
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: "",
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 10, right: 8),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _imageUrlController.text.isNotEmpty
                        ? Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.fill,
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Image Url")),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: "",
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "This field can't be empty!";
                        if (!value.startsWith("https") &&
                            !value.startsWith("http") &&
                            !value.endsWith(".png") &&
                            !value.endsWith(".jpg")) return "Enter valid url!";
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }
}
