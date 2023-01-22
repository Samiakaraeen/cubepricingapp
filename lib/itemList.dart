import 'package:flutter/material.dart';

import 'item.dart';

class ItemList extends StatefulWidget {
  ItemList({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<ItemList> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  Future<List<Item>?>? customers;

  // late ProgressDialog pd;
  Item cust = new Item();

  @override
  void initState() {
    super.initState();

    //customers = cust.fetchProducts("");

    //cust.selectAll(PlaceOrder.database!);
  }

  TextEditingController searchcontroler = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            /*
            Switch(
              onChanged: (value) {
                PlaceOrder.onlineMode = value;
                if (value == true) {
                  PlaceOrder.onlineModeText = "استخدام الانترنت";
                } else {
                  PlaceOrder.onlineModeText = "فصل الانترنت";
                }
                PlaceOrder.onlineMode = value;
                setState(() {});
              },
              value: PlaceOrder.onlineMode,
              activeColor: Colors.blue,
              activeTrackColor: Colors.yellow,
              inactiveThumbColor: Colors.redAccent,
              inactiveTrackColor: Colors.orange,
            )*/
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          controller: searchcontroler,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "ادخل النص للبحث",
                              fillColor: Colors.white70),
                          onChanged: (v) {
                            if (v == "") {
                              customers = cust.fetchProducts(v);

                              setState(() {});
                            } else {
                              if (v.length >= 3) {
                                // pd = ProgressDialog(context: context);
                                // pd.show(max: 100, msg: '...جاري البحث');

                                customers = cust.fetchProducts(v);

                                setState(() {});
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: getItems(),
              )
            ],
          ),
        ),
      ),
    );
  }

  int? clickedday = 0;

  Widget getItems() {
    return FutureBuilder<List<Item>?>(
      future: customers,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) {
          return Center(
              // child: CircularProgressIndicator(),
              );
        }
        List<Item> lst = snapshot.data!;
        return GridView.builder(
          itemCount: lst.length,
          itemBuilder: (_, int index) {
            return Card(
              elevation: 1,
              child: GestureDetector(
                onTap: () {
                  Item cust = new Item();
                  cust.code = lst[index].code;
                  cust.name = lst[index].name!;
                  cust.price0 = lst[index].price0;
                  cust.price1 = lst[index].price1;
                  cust.barcode = lst[index].barcode;
                },
                child: Container(
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: index % 2 == 0
                            ? Colors.lightBlueAccent
                            : Colors.lightGreen,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  lst[index].name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        lst[index].code.toString(),
                                        style: TextStyle(color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(' : الرقم  '),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            lst[index].price1!.toString(),
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ' : سعر تكلفة',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            lst[index].price0!.toString(),
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ' : سعر بيع',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 8),
          ),
        );
      },
    );
  }
}
