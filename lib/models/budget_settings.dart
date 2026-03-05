class BudgetSettings {
  String titleLine;
  bool hideLeftList;
  bool hideRightList;
  bool showOpenOnly;
  double defaultBudget;
  String workplanFilename;
  String suggestionsFilename;
  

  BudgetSettings({
    this.titleLine = 'Budget Info',
    this.hideLeftList = false,
    this.hideRightList = true,
    this.showOpenOnly = false,
    this.defaultBudget = 100,
    this.workplanFilename = '',
    this.suggestionsFilename = '',
  });

  /// Convert Flutter Color to PDF Color
  //PdfColor get pdfColor => PdfColor.fromInt(color.toARGB32());

  void copy(BudgetSettings block) {
    titleLine = block.titleLine;
    hideLeftList = block.hideLeftList;
    hideRightList = block.hideRightList;
    showOpenOnly = block.showOpenOnly;
    defaultBudget = block.defaultBudget;
    workplanFilename = block.workplanFilename;
    suggestionsFilename = block.suggestionsFilename;
  }
  
  // jsonEncode() akzeptiert nur: 
  //    primitive Typen (String, int, double, bool)
  //    Listen, Maps und Objekte, die eine toJson()‑Methode besitzen
  // Optional: Automatische JSON‑Generierung (json_serializable)

  // JSON-Export
  Map<String, dynamic> toJson() => {
        'titleLine': titleLine,
        'hideLeftList': hideLeftList,
        'hideRightList': hideRightList,
        'showOpenOnly': showOpenOnly,
        'defaultBudget': defaultBudget,
        'workplanFilename': workplanFilename,
        'suggestionsFilename': suggestionsFilename,
      };

  // JSON-Import
  factory BudgetSettings.fromJson(Map<String, dynamic> json) {
    return BudgetSettings(
      titleLine: json['titleLine'] ?? 'Budget Info',
      hideLeftList: json['hideLeftList'] ?? false,
      hideRightList: json['hideRightList'] ?? true,
      showOpenOnly: json['showOpenOnly'] ?? false,
      defaultBudget: (json['defaultBudget'] ?? 100).toDouble(),
      workplanFilename: json['workplanFilename'] ?? '',
      suggestionsFilename: json['suggestionsFilename'] ?? '',
    );
  }

}
