class TransactionResponse {
  int? id;
  int? buyer;
  int? seller;
  int? product;
  String? purchaseDate;

  TransactionResponse(
      {this.id, this.buyer, this.seller, this.product, this.purchaseDate});

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyer = json['buyer'];
    seller = json['seller'];
    product = json['product'];
    purchaseDate = json['purchase_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['buyer'] = buyer;
    data['seller'] = seller;
    data['product'] = product;
    data['purchase_date'] = purchaseDate;
    return data;
  }
}