import 'package:calculate_exchange_v2/services/costum_color.dart';
import 'package:flutter/material.dart';

class Calculate extends StatelessWidget {
  const Calculate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    Map paybackFroms = data['paybackFroms'];
    Map paybackTos = data['paybackTos'];

    Widget appbarWidget() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Calculated Shares',
          style: TextStyle(
            fontFamily: 'aller',
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    Widget closeThisPageButton() {
      return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Icon(
            Icons.keyboard_arrow_down,
            size: 40,
          ),
        ),
      );
    }

    List<Widget> subtitle(key) {
      List<Widget> returnResult = [
        const SizedBox(
          height: 10,
        )
      ];
      while (paybackFroms[key] > 0.009 && paybackTos.isNotEmpty) {
        if (paybackFroms[key] < paybackTos[paybackTos.keys.toList()[0]]) {
          paybackTos[paybackTos.keys.toList()[0]] -= paybackFroms[key];
          Color otherColor = MyColors.people[int.parse((paybackTos.keys.toList()[0]).split(',')[1])] as Color;
          returnResult.add(RichText(
            text: TextSpan(
              text: "\t\t Pay ",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
              children: <TextSpan>[
                TextSpan(
                    text:
                        '${data['curr']}${paybackFroms[key].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 17,
                    fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    )),
                TextSpan(
                  text: ' to',
                  style: TextStyle(
                color: Colors.grey.shade600,
                      fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                
                TextSpan(
                    text: ' ${(paybackTos.keys.toList()[0]).split(',')[0]}',
                    style: TextStyle(
                      color: otherColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),),
              ],
            ),
          ));
          paybackFroms[key] = 0;
        } else {
          paybackFroms[key] -= paybackTos[paybackTos.keys.toList()[0]];
          Color otherColor = MyColors.people[int.parse((paybackTos.keys.toList()[0]).split(',')[1])] as Color;
          returnResult.add(
            RichText(
            text: TextSpan(
              text: "\t\t Pay ",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
              children: <TextSpan>[
                TextSpan(
                    text:
                        '${data['curr']}${paybackTos[paybackTos.keys.toList()[0]].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 17,
                    fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    )),
                TextSpan(
                  text: ' to',
                  style: TextStyle(
                color: Colors.grey.shade600,
                      fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                
                TextSpan(
                    text: ' ${paybackTos.keys.toList()[0].split(',')[0]}',
                    style: TextStyle(
                      color: otherColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),),
              ],
            ),
          )
          );
          paybackTos.remove(paybackTos.keys.toList()[0]);
        }
      }
      return returnResult;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10.0, spreadRadius: 7.0),
            ],
          ),
          child: Column(
            children: [
              Center(child: appbarWidget()),
              closeThisPageButton(),
              Expanded(
                child: ListView.builder(
                  itemCount: paybackFroms.length,
                  itemBuilder: (context, index) {
                    String key = paybackFroms.keys.toList()[index];
                    Color color =
                        MyColors.people[int.parse(key.split(',')[1])] as Color;
                    return Card(
                      elevation: 5,
                      color: Colors.white38,
                      shadowColor: color.withOpacity(0.1),
                      shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: color.withOpacity(.2), width: 1),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Icon(
                            Icons.payments_rounded,
                            color: color,
                          ),
                          title: Text(
                            '${key.split(',')[0]} :', // total \npayback: \n${sortedfrom[key]}',
                            style: TextStyle(
                              color: color,
                              fontFamily: 'aller',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Total payback:',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(paybackFroms[key].toString()),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subtitle(key),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
