import 'package:app_lembrancas_de_amor/models/address.dart';
import 'package:app_lembrancas_de_amor/models/product.dart';
import 'package:app_lembrancas_de_amor/models/user.dart';
import 'package:app_lembrancas_de_amor/models/user_manager.dart';
import 'package:app_lembrancas_de_amor/services/cepaberto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'cart_product.dart';


class CartManager extends ChangeNotifier  {

  List<CartProduct> items = [];

  User user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager){
    user = userManager.user;
    items.clear();
    
    if(user != null){
      _loadCartItems();
    }
  }
  
  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    items = cartSnap.documents.map(
       (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)).toList();
  }

  void addToCart(Product product){
    
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap())
        .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _onItemUpdated(){
    productsPrice = 0.0;
    for(int i = 0; i<items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.id != null)
    user.cartReference.document(cartProduct.id)
        .updateData(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  //ADDRESS

  Future<void> getAddress(String cep) async{
    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude,
        );
        notifyListeners();
      }
    } catch(e){
      debugPrint(e.toString());
    }

  }

  Future<void> setAddress(Address address) async{
    this.address = address;

    if(await calculateDelivery(address.lat, address.long)){
      print('price $deliveryPrice');
      notifyListeners();
    } else {
      return Future.error('Endereço fora do Raio de Entrega :(');
    }

  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxkm'] as num;

    double dis = await Geolocator().distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    print('Distance $dis');

    if(dis > maxkm){
      return false;
    } else {
      deliveryPrice = base + dis * km;
      return true;
    }


  }

}