import 'package:flutter/material.dart';

import 'product_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFEFEFE),
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(
              "Inventory",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFEFEFE),
              ),
            ),
            backgroundColor: const Color(0xFF1D167E),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "product may be reviewed for verification before it appears in the catalog.",
                    style: TextStyle(fontSize: 14, color: Color(0xFF61758A)),
                  ),
                  SizedBox(height: 36),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 10, // Replace with actual product count
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(),
                          )),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.symmetric(vertical: 13.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.list,
                                    color: Color(0xFF909090),
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Classic T-Shirt",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF121417),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "123567890",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF61758A),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          if (index % 2 == 0)
                                            Text(
                                              "Under Review",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFFFA02E),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Stock Left",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF6D69A8),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "150",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF222222),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
