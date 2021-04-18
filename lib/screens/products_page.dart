import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ayush_gupta/models/network_info.dart';
import 'package:ayush_gupta/models/validate.dart';
import 'package:ayush_gupta/reuseable_widgets/reuseable.dart';
import 'package:ayush_gupta/screens/side_bar.dart';
import 'package:ayush_gupta/screens/your_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _saving = true;

  TextEditingController qtyIsValue = TextEditingController();
  List<Products> listOfItems = [];
  TabController _tabController;
  int contOfCartItems = 0;


  getLen() async {
    String access_token = await Validate();

    if (access_token != null) {
      var getLen = await http.get(getCartLenItems, headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});
      if (getLen.statusCode == 200){
        var len = await jsonDecode(getLen.body)['len'];
        setState(() {
          contOfCartItems = len;
        });
      }
    }
  }



  List<CartItems> itemOfList = [];

  Future<List<CartItems>> getCartItems() async {
    String access_token = await Validate();

    if (access_token != null) {
      var GetItemsList = await http.get(getAllCartItems,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});
      var data = await jsonDecode(GetItemsList.body)['cart'];

      if (GetItemsList.statusCode == 200) {
        for (var item in data) {
          CartItems cartItems = CartItems(item['item'], item['qty']);
          itemOfList.add(cartItems);
        }
        return itemOfList;
      }
    }
  }



  Future<List<Products>> getItems() async {
    String access_token = await Validate();

    if (access_token != null) {
      var getItems = await http.get(getItemsCategory,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});

      var data = await jsonDecode(getItems.body)['items'];

      if (getItems != null) {
        for (var item in data) {
          Products products = Products(item['name'], item['perKgpPrice'],
              item['discount'], item['category'], item['image'], '0');
          listOfItems.add(products);
        }
        getCartItems().whenComplete((){

          for (var i = 0; i < itemOfList.length; i++){
            final tile = listOfItems.firstWhere((item) => item.name == itemOfList[i].item);
            setState(() => tile.qtyIs = itemOfList[i].qty);

          }
          return listOfItems;
        });

      }
    }
  }

  @override
  void initState() {
    super.initState();

    getItems().whenComplete(() {
      getLen();
      setState(() {
        _saving = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            // toolbarHeight: MediaQuery.of(context).size.height * 0.25,
            elevation: 0,
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Rice & Other Grains',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Super Store - Faridabad',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                      textAlign: TextAlign.left,
                    ),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Icon(Icons.search),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      Text('$contOfCartItems'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return YourCart();
                    }));
                  },
                ),
              ),
            ],
          ),
          drawer: Side_Bar(),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff7cdc41),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, top: 8, bottom: 15, right: 18),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Buy Onion & Potatoes',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.075,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lobster',
                                ),
                              ),
                              Text(
                                  'at the best price Order your groceries online and easy',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                  )),
                            ],
                          ),
                          Image.asset(
                            'images/top_card.png',
                            width: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                        child: Text(
                      'Basmati',
                      style: TextStyle(color: Colors.green[800]),
                    )),
                    Tab(
                        child: Text(
                      'Oats',
                      style: TextStyle(color: Colors.green[800]),
                    )),
                    Tab(
                        child: Text(
                      'Other Rice',
                      style: TextStyle(color: Colors.green[800]),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemBuilder: (context, i) {

                        var discountedRate = int.parse(listOfItems
                                .where((i) => i.category == 'basmati')
                                .toList()[i]
                                .perKgpPrice) -
                            ((int.parse(listOfItems
                                        .where((i) => i.category == 'basmati')
                                        .toList()[i]
                                        .discount) /
                                    100) *
                                int.parse(listOfItems
                                    .where((i) => i.category == 'basmati')
                                    .toList()[i]
                                    .perKgpPrice));

                        Uint8List _base64_image = base64.decode(listOfItems
                            .where((i) => i.category == 'basmati')
                            .toList()[i]
                            .image);
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.35,
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.memory(
                                    _base64_image,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "₹${discountedRate.round()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "₹${listOfItems.where((i) => i.category == 'basmati').toList()[i].perKgpPrice}",
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff7cdc41),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                '${listOfItems.where((i) => i.category == "basmati").toList()[i].discount}% OFF',
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.025),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(listOfItems
                                          .where((i) => i.category == "basmati")
                                          .toList()[i]
                                          .name),
                                      Text(
                                        'Super Store - Faridabad',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('5 Kg'),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          listOfItems
                                              .where((i) => i.category == "basmati")
                                              .toList()[i].qtyIs == '0' ? GestureDetector(
                                            onTap: () async {
                                              String access_token =
                                                  await Validate();
                                              if (access_token != null) {
                                                var addToCart = await http
                                                    .post(addToCartURI, body: {
                                                  "item": listOfItems
                                                      .where((i) =>
                                                          i.category ==
                                                          "basmati")
                                                      .toList()[i]
                                                      .name
                                                }, headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});
                                                var content = await jsonDecode(addToCart.body)['message'];

                                                if (addToCart.statusCode == 200){
                                                  setState(() {
                                                    contOfCartItems++;
                                                    listOfItems.where((i) => i.category == "basmati").toList()[i].qtyIs  = '1';
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: content.toString(),
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 6,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                              }

                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text('Add'),
                                                      ),
                                                      SizedBox(
                                                        width: 28,
                                                      ),
                                                      CircleAvatar(
                                                        child: Icon(Icons.add),
                                                        radius: 14,
                                                        backgroundColor:
                                                            Color(0xff7cdc41),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ) : Row(
                                            children: [
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  child: Icon(Icons.remove_circle_outline_outlined),
                                                  radius: 14,
                                                  backgroundColor:
                                                  Color(0xff7cdc41),
                                                ),
                                                onTap: ()async{


                                                  var newQty =
                                                  int.parse(listOfItems
                                                      .where((i) => i.category == 'basmati')
                                                      .toList()[i]
                                                    .qtyIs);

                                                  if (int.parse(listOfItems
                                                      .where((i) => i.category == 'basmati')
                                                      .toList()[i]
                                                      .qtyIs) ==
                                                      1) {
                                                    newQty;
                                                  } else {
                                                    newQty--;
                                                  }

                                                  String access_token = await Validate();
                                                  if (access_token != null) {
                                                    var editQty = await http.put(
                                                        editQtyURI(listOfItems
                                                            .where((i) => i.category == 'basmati')
                                                            .toList()[i]
                                                          .name,
                                                            "$newQty"),
                                                        headers: {
                                                          HttpHeaders.authorizationHeader:
                                                          'Bearer $access_token'
                                                        });
                                                    if (editQty.statusCode == 200) {
                                                      setState(() {
                                                        listOfItems
                                                            .where((i) => i.category == 'basmati')
                                                            .toList()[i]
                                                            .qtyIs =
                                                            newQty.toString();
                                                      });
                                                    }
                                                  }

                                                },
                                              ),

                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 15.0, right: 15.0),
                                                child: Text(listOfItems
                                                    .where((i) =>
                                                i.category ==
                                                    "basmati")
                                                    .toList()[i]
                                                    .qtyIs),
                                              ),
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  child: Icon(Icons.add_circle_outline),
                                                  radius: 14,
                                                  backgroundColor:
                                                  Color(0xff7cdc41),
                                                ),
                                                onTap: () async {

                                                  var newQty =
                                                  int.parse(listOfItems
                                                      .where((i) => i.category == 'basmati')
                                                      .toList()[i]
                                                      .qtyIs);

                                                  if (int.parse(listOfItems
                                                      .where((i) => i.category == 'basmati')
                                                      .toList()[i]
                                                      .qtyIs) ==
                                                      10) {
                                                    newQty;
                                                  } else {
                                                    newQty++;
                                                  }

                                                  String access_token = await Validate();
                                                  if (access_token != null) {
                                                    var editQty = await http.put(
                                                        editQtyURI(listOfItems
                                                            .where((i) => i.category == 'basmati')
                                                            .toList()[i]
                                                            .name,
                                                            "$newQty"),
                                                        headers: {
                                                          HttpHeaders.authorizationHeader:
                                                          'Bearer $access_token'
                                                        });
                                                    if (editQty.statusCode == 200) {
                                                      setState(() {
                                                        listOfItems
                                                            .where((i) => i.category == 'basmati')
                                                            .toList()[i]
                                                            .qtyIs =
                                                            newQty.toString();
                                                      });
                                                    }
                                                  }

                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: listOfItems
                          .where((i) => i.category == 'basmati')
                          .toList()
                          .length,
                    ),

                    ListView.builder(
                      itemBuilder: (context, i) {

                        var discountedRate = int.parse(listOfItems
                            .where((i) => i.category == 'oats')
                            .toList()[i]
                            .perKgpPrice) -
                            ((int.parse(listOfItems
                                .where((i) => i.category == 'oats')
                                .toList()[i]
                                .discount) /
                                100) *
                                int.parse(listOfItems
                                    .where((i) => i.category == 'oats')
                                    .toList()[i]
                                    .perKgpPrice));

                        Uint8List _base64_image = base64.decode(listOfItems
                            .where((i) => i.category == 'oats')
                            .toList()[i]
                            .image);
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.35,
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.memory(
                                    _base64_image,
                                    width:
                                    MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "₹${discountedRate.round()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "₹${listOfItems.where((i) => i.category == 'oats').toList()[i].perKgpPrice}",
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff7cdc41),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: Text(
                                                '${listOfItems.where((i) => i.category == "oats").toList()[i].discount}% OFF',
                                                style: TextStyle(
                                                    fontSize:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.025),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(listOfItems
                                          .where((i) => i.category == "oats")
                                          .toList()[i]
                                          .name),
                                      Text(
                                        'Super Store - Faridabad',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.03),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('5 Kg'),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          listOfItems
                                              .where((i) => i.category == "oats")
                                              .toList()[i].qtyIs == '0' ? GestureDetector(
                                            onTap: () async {
                                              String access_token =
                                              await Validate();
                                              if (access_token != null) {
                                                var addToCart = await http
                                                    .post(addToCartURI, body: {
                                                  "item": listOfItems
                                                      .where((i) =>
                                                  i.category ==
                                                      "oats")
                                                      .toList()[i]
                                                      .name
                                                }, headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});
                                                var content = await jsonDecode(addToCart.body)['message'];

                                                if (addToCart.statusCode == 200){
                                                  setState(() {
                                                    contOfCartItems++;
                                                    listOfItems.where((i) => i.category == "oats").toList()[i].qtyIs  = '1';
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: content.toString(),
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 6,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }

                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(15)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Text('Add'),
                                                      ),
                                                      SizedBox(
                                                        width: 28,
                                                      ),
                                                      CircleAvatar(
                                                        child: Icon(Icons.add),
                                                        radius: 14,
                                                        backgroundColor:
                                                        Color(0xff7cdc41),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ) : Row(
                                            children: [
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  child: Icon(Icons.remove_circle_outline_outlined),
                                                  radius: 14,
                                                  backgroundColor:
                                                  Color(0xff7cdc41),
                                                ),
                                                onTap: ()async{


                                                  var newQty =
                                                  int.parse(listOfItems
                                                      .where((i) => i.category == 'oats')
                                                      .toList()[i].qtyIs);

                                                  if (int.parse(listOfItems
                                                      .where((i) => i.category == 'oats')
                                                      .toList()[i].qtyIs) ==
                                                      1) {
                                                    newQty;
                                                  } else {
                                                    newQty--;
                                                  }

                                                  String access_token = await Validate();
                                                  if (access_token != null) {
                                                    var editQty = await http.put(
                                                        editQtyURI(listOfItems
                                                            .where((i) => i.category == 'oats')
                                                            .toList()[i].name,
                                                            "$newQty"),
                                                        headers: {
                                                          HttpHeaders.authorizationHeader:
                                                          'Bearer $access_token'
                                                        });
                                                    if (editQty.statusCode == 200) {
                                                      setState(() {
                                                        listOfItems
                                                            .where((i) => i.category == 'oats')
                                                            .toList()[i].qtyIs =
                                                            newQty.toString();
                                                      });
                                                    }
                                                  }

                                                },
                                              ),

                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 15.0, right: 15.0),
                                                child: Text(listOfItems
                                                    .where((i) =>
                                                i.category ==
                                                    "oats")
                                                    .toList()[i]
                                                    .qtyIs),
                                              ),
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  child: Icon(Icons.add_circle_outline),
                                                  radius: 14,
                                                  backgroundColor:
                                                  Color(0xff7cdc41),
                                                ),
                                                onTap: () async {

                                                  var newQty =
                                                  int.parse(listOfItems
                                                      .where((i) =>
                                                  i.category ==
                                                      "oats")
                                                      .toList()[i]
                                                      .qtyIs);

                                                  if (int.parse(listOfItems
                                                      .where((i) =>
                                                  i.category ==
                                                      "oats")
                                                      .toList()[i]
                                                      .qtyIs) ==
                                                      10) {
                                                    newQty;
                                                  } else {
                                                    newQty++;
                                                  }

                                                  String access_token = await Validate();
                                                  if (access_token != null) {
                                                    var editQty = await http.put(
                                                        editQtyURI(listOfItems
                                                            .where((i) =>
                                                        i.category ==
                                                            "oats")
                                                            .toList()[i].name,
                                                            "$newQty"),
                                                        headers: {
                                                          HttpHeaders.authorizationHeader:
                                                          'Bearer $access_token'
                                                        });
                                                    if (editQty.statusCode == 200) {
                                                      setState(() {
                                                        listOfItems
                                                            .where((i) => i.category == 'oats')
                                                            .toList()[i].qtyIs =
                                                            newQty.toString();
                                                      });
                                                    }
                                                  }

                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: listOfItems
                          .where((i) => i.category == 'oats')
                          .toList()
                          .length,
                    ),

                    ListView.builder(
                      itemBuilder: (context, i) {

                        var discountedRate = int.parse(listOfItems
                            .where((i) => i.category == 'other basmati')
                            .toList()[i]
                            .perKgpPrice) -
                            ((int.parse(listOfItems
                                .where((i) => i.category == 'other basmati')
                                .toList()[i]
                                .discount) /
                                100) *
                                int.parse(listOfItems
                                    .where((i) => i.category == 'other basmati')
                                    .toList()[i]
                                    .perKgpPrice));

                        Uint8List _base64_image = base64.decode(listOfItems
                            .where((i) => i.category == 'other basmati')
                            .toList()[i]
                            .image);
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.35,
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.memory(
                                    _base64_image,
                                    width:
                                    MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "₹${discountedRate.round()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "₹${listOfItems.where((i) => i.category == 'other basmati').toList()[i].perKgpPrice}",
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff7cdc41),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: Text(
                                                '${listOfItems.where((i) => i.category == "other basmati").toList()[i].discount}% OFF',
                                                style: TextStyle(
                                                    fontSize:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.025),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(listOfItems
                                          .where((i) => i.category == "other basmati")
                                          .toList()[i]
                                          .name),
                                      Text(
                                        'Super Store - Faridabad',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.03),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('5 Kg'),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          listOfItems
                                              .where((i) => i.category == "other basmati")
                                              .toList()[i].qtyIs == '0' ? GestureDetector(
                                            onTap: () async {
                                              String access_token =
                                              await Validate();
                                              if (access_token != null) {
                                                var addToCart = await http
                                                    .post(addToCartURI, body: {
                                                  "item": listOfItems
                                                      .where((i) =>
                                                  i.category ==
                                                      "other basmati")
                                                      .toList()[i]
                                                      .name
                                                }, headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});
                                                var content = await jsonDecode(addToCart.body)['message'];

                                                if (addToCart.statusCode == 200){
                                                  setState(() {
                                                    contOfCartItems++;
                                                    listOfItems.where((i) => i.category == "other basmati").toList()[i].qtyIs  = '1';
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: content.toString(),
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 6,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }

                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(15)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Text('Add'),
                                                      ),
                                                      SizedBox(
                                                        width: 28,
                                                      ),
                                                      CircleAvatar(
                                                        child: Icon(Icons.add),
                                                        radius: 14,
                                                        backgroundColor:
                                                        Color(0xff7cdc41),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ) : Row(
                                            children: [
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  child: Icon(Icons.remove_circle_outline_outlined),
                                                  radius: 14,
                                                  backgroundColor:
                                                  Color(0xff7cdc41),
                                                ),
                                                onTap: ()async{


                                                  var newQty =
                                                  int.parse(listOfItems
                                                      .where((i) => i.category == 'other basmati')
                                                      .toList()[i].qtyIs);

                                                  if (int.parse(listOfItems
                                                      .where((i) => i.category == 'other basmati')
                                                      .toList()[i].qtyIs) ==
                                                      1) {
                                                    newQty;
                                                  } else {
                                                    newQty--;
                                                  }

                                                  String access_token = await Validate();
                                                  if (access_token != null) {
                                                    var editQty = await http.put(
                                                        editQtyURI(listOfItems
                                                            .where((i) => i.category == 'other basmati')
                                                            .toList()[i].name,
                                                            "$newQty"),
                                                        headers: {
                                                          HttpHeaders.authorizationHeader:
                                                          'Bearer $access_token'
                                                        });
                                                    if (editQty.statusCode == 200) {
                                                      setState(() {
                                                        listOfItems
                                                            .where((i) => i.category == 'other basmati')
                                                            .toList()[i].qtyIs =
                                                            newQty.toString();
                                                      });
                                                    }
                                                  }

                                                },
                                              ),

                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 15.0, right: 15.0),
                                                child: Text(listOfItems
                                                    .where((i) =>
                                                i.category ==
                                                    "other basmati")
                                                    .toList()[i]
                                                    .qtyIs),
                                              ),
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  child: Icon(Icons.add_circle_outline),
                                                  radius: 14,
                                                  backgroundColor:
                                                  Color(0xff7cdc41),
                                                ),
                                                onTap: () async {

                                                  var newQty =
                                                  int.parse(listOfItems
                                                      .where((i) => i.category == 'other basmati')
                                                      .toList()[i].qtyIs);

                                                  if (int.parse(listOfItems
                                                      .where((i) => i.category == 'other basmati')
                                                      .toList()[i].qtyIs) ==
                                                      10) {
                                                    newQty;
                                                  } else {
                                                    newQty++;
                                                  }

                                                  String access_token = await Validate();
                                                  if (access_token != null) {
                                                    var editQty = await http.put(
                                                        editQtyURI(listOfItems
                                                            .where((i) => i.category == 'other basmati')
                                                            .toList()[i].name,
                                                            "$newQty"),
                                                        headers: {
                                                          HttpHeaders.authorizationHeader:
                                                          'Bearer $access_token'
                                                        });
                                                    if (editQty.statusCode == 200) {
                                                      setState(() {
                                                        listOfItems
                                                            .where((i) => i.category == 'other basmati')
                                                            .toList()[i].qtyIs =
                                                            newQty.toString();
                                                      });
                                                    }
                                                  }

                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: listOfItems
                          .where((i) => i.category == 'other basmati')
                          .toList()
                          .length,
                    ),

                    // _buildList(key: "key2", string: "List2: ", list: listOfItems),
                    // _buildList(key: "key3", string: "List3: ", list: listOfItems),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

// Widget _buildList({String key, String string, List list}) {
//   return ListView.builder(
//     key: PageStorageKey(key),
//     itemCount: list.length,
//     itemBuilder: (context, i){
//       return Card(
//         child : Text(list[i].name),
//       );
//     },
//   );
// }

class Products {
  final String name;
  final String perKgpPrice;
  final String discount;
  final String category;
  final String image;
  String qtyIs;

  Products(
      this.name, this.perKgpPrice, this.discount, this.category, this.image, this.qtyIs);
}


class CartItems {
  final String item;
  String qty;

  CartItems(this.item, this.qty);
}