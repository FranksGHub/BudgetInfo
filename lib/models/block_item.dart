class BlockItem {
  String text;
  List<BlockItem> subitems;
  String? status; // '(P)', '(W)', '(F)' for left, null for right

  BlockItem({required this.text, List<BlockItem>? subitems, this.status = '(P)'}) : subitems = List<BlockItem>.from(subitems ?? []);

  Map<String, dynamic> toJson() => {
    'text': text,
    'subitems': subitems.map((e) => e.toJson()).toList(),
    'status': status,
  };

  factory BlockItem.fromJson(Map<String, dynamic> json) => BlockItem(
    text: json['text'],
    subitems: List<BlockItem>.from(
      (json['subitems'] as List<dynamic>? ?? []).map((e) => BlockItem.fromJson(e))
    ),
    status: json['status'],
  );
}