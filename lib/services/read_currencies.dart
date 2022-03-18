import 'package:flutter/services.dart' show rootBundle;

class ReadCurrencies {
  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/currs.txt');
  }

  Future<List> load() async {
    final String input = await loadAsset();
    List namesAndSymbols = [];
    for (String item in input.split('\n')) {
      namesAndSymbols.add(item.split('\t'));
      // print(item);
    }
    return namesAndSymbols;
  }
}
