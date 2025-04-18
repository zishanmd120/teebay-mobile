class RentalResponse {
  int? id;
  int? renter;
  int? seller;
  int? product;
  String? rentOption;
  String? rentPeriodStartDate;
  String? rentPeriodEndDate;
  String? totalPrice;
  String? rentDate;

  RentalResponse(
      {this.id,
        this.renter,
        this.seller,
        this.product,
        this.rentOption,
        this.rentPeriodStartDate,
        this.rentPeriodEndDate,
        this.totalPrice,
        this.rentDate});

  RentalResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    renter = json['renter'];
    seller = json['seller'];
    product = json['product'];
    rentOption = json['rent_option'];
    rentPeriodStartDate = json['rent_period_start_date'];
    rentPeriodEndDate = json['rent_period_end_date'];
    totalPrice = json['total_price'];
    rentDate = json['rent_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['renter'] = renter;
    data['seller'] = seller;
    data['product'] = product;
    data['rent_option'] = rentOption;
    data['rent_period_start_date'] = rentPeriodStartDate;
    data['rent_period_end_date'] = rentPeriodEndDate;
    data['total_price'] = totalPrice;
    data['rent_date'] = rentDate;
    return data;
  }
}