import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ValueNotifier<int> _quantity = ValueNotifier<int>(10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFEFE),
      appBar: AppBar(
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

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.list, color: Color(0xFF909090), size: 30),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 14,
                          color: Color(0xFF61758A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF656565),
                          ),
                        ),
                        Text(
                          "TShirt",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF656565),
                          ),
                        ),
                        Text(
                          "Clothing",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selling Price (MRP)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF656565),
                          ),
                        ),
                        Text(
                          "₹100",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discounted Price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF656565),
                          ),
                        ),
                        Text(
                          "₹99",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF656565),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This is a detailed description of the product, highlighting its features, benefits, and any other relevant information that would help the customer make a purchase decision.",
                    style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 83,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFD3D3D3),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Stock Left",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6D69A8),
                            ),
                          ),
                          Text(
                            "150",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 36),
                  Expanded(
                    child: Container(
                      height: 83,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFD3D3D3),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Reorders",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFDF6D69A8),
                            ),
                          ),
                          Text(
                            "10",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adjust Stock",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Stock",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6D69A8),
                        ),
                      ),
                      Row(
                        children: [
                          // Decrease button
                          GestureDetector(
                            onTap: () {
                              if (_quantity.value > 0) {
                                _quantity.value--;
                              }
                            },
                            child: const Icon(
                              Icons.remove_circle_outline_rounded,
                              color: Color(0xFF222222),
                              size: 18,
                            ),
                          ),

                          const SizedBox(width: 4),

                          // Quantity text
                          ValueListenableBuilder<int>(
                            valueListenable: _quantity,
                            builder: (context, value, child) {
                              return Text(
                                "$value",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF222222),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 4),

                          // Increase button
                          GestureDetector(
                            onTap: () {
                              _quantity.value++;
                            },
                            child: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Color(0xFF222222),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
