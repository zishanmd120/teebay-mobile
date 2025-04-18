import 'package:flutter/material.dart';

import '../../../../core/utils/format_date.dart';
import '../../data/models/products_response.dart';

class ProductCardWidget extends StatefulWidget {
  final ProductsResponse  productsModel;
  const ProductCardWidget({super.key, required this.productsModel,});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {

  bool selectedMaxLines = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0,),
      margin: const EdgeInsets.only(bottom: 10.0,),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.productsModel.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
          Row(
            children: [
              const Text("Categories: "),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (widget.productsModel.categories ?? []).asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  final capitalized = category[0].toUpperCase() + category.substring(1);
                  final isLast = index == (widget.productsModel.categories!.length - 1);
                  return Text("$capitalized${isLast ? '.' : ', '}");
                }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              Text("Price: Tk.${widget.productsModel.purchasePrice ?? " "} | "),
              Text("Rent: Tk.${widget.productsModel.rentPrice ?? " "} / "),
              Text(widget.productsModel.rentOption ?? ""),
            ],
          ),
          Text(widget.productsModel.description ?? "",
            maxLines: selectedMaxLines ? null : 3,
            overflow: selectedMaxLines ? null : TextOverflow.ellipsis,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                selectedMaxLines = !selectedMaxLines;
                setState(() {});
              },
              child: const Text("see more", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.orange,),),
            ),
          ),
          Text("Date Posted: ${FormatDate().formatDateWithSuffix(DateTime.parse(widget.productsModel.datePosted ?? ""))}"),
        ],
      ),
    );
  }
}