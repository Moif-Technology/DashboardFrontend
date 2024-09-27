class DetailModel {
  final String icon;
  final String value;
  final String title;
  final String? value2;
  final String? title2;
  final String? value3;
  final String? title3;
  final String? value4;
  final String? title4;
  final String? totalAmount; // New field for the total sales amount

  const DetailModel({
    required this.icon,
    required this.value,
    required this.title,
    this.value2,
    this.title2,
    this.value3,
    this.title3,
    this.value4,
    this.title4,
    this.totalAmount, // Initialize it here
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      icon: json['icon'],
      value: json['value'],
      title: json['title'],
      value2: json['value2'],
      title2: json['title2'],
      value3: json['value3'],
      title3: json['title3'],
      value4: json['value4'],
      title4: json['title4'],
      totalAmount: json['totalAmount'], // Initialize from JSON
    );
  }
}
