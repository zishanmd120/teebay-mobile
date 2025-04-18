class CategoriesResponse {
  String? value;
  String? label;

  CategoriesResponse({this.value, this.label});

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}