import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YourCart extends StatefulWidget {
  @override
  _YourCartState createState() => _YourCartState();
}

class _YourCartState extends State<YourCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Your Cart'),
        ),
        body: Container(
          color: Colors.green[800],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Today, 11am - noon',
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
                      'FREE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.grey[200],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: [
                Text('Subtotal : \$45.34', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),),
                SizedBox(height: 18,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(20),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green[700]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                    onPressed: (){},
                    child: Text('Checkout Now'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
