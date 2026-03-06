class BookingItem {
  double value = 0;
  String text = '';

  BookingItem({required this.text, required this.value});

  String getText() {
    return text + ' - ' + value.toStringAsFixed(2);
  }


  Map<String, dynamic> toJson() => {
    'text': text,
    'value': value,
  };

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
    text: json['text'],
    value: json['value'],
  );
}