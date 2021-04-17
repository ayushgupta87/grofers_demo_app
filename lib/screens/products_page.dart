import 'package:ayush_gupta/screens/side_bar.dart';
import 'package:ayush_gupta/screens/your_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  TabController _tabController;
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
                  child: Icon(Icons.shopping_cart),
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
                      'Kolam',
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
                    Icon(Icons.directions_car),
                    Icon(Icons.directions_transit),
                    Icon(Icons.directions_bike),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
