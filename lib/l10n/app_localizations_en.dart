// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Budget Info';

  @override
  String get menu => 'Menu';

  @override
  String get help => 'Help';

  @override
  String get editTitle => 'Edit Title';

  @override
  String get printPdf => 'Print list';

  @override
  String get printWorkplan => 'Print budget list';

  @override
  String get dataImported => 'Data imported successfully';

  @override
  String get failedToImportData => 'Data import failed';

  @override
  String dataExported(Object path) {
    return 'Data exported to $path';
  }

  @override
  String dataExportedError(Object path) {
    return 'Failed to export data to $path!';
  }

  @override
  String get time => 'Time';

  @override
  String get editBudget => 'Edit Budget';

  @override
  String get editBudgetHint => 'e.g. 120.50 or 120,50 (no thousands separator)';

  @override
  String get editWorkplanFilename => 'List filename';

  @override
  String get editSuggestionsFilename => 'Templates filename';

  @override
  String get workplanFilename => 'List filename';

  @override
  String get suggestionsFilename => 'Templates filename';

  @override
  String get showOpenOnly => 'Do not show finished mainlines';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get reset => 'Reset';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get title => 'Title';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'Language English';

  @override
  String get languageGerman => 'Language German';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get saveTimetableData => 'Save Budget Data';

  @override
  String get saveTimetableDataSubject => 'Budget Data Backup';

  @override
  String get editText => 'Edit Text';

  @override
  String get addItemLeft => '+ Mainline';

  @override
  String get addSubitemLeft => '+ Subline';

  @override
  String get addItemRight => '+ Mainline';

  @override
  String get addSubitemRight => '+ Subline';

  @override
  String get copyItemToLeft => '<= Mainline';

  @override
  String get copySubitemToLeft => '<= Subline';

  @override
  String get leftList => 'List';

  @override
  String get rightList => 'Templates';

  @override
  String get show => 'Show';

  @override
  String get hide => 'Hide';

  @override
  String get leftListShort => 'left list';

  @override
  String get rightListShort => 'right list';

  @override
  String get newItem => 'New Mainline';

  @override
  String get newSubitem => '- New Subline';

  @override
  String get failedToLoadSettingsData => 'Failed to load settings data';

  @override
  String get failedToSaveSettingsData => 'Failed to save settings data';

  @override
  String get failedToLoadLeftData => 'Failed to load list data';

  @override
  String get failedToLoadRightData => 'Failed to load template data';

  @override
  String get failedToSaveLeftData => 'Failed to save list data';

  @override
  String get failedToSaveRightData => 'Failed to save template data';

  @override
  String get saveNotesButton => 'Save';

  @override
  String get failedToCreateZipFile => 'Failed to create zip file';

  @override
  String get timetableBackup => 'Backup all files into a zip file';

  @override
  String get timetableBackupImport => 'Import all files from a backup zip file';

  @override
  String get failedToBackupInZipFile => 'Failed to export files';

  @override
  String get backupInZipFileOk => 'All files exported as ZIP';

  @override
  String get failedToImportZipFile => 'Failed to import files';

  @override
  String get importbackupZipFileOk => 'All files imported successfully';

  @override
  String get importAllFilesZip => 'Import all files from a backup (ZIP)';

  @override
  String get exportAllFilesZip => 'Export all files as a backup (ZIP)';

  @override
  String get noFilesToExportYet => 'No files to backup yet';

  @override
  String get fileNotFound => 'Source file not found';

  @override
  String get appNameWithSpaces => 'Budget Info App';

  @override
  String printingFooter(Object date) {
    return 'Created with the Budget Info app at $date';
  }

  @override
  String get bothListsHidden =>
      'Please make one list visible again (top right)!';

  @override
  String get printingFailed => 'Drucken fehlgeschlagen';

  @override
  String get printingSuccess => 'Drucken gestartet';

  @override
  String get enterAValue => 'Enter a value';

  @override
  String get noThousandsSep => 'Thousands separator are not allowed';

  @override
  String get noValidNumber => 'Invalid number';

  @override
  String get noNegativeNumbers => 'The amount must not be negative.';
}
