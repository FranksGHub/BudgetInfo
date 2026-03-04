// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Budget Info';

  @override
  String get menu => 'Menü';

  @override
  String get help => 'Hilfe';

  @override
  String get editTitle => 'Titel bearbeiten';

  @override
  String get printPdf => 'Liste Drucken';

  @override
  String get printWorkplan => 'Liste drucken';

  @override
  String get dataImported => 'Daten erfolgreich importiert';

  @override
  String get failedToImportData => 'Fehler beim Daten Import';

  @override
  String dataExported(Object path) {
    return 'Daten exportiert nach $path';
  }

  @override
  String dataExportedError(Object path) {
    return 'Fehler beim Daten Export nach $path!';
  }

  @override
  String get time => 'Zeit';

  @override
  String get editBudget => 'Budget bearbeiten';

  @override
  String get editBudgetHint =>
      'z.B. 120.50 oder 120,50 (keine Tausenderpunkte)';

  @override
  String get editWorkplanFilename => 'Dateinamen für Liste bearbeiten';

  @override
  String get editSuggestionsFilename => 'Dateinamen für Templates bearbeiten';

  @override
  String get workplanFilename => 'Dateiname der Liste';

  @override
  String get suggestionsFilename => 'Dateiname der Templates';

  @override
  String get showOpenOnly => 'Verstecke abgeschlossene Kopfzeilen';

  @override
  String get copy => 'Kopieren';

  @override
  String get paste => 'Einfügen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get title => 'Titel';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get languageEnglish => 'Sprache Englisch';

  @override
  String get languageGerman => 'Sprache Deutsch';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get saveTimetableData => 'Speichern der Budget Daten';

  @override
  String get saveTimetableDataSubject => 'Budget Daten Backup';

  @override
  String get editText => 'Text bearbeiten';

  @override
  String get addItemLeft => '+ Kopfzeile';

  @override
  String get addSubitemLeft => '+ Subzeile';

  @override
  String get addItemRight => '+ Kopfzeile';

  @override
  String get addSubitemRight => '+ Subzeile';

  @override
  String get copyItemToLeft => '<= Kopfzeile';

  @override
  String get copySubitemToLeft => '<= Subzeile';

  @override
  String get leftList => 'Liste';

  @override
  String get rightList => 'Templates';

  @override
  String get show => 'Zeige';

  @override
  String get hide => 'Verstecke';

  @override
  String get leftListShort => 'linke Liste';

  @override
  String get rightListShort => 'rechte Liste';

  @override
  String get newItem => 'Kopfzeile';

  @override
  String get newSubitem => '- Subzeile';

  @override
  String get failedToLoadSettingsData =>
      'Laden der Einstellungen ist fehlgeschlagen';

  @override
  String get failedToSaveSettingsData =>
      'Speichern der Einstellungen ist fehlgeschlagen';

  @override
  String get failedToLoadLeftData =>
      'Laden der Listen Daten ist fehlgeschlagen';

  @override
  String get failedToLoadRightData => 'Laden der Templates ist fehlgeschlagen';

  @override
  String get failedToSaveLeftData => 'Speichern der Liste ist fehlgeschlagen';

  @override
  String get failedToSaveRightData =>
      'Speichern der Templates ist fehlgeschlagen';

  @override
  String get saveNotesButton => 'Speichern';

  @override
  String get failedToCreateZipFile => 'Fehler beim erzeugen der ZIP-Datei';

  @override
  String get timetableBackup => 'Backup alle Dateien in eine ZIP-Datei';

  @override
  String get timetableBackupImport =>
      'Importiere alle Dateien aus einer Backup ZIP-Datei';

  @override
  String get failedToBackupInZipFile => 'Fehler beim Backup der Dateien';

  @override
  String get backupInZipFileOk => 'Alle Dateien wurden gesichert';

  @override
  String get failedToImportZipFile => 'Fehler beim Import der Dateien';

  @override
  String get importbackupZipFileOk => 'Alle Dateien wurden importiert';

  @override
  String get importAllFilesZip =>
      'Importiere alle Dateien aus einem Backup (ZIP)';

  @override
  String get exportAllFilesZip => 'Exportiere alle Dateien als Backup (ZIP)';

  @override
  String get noFilesToExportYet => 'Keine Dateien zum Backup gefunden';

  @override
  String get fileNotFound => 'Quelldatei existiert nicht';

  @override
  String get appNameWithSpaces => 'Budget Info App';

  @override
  String printingFooter(Object date) {
    return 'Erstellt mit der Budget Info App am $date';
  }

  @override
  String get bothListsHidden =>
      'Bitte eine Liste wieder sichtbar machen (oben rechts)!';

  @override
  String get printingFailed => 'Printing failed';

  @override
  String get printingSuccess => 'Printing started';

  @override
  String get enterAValue => 'Gib eine Zahl ein';

  @override
  String get noThousandsSep => 'Tausendertrennzeichen sind nicht erlaubt';

  @override
  String get noValidNumber => 'Ungültige Zahl';

  @override
  String get noNegativeNumbers => 'Der Betrag darf nicht negativ sein';
}
