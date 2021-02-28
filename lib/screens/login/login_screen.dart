import 'package:app_lembrancas_de_amor/helpers/validators.dart';
import 'package:app_lembrancas_de_amor/models/user.dart';
import 'package:app_lembrancas_de_amor/models/user_manager.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            textColor: Colors.white,
            child:
            const Text(
                'CRIAR CONTA',
              style: TextStyle(fontSize: 16,),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, child){

                if(userManager.loadingFace){
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email){
                        if(email.isEmpty)
                          return 'Campo Obrigatório';
                        else if (!emailValid(email))
                          return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass){
                        if(pass.isEmpty)
                          return 'Campo Obrigatório';
                        else if (pass.length < 6)
                          return 'Senha inválida';
                        return null;
                      },
                    ),
                    child,
                    const SizedBox(height: 16,),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading ? null : (){
                        if(formKey.currentState.validate()){
                          userManager.signIn(
                              user: User(
                                  email: emailController.text,
                                  password: passController.text
                              ),
                              onFail: (e){
                                scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Falha ao entrar:\n$e',
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              },
                              onSuccess: () {
                                Navigator.of(context).pop();
                              },
                          );
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: userManager.loading ?
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ) :
                      const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SignInButton(
                        Buttons.Facebook,
                        text: 'Entrar com Facebook',
                        onPressed: (){
                          userManager.facebookLogin(
                            onFail: (e){
                              scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Falha ao entrar:\n$e',
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  )
                              );
                            },
                            onSuccess: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                    )
                  ],
                );
              },
               child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: (){

                    },
                    padding: EdgeInsets.zero,
                    child: const Text(
                        'Esqueci minha Senha'
                    ),
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
