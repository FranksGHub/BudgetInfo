import 'package:intl/intl.dart';

class BlockItem {
  String text;
  List<BlockItem> subitems;
  String? status; // '(P)', '(F)' for left, null for right
  String finishedAt = "";
  double startBudget = 0;
  double resultBudget = 0;

  BlockItem({required this.text, required this.startBudget, List<BlockItem>? subitems, this.status = '(P)', this.finishedAt = "", this.resultBudget = 0}) : subitems = List<BlockItem>.from(subitems ?? []);

  void changeStatus() {
    status = status == null ? '(P)' : status == '(P)' ? '(F)' : '(P)';
    // set finished time, if status changed to 'F' otherwise delete it
    finishedAt = status == '(F)' ? DateFormat('dd.MM.yy').format(DateTime.now()) : ''; 
  }

  String getText() {
    return text + ', ' + (finishedAt.length > 0 ? finishedAt  : '- ') + ', ' + startBudget.toStringAsFixed(2) + ', ' + resultBudget.toStringAsFixed(2);
  }


  Map<String, dynamic> toJson() => {
    'text': text,
    'subitems': subitems.map((e) => e.toJson()).toList(),
    'status': status,
    'finishedAt': finishedAt,
    'startBudget': startBudget,
    'resultBudget': resultBudget,
  };

  factory BlockItem.fromJson(Map<String, dynamic> json) => BlockItem(
    text: json['text'],
    subitems: List<BlockItem>.from(
      (json['subitems'] as List<dynamic>? ?? []).map((e) => BlockItem.fromJson(e))
    ),
    status: json['status'],
    finishedAt: json['finishedAt'],
    startBudget: json['startBudget'],
    resultBudget: json['resultBudget'],
  );
}