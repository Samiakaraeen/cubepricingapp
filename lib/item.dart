import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

class Item {
  Item({
    this.code,
    this.name,
    this.price0,
    this.price1,
    this.barcode,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      code: json['code'].toString(),
      name: json['name'].toString(),
      price0: json['price0'].toString(),
      price1: json['price1'].toString(),
      barcode: json['barcode'].toString(),
    );
  }

  String? barcode = "";
  String? code;
  String? name = "";
  String? price0 = "";
  String? price1 = '';

  Future<List<Item>?> fetchProducts(String code) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var response;

    if (code == '') {
      response =
          await http.get(Uri.parse('https://cube-its.net/cubeprice/api/items'));
    } else {
      response = await http.get(Uri.parse(
          'https://cube-its.net/cubeprice/api/items/seacrhitem/' + code));
    }

    if (response.statusCode == 200) {
      List<Item>? l = parseProducts(response.body);
      try {
        //  pd.close();
      } catch (x) {}

      return l;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<String> login(String username, String password) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var response;

    response = await http.get(Uri.parse(
        'https://cube-its.net/cubeprice/api/items/login/' +
            username +
            ',' +
            password));

    if (response.statusCode == 200) {
      String val = response.body.toString();
      try {
        //  pd.close();
      } catch (x) {}

      return val;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  List<Item>? parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Item>((json) => Item.fromJson(json)).toList();
  }
}
