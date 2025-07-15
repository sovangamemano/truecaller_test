import 'package:flutter/material.dart';

import 'add_inventory_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF5F5F5),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color(0xFFD3D3D3),
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color(0xFF1D167E),
                          width: 0.8,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color(0xFFD3D3D3),
                          width: 0.8,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Search Products",
                      hintStyle: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF909090)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close, color: Color(0xFF909090)),
                        onPressed: () {
                          // Implement filter functionality
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 36),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddInventoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 19,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Products",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF222222),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xFF1D167E),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddInventoryScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Add products that are available in your shop",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF656565),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 36),
                  Text(
                    "Master Catalog",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 36),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 10, // Replace with actual product count
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
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
                              SizedBox(width: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Product Name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Product Description",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF656565),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
