import 'package:app_lembrancas_de_amor/models/admin_users_manager.dart';
import 'package:app_lembrancas_de_amor/models/cart_manager.dart';
import 'package:app_lembrancas_de_amor/models/home_manager.dart';
import 'package:app_lembrancas_de_amor/models/product_manager.dart';
import 'package:app_lembrancas_de_amor/models/user_manager.dart';
import 'package:app_lembrancas_de_amor/screens/address/address.screen.dart';
import 'package:app_lembrancas_de_amor/screens/base/base_screen.dart';
import 'package:app_lembrancas_de_amor/screens/cart/cart_screen.dart';
import 'package:app_lembrancas_de_amor/screens/edit_product/edit_product_screen.dart';
import 'package:app_lembrancas_de_amor/screens/login/login_screen.dart';
import 'package:app_lembrancas_de_amor/screens/product/product_screen.dart';
import 'package:app_lembrancas_de_amor/screens/select_product/select_product_screen.dart';
import 'package:app_lembrancas_de_amor/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';

void main() async {
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
            cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
            create: (_) => AdminUsersManager(),
            lazy: false,
            update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'Lembranças\n de Amor\n Biscuit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 218, 70 , 125),
          scaffoldBackgroundColor: const Color.fromARGB(255, 218, 70 , 125),
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case'/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case'/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case'/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(settings.arguments as Product)
              );
            case'/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen()
              );
            case'/address':
              return MaterialPageRoute(
                  builder: (_) => AddressScreen()
              );
            case'/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                    settings.arguments as Product
                  )
              );
            case'/select_product':
              return MaterialPageRoute(
                  builder: (_) => SelectProductScreen()
              );
            case'/base':
            default :
              return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}

