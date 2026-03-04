import '../models/export_import_files.dart';

class FilenameHelper {

  static String getSettingsFilename() { return ('budgetInfoSettings.json'); }

  static String getDefaultLeftFilename(bool withJsonExtension) { 
    return ExportImportFiles.getSaveFilename('budgetInfoList' + (withJsonExtension ? '.json' : ''));
  }

  static String getDefaultRightFilename(bool withJsonExtension) { 
    return ExportImportFiles.getSaveFilename('templateList' + (withJsonExtension ? '.json' : ''));
  }

}