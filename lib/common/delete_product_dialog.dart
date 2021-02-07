import 'package:app_lembrancas_de_amor/models/product.dart';
import 'package:app_lembrancas_de_amor/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteProductDialog extends StatelessWidget {

  const DeleteProductDialog(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Deletar ${product.name}?'),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            context.read<ProductManager>().delete(product);
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Deletar Produto'),
        )
      ],
    );

  }
}
