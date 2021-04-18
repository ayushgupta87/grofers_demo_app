import 'dart:convert';
import 'dart:io';

import 'package:ayush_gupta/models/validate.dart';
import 'package:ayush_gupta/screens/products_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ayush_gupta/models/network_info.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class YourCart extends StatefulWidget {
  @override
  _YourCartState createState() => _YourCartState();
}

class _YourCartState extends State<YourCart> {
  int sumValue = 0;
  TextEditingController note = TextEditingController();

  bool _saving = true;

  List<CartItems> itemOfList = [];

  Future<List<CartItems>> getItems() async {
    String access_token = await Validate();

    if (access_token != null) {
      var GetItemsList = await http.get(getAllCartItems,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $access_token'});

      var data = await jsonDecode(GetItemsList.body)['cart'];

      List calulation = [];

      if (GetItemsList.statusCode == 200) {
        for (var item in data) {
          CartItems cartItems = CartItems(item['item'], item['qty'], item['kg'],
              item['price'], item['note']);
          calulation.add(int.parse(item['qty']) * int.parse(item['price']));
          itemOfList.add(cartItems);
        }
        print(calulation);

        num sum = 0;
        for (num e in calulation) {
          sum += e;
        }

        setState(() {
          sumValue = sum;
        });

        return itemOfList;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getItems().whenComplete(() {
      setState(() {
        _saving = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Your Cart'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return ProductsPage();
            }), (route) => false);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green[800],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    itemOfList.length != 0
                        ? 'Today, 11am - noon'
                        : 'Your Cart is empty',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff7cdc41),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 3, bottom: 3),
                      child: Text(
                        itemOfList.length != 0 ? 'FREE' : 'Add Now',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: itemOfList.length,
                  itemBuilder: (context, i) {

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        color: Colors.white,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          itemOfList[i].item,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                      "${itemOfList[i].kg} Kg",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          color: Colors.grey[700]),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "₹${itemOfList[i].price} / Item",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.remove_circle_outline_outlined,
                                        size: 30,
                                      ),
                                      onTap: () async {
                                        var newQty =
                                            int.parse(itemOfList[i].qty);

                                        if (int.parse(itemOfList[i].qty) == 1) {
                                          newQty;
                                        } else {
                                          newQty--;
                                        }

                                        String access_token = await Validate();
                                        if (access_token != null) {
                                          var editQty = await http.put(
                                              editQtyURI(itemOfList[i].item,
                                                  "$newQty"),
                                              headers: {
                                                HttpHeaders.authorizationHeader:
                                                    'Bearer $access_token'
                                              });
                                          if (editQty.statusCode == 200) {
                                            setState(() {
                                              itemOfList[i].qty =
                                                  newQty.toString();
                                            });
                                            List newList = [];
                                            for (var z = 0;
                                                z < itemOfList.length;
                                                z++) {
                                              var count = int.parse(
                                                      itemOfList[z].price) *
                                                  int.parse(itemOfList[z].qty);
                                              newList.add(count);
                                            }
                                            print(newList);
                                            num sum = 0;
                                            for (num e in newList) {
                                              sum += e;
                                            }
                                            print(sum);
                                            setState(() {
                                              sumValue = sum;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${itemOfList[i].qty}',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.055,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        size: 30,
                                      ),
                                      onTap: () async {
                                        var newQty =
                                            int.parse(itemOfList[i].qty);

                                        if (int.parse(itemOfList[i].qty) ==
                                            10) {
                                          newQty;
                                        } else {
                                          newQty++;
                                        }

                                        String access_token = await Validate();
                                        if (access_token != null) {
                                          var editQty = await http.put(
                                              editQtyURI(itemOfList[i].item,
                                                  "$newQty"),
                                              headers: {
                                                HttpHeaders.authorizationHeader:
                                                    'Bearer $access_token'
                                              });
                                          if (editQty.statusCode == 200) {
                                            setState(() {
                                              itemOfList[i].qty =
                                                  newQty.toString();
                                            });
                                            List newList = [];
                                            for (var z = 0;
                                                z < itemOfList.length;
                                                z++) {
                                              var count = int.parse(
                                                      itemOfList[z].price) *
                                                  int.parse(itemOfList[z].qty);
                                              newList.add(count);
                                            }
                                            print(newList);
                                            num sum = 0;
                                            for (num e in newList) {
                                              sum += e;
                                            }
                                            print(sum);
                                            setState(() {
                                              sumValue = sum;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: 'Notes',
                            color: Colors.grey,
                            icon: Icons.note_add,
                            onTap: () {
                              setState(() {
                                note.text = itemOfList[i].note == 'NONE' ? ' ' : itemOfList[i].note;
                              });
                              showAlertDialoge(BuildContext context) {
                                Widget okButton = FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () async {
                                    String access_token = await Validate();
                                    if (access_token != null) {
                                      var addnote = await http
                                          .put(addNoteInItemItems, body: {
                                        "item": itemOfList[i].item,
                                        "Note": note.text
                                      }, headers: {
                                        HttpHeaders.authorizationHeader:
                                            'Bearer $access_token'
                                      });
                                      var content = await jsonDecode(
                                          addnote.body)['message'];
                                      Navigator.pop(context);

                                      if (addnote.statusCode == 200) {
                                        itemOfList[i].note = note.text;

                                        Fluttertoast.showToast(
                                            msg: content.toString(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 6,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
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
                                );
                                Widget cancelButton = FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                                AlertDialog alert = AlertDialog(
                                  title: Text('Add/Edit Note'),
                                  content: SingleChildScrollView(
                                      child: TextField(
                                    controller: note,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.black),
                                      ),
                                      labelText: "Add Note",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  )),
                                  actions: [
                                    cancelButton,
                                    okButton,
                                  ],
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }

                              showAlertDialoge(context);
                            }),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            String access_token = await Validate();
                            if (access_token != null) {
                              var deleteItem = await http.delete(
                                  deleteItemFromCartItems(itemOfList[i].item),
                                  headers: {
                                    HttpHeaders.authorizationHeader:
                                        'Bearer $access_token'
                                  });
                              var content =
                                  await jsonDecode(deleteItem.body)['message'];
                              if (deleteItem.statusCode == 200) {
                                setState(() {
                                  itemOfList.removeAt(i);
                                });
                                List newList = [];
                                for (var z = 0; z < itemOfList.length; z++) {
                                  var count = int.parse(itemOfList[z].price) *
                                      int.parse(itemOfList[z].qty);
                                  newList.add(count);
                                }
                                print(newList);
                                num sum = 0;
                                for (num e in newList) {
                                  sum += e;
                                }
                                print(sum);
                                setState(() {
                                  sumValue = sum;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: content.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 6,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          },
                        ),
                      ],
                    );
                  })),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 10),
        color: Colors.grey[200],
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Column(
            children: [
              Text(
                'Subtotal : ₹$sumValue',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 18,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(20),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green[700]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () {},
                  child: Text('Checkout Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItems {
  final String item;
  String qty;
  final String kg;
  final String price;
  String note;

  CartItems(this.item, this.qty, this.kg, this.price, this.note);
}
