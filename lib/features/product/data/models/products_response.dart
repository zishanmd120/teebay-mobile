class ProductsResponse {
  int? id;
  int? seller;
  String? title;
  String? description;
  List<String>? categories;
  String? productImage;
  String? purchasePrice;
  String? rentPrice;
  String? rentOption;
  String? datePosted;

  ProductsResponse(
      {this.id,
        this.seller,
        this.title,
        this.description,
        this.categories,
        this.productImage,
        this.purchasePrice,
        this.rentPrice,
        this.rentOption,
        this.datePosted});

  ProductsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seller = json['seller'];
    title = json['title'];
    description = json['description'];
    categories = json['categories'].cast<String>();
    productImage = json['product_image'];
    purchasePrice = json['purchase_price'];
    rentPrice = json['rent_price'];
    rentOption = json['rent_option'];
    datePosted = json['date_posted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller'] = seller;
    data['title'] = title;
    data['description'] = description;
    data['categories'] = categories;
    data['product_image'] = productImage;
    data['purchase_price'] = purchasePrice;
    data['rent_price'] = rentPrice;
    data['rent_option'] = rentOption;
    data['date_posted'] = datePosted;
    return data;
  }
}