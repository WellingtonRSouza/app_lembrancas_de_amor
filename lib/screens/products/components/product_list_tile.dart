import 'package:app_lembrancas_de_amor/models/product.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {

  const ProductListTile(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.images.first),
              ),
              SizedBox(width: 16,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                          'A partir de:'
                      ),
                      Text(
                        'R\$ ${product.basePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                      if(!product.hasStock)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Sem estoque',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 10
                            ),
                          ),
                        )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
