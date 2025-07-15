import 'package:flutter/material.dart';

import 'search_drop.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _gstSlabController = TextEditingController();
  TextEditingController _hsnController = TextEditingController();

  FocusNode _categoryFocus = FocusNode();
  FocusNode _brandFocus = FocusNode();
  FocusNode _productNameFocus = FocusNode();
  FocusNode _productDescriptionFocus = FocusNode();
  FocusNode _gstSlabFocus = FocusNode();
  FocusNode _hsnFocus = FocusNode();

  final List<String> prefixes = [
    "Product A",
    "Product B",
    "Product C",
    "Product D",
    "Product E",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Add Products",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFEFEFE),
          ),
        ),
        backgroundColor: const Color(0xFF1D167E),
      ),
      body: Container(
        color: Color(0xFFFEFEFE),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36),
              const Text(
                "Category",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              SearchDropdown(
                controller: _categoryController,
                focusNode: _categoryFocus,
                suggestions: prefixes,
                hintText: "Select coin",
                onSubmit: (value) {
                  // handle submit
                },
                onSuggestionTap: (item) {
                  // handle suggestion tap
                },
              ),
              SizedBox(height: 36),
              const Text(
                "Brand Name",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              SearchDropdown(
                controller: _brandController,
                focusNode: _brandFocus,
                suggestions: prefixes,
                hintText: "Select coin",
                onSubmit: (value) {
                  // handle submit
                },
                onSuggestionTap: (item) {
                  // handle suggestion tap
                },
              ),
              SizedBox(height: 36),
              const Text(
                "Product Name",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              SearchDropdown(
                controller: _productNameController,
                focusNode: _productNameFocus,
                suggestions: prefixes,
                hintText: "Select coin",
                onSubmit: (value) {
                  // handle submit
                },
                onSuggestionTap: (item) {
                  // handle suggestion tap
                },
              ),
              SizedBox(height: 36),
              const Text(
                "Product Image",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 17,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    height: 124,
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                        Text(
                          "Add Media",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF909090),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              Text(
                "*Image will be verified by the team",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF909090),
                ),
              ),
              SizedBox(height: 36),
              const Text(
                "Product Description",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              TextField(
                focusNode: _productDescriptionFocus,
                controller: _productDescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFD3D3D3),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFD3D3D3),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFD3D3D3),
                      width: 0.5,
                    ),
                  ),
                  hintText: "Enter your Product Description here ",
                ),
              ),

              SizedBox(height: 36),
              const Text(
                "GST Slab",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              SearchDropdown(
                controller: _gstSlabController,
                focusNode: _gstSlabFocus,
                suggestions: prefixes,
                hintText: "Select coin",
                onSubmit: (value) {
                  // handle submit
                },
                onSuggestionTap: (item) {
                  // handle suggestion tap
                },
              ),
              SizedBox(height: 36),
              const Text(
                "HSN",
                style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 8),
              SearchDropdown(
                controller: _hsnController,
                focusNode: _hsnFocus,
                suggestions: prefixes,
                hintText: "Select coin",
                onSubmit: (value) {
                  // handle submit
                },
                onSuggestionTap: (item) {
                  // handle suggestion tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDropdown extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> suggestions;
  final String hintText;
  final void Function(String)? onSubmit;
  final void Function(SearchFieldListItem<String>)? onSuggestionTap;

  const SearchDropdown({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    this.hintText = "Select item",
    this.onSubmit,
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SearchField<String>(
      controller: controller,
      focusNode: focusNode,
      suggestionDirection: SuggestionDirection.down,
      textFieldHeight: 50,
      contentPadding: const EdgeInsets.only(left: 20, top: 10),
      suggestions: suggestions
          .map(
            (e) => SearchFieldListItem<String>(
              e,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 15),
                child: Row(
                  children: [
                    const SizedBox(width: 7),
                    Flexible(child: Text(e)),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      suggestionState: Suggestion.expand,
      suggestionStyle: const TextStyle(fontSize: 16, color: Colors.black87),
      suggestionsDecoration: const SuggestionDecoration(color: Colors.white),
      suggestionItemDecoration: SuggestionDecoration(
        borderRadius: BorderRadius.circular(9.0),
      ),
      textInputAction: TextInputAction.next,
      searchStyle: const TextStyle(color: Colors.black),
      hint: hintText,
      searchInputDecoration: const InputDecoration(
        suffixIcon: Icon(Icons.search),
      ),
      maxSuggestionsInViewPort: 3,
      itemHeight: 55,
      onSubmit: onSubmit,
      onSuggestionTap: onSuggestionTap,
    );
  }
}
