import 'package:budget_info/models/booking_item.dart';
import 'package:intl/intl.dart';

class MonthItem {
  String text;
  List<BookingItem> subitems;
  String? status; // '(P)', '(F)' for left, null for right
  String finishedAt = "";
  double startBudget = 0;

  MonthItem({required this.text, required this.startBudget, List<BookingItem>? subitems, this.status = '(P)', this.finishedAt = ""}) : subitems = List<BookingItem>.from(subitems ?? []);

  void changeStatus() {
    status = status == null ? '(P)' : status == '(P)' ? '(F)' : '(P)';
    // set finished time, if status changed to 'F' otherwise delete it
    finishedAt = status == '(F)' ? DateFormat('dd.MM.yy').format(DateTime.now()) : ''; 
  }

  String getText() {
    return text + ', ' + (finishedAt.length > 0 ? finishedAt  : '- ') + ', ' + startBudget.toStringAsFixed(2) + ', ' + _calculateRemainingBudget().toStringAsFixed(2);
  }

  double _calculateRemainingBudget() { 
    // fold means sum up all values in the list
    final totalBookings = subitems.fold<double>( 0.0, (sum, item) => sum + item.value, ); 
    return startBudget - totalBookings; 
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'subitems': subitems.map((e) => e.toJson()).toList(),
    'status': status,
    'finishedAt': finishedAt,
    'startBudget': startBudget,
  };

  factory MonthItem.fromJson(Map<String, dynamic> json) => MonthItem(
    text: json['text'],
    subitems: List<BookingItem>.from(
      (json['subitems'] as List<dynamic>? ?? []).map((e) => BookingItem.fromJson(e))
    ),
    status: json['status'],
    finishedAt: json['finishedAt'],
    startBudget: json['startBudget'],
  );
}