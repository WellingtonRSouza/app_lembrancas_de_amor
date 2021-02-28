import 'package:app_lembrancas_de_amor/screens/checkout/components/card_front.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'card_back.dart';

class CreditCardWidget extends StatefulWidget {
  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context){
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: Colors.grey[200],
        actions: [

          KeyboardActionsItem(focusNode: numberFocus, displayDoneButton: false),
          KeyboardActionsItem(focusNode: dateFocus, displayDoneButton: false),
          KeyboardActionsItem(
              focusNode: nameFocus,
              toolbarButtons: [
                (_){
                  return GestureDetector(
                    onTap: (){
                      cardKey.currentState.toggleCard();
                      cvvFocus.requestFocus();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                        child: Text('VIRAR CARTÃO'),
                    ),
                  );
                }
              ]
          ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlipCard(
              key: cardKey,
              direction: FlipDirection.HORIZONTAL,
              speed: 700,
              flipOnTouch: false,
              front: CardFront(
                numberFocus: numberFocus,
                dateFocus: dateFocus,
                nameFocus: nameFocus,
                finished: (){
                  cardKey.currentState.toggleCard();
                  cvvFocus.requestFocus();
                },
              ),
              back: CardBack(
                cvvFocus: cvvFocus,
              ),
            ),
            FlatButton(
              onPressed: (){
                cardKey.currentState.toggleCard();
              },
              textColor: Colors.white,
              padding: EdgeInsets.zero,
              child: const Text('Virar Cartão'),
            ),
          ],
        ),
      ),
    );
  }
}
