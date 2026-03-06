import 'month_item.dart';

class YearItem {
  String text;
  List<MonthItem> subitems;

  YearItem({required this.text, List<MonthItem>? subitems}) : subitems = List<MonthItem>.from(subitems ?? []);

  String getText() {
    return text;
  }


  Map<String, dynamic> toJson() => {
    'text': text,
    'subitems': subitems.map((e) => e.toJson()).toList(),
  };

  factory YearItem.fromJson(Map<String, dynamic> json) => YearItem(
    text: json['text'],
    subitems: List<MonthItem>.from(
      (json['subitems'] as List<dynamic>? ?? []).map((e) => MonthItem.fromJson(e))
    ),
  );
}