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
  
}