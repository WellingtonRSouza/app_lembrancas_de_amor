import 'package:app_lembrancas_de_amor/custom_drawer/custom_drawer.dart';
import 'package:app_lembrancas_de_amor/models/stores_manager.dart';
import 'package:app_lembrancas_de_amor/screens/stores/components/store_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Lojas'),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __){
          if(storesManager.stores.isEmpty){
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          } else {
            return ListView.builder(
              itemCount: storesManager.stores.length,
              itemBuilder: (_, index) {
                return StoreCard(storesManager.stores[index]);
              },
            );
          }
        },
      ),
    );
  }
}
