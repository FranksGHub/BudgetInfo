import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';
import '../l10n/app_localizations.dart';
import '../models/booking_item.dart';
import '../models/budget_settings.dart';
import '../models/export_import_files.dart';
import '../models/year_item.dart';
import '../models/month_item.dart';
import '../models/filename_helper.dart';
import '../models/print.dart';
import 'edit_settings_dialog.dart';

class BudgetInfoPage extends StatefulWidget {
  const BudgetInfoPage({super.key, this.onLocaleChange, this.currentLocale});

  final Function(Locale)? onLocaleChange;
  final Locale? currentLocale;

  @override
  State<BudgetInfoPage> createState() => _BudgetInfoPageState();
}

class _BudgetInfoPageState extends State<BudgetInfoPage> with WidgetsBindingObserver {
  BudgetSettings budgetSettings = new BudgetSettings();
  String dataPath = '';

  List<YearItem> leftItems = <YearItem>[];
  List<YearItem> rightItems = <YearItem>[];
  List<bool> leftExpanded = <bool>[];
  List<bool> rightExpanded = <bool>[];
  int? selectedLeftIndex;
  int? selectedRightIndex;
  int? selectedRightSubIndex;
  bool isLoading = false;
  bool isPreview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); 
    super.dispose();
  }

  @override void didChangeAppLifecycleState(AppLifecycleState state) { 
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) { 
      //_saveNotesData();
    } 
  }

  Future<void> _loadData() async {
    try {
      // get or create data path
      dataPath = await ExportImportFiles.getPrivateDirectoryPath();

      String settingsPath = p.join(dataPath, FilenameHelper.getSettingsFilename());

      if (File(settingsPath).existsSync()) {
        String json = File(settingsPath).readAsStringSync();
        budgetSettings = BudgetSettings.fromJson(jsonDecode(json));
      }
      else {  // load the defaulte
        budgetSettings = new BudgetSettings();
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failedToLoadSettingsData + ': $e');
      budgetSettings = new BudgetSettings();
    }

    _loadWorkplanData();
  }

  void _saveSettings() {
    try {
      String settingsPath = p.join(dataPath, FilenameHelper.getSettingsFilename());
      String json = jsonEncode(budgetSettings.toJson());
      File(settingsPath).writeAsStringSync(json);
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failedToSaveSettingsData + ': $e');
    }

  }


  String getFilePath(String fileName) {
    return p.join(dataPath, ExportImportFiles.getSaveFilename(fileName));
  }

  void _loadWorkplanData() {
    // load the right list data from file
    try {
      String filePath = budgetSettings.suggestionsFilename.length == 0 ? getFilePath(FilenameHelper.getDefaultRightFilename(true)) : getFilePath(budgetSettings.suggestionsFilename + '.json');
      if (File(filePath).existsSync()) {
        String json = File(filePath).readAsStringSync();
        List<dynamic> data = jsonDecode(json);
        setState(() {
          rightItems = List<YearItem>.from(
            data.map((e) => YearItem.fromJson(e))
          );
          rightExpanded = rightItems.map((_) => false).toList();
        });
      }
      else {  // empty list if no file exists
        _emptyList(true, false);
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failedToLoadRightData + ': $e');
      _emptyList(true, false);
    }

    // load the left list data from file
    try {
      String filePath = (budgetSettings.workplanFilename.length == 0 ? getFilePath(FilenameHelper.getDefaultLeftFilename(true)) : getFilePath(budgetSettings.workplanFilename)) + '.json';
      if (File(filePath).existsSync()) {
        String json = File(filePath).readAsStringSync();
        List<dynamic> data = jsonDecode(json);
        setState(() {
          leftItems = List<YearItem>.from(
            data.map((e) => YearItem.fromJson(e))
          );
          leftExpanded = leftItems.map((item) => !item.subitems.every((s) => s.status == '(F)')).toList();
        });
      }
      else {  // empty list if no file exists
        _emptyList(false, true);
      } 
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failedToLoadLeftData + ': $e');
      _emptyList(false, true);
    }

    setState(() {});
  }

  void _emptyList(bool rightList, bool leftList) {
    setState(() {
      if (rightList) {
        rightItems.clear();
        rightExpanded.clear();
        selectedRightIndex = null;
        selectedRightSubIndex = null;
      }
      if (leftList) {
        leftItems.clear();
        leftExpanded.clear();
        selectedLeftIndex = null;
      }
    });
  }


  void _saveRightData() {
    try {
      String filePath = budgetSettings.suggestionsFilename.length == 0 ? getFilePath(FilenameHelper.getDefaultRightFilename(true)) : getFilePath(budgetSettings.suggestionsFilename + '.json');
      String json = jsonEncode(rightItems.map((e) => e.toJson()).toList());
      File(filePath).writeAsStringSync(json);
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failedToSaveRightData + ': $e');
    }
  }

  void _saveLeftData() {
    try {
      String filePath = (budgetSettings.workplanFilename.length == 0 ? getFilePath(FilenameHelper.getDefaultLeftFilename(true)) : getFilePath(budgetSettings.workplanFilename)) + '.json';
      String json = jsonEncode(leftItems.map((e) => e.toJson()).toList());
      File(filePath).writeAsStringSync(json);
    } catch (e) {
      _showError(AppLocalizations.of(context)!.failedToSaveLeftData + ': $e');
    }
  }

  void _showError(String message) {
    if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 4)));}
  }

  void _showInfo(String message) {
    if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green, duration: const Duration(seconds: 2)));}
  }

  void _editText(String currentText, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editText),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _switchListVisibility(bool leftList) {
    setState(() {
      if (leftList) { budgetSettings.hideLeftList = !budgetSettings.hideLeftList; } 
      else { budgetSettings.hideRightList = !budgetSettings.hideRightList; }
    });
    _saveSettings();
  }

  void _showLanguage(String langCode) {
    Locale newLocale = langCode == 'en' ? const Locale('en') : const Locale('de');
    if(widget.currentLocale == newLocale){
      return; // No change needed
    }
    if (widget.onLocaleChange != null) {
      widget.onLocaleChange!(newLocale);
      //Navigator.pop(context);
    }
  }

  Future<void> _importData() async {
    if(await ExportImportFiles().importAllFilesFromZip(context)) {
      await _loadData(); // Reload data
      _showInfo(AppLocalizations.of(context)!.importbackupZipFileOk);
    } else {
      _showError(AppLocalizations.of(context)!.failedToImportZipFile);
    }
  }

  void _editSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSettingsDialog(
          settings: budgetSettings,
          onSave: (updatedSettings) { _saveNewSettings(updatedSettings); }
        ),
      )
    );
  }

  void _saveNewSettings(updatedBlock){
    bool changed = false;
    if(budgetSettings.titleLine != updatedBlock.titleLine) { changed = true; budgetSettings.titleLine = updatedBlock.titleLine; }
    if(budgetSettings.defaultBudget != updatedBlock.defaultBudget) { changed = true; budgetSettings.defaultBudget = updatedBlock.defaultBudget; }
    if(budgetSettings.showOpenOnly != updatedBlock.showOpenOnly) { changed = true; budgetSettings.showOpenOnly = updatedBlock.showOpenOnly; }
    if(budgetSettings.workplanFilename != updatedBlock.workplanFilename) { changed = true; budgetSettings.workplanFilename = updatedBlock.workplanFilename; }
    if(budgetSettings.suggestionsFilename != updatedBlock.suggestionsFilename) { changed = true; budgetSettings.suggestionsFilename = updatedBlock.suggestionsFilename; }
    if(changed) {
      setState(() {});
      _saveSettings();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(budgetSettings.titleLine)
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  AppLocalizations.of(context)!.menu,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: budgetSettings.hideLeftList ? const Icon(Icons.switch_left) : const Icon(Icons.switch_right),
              title: Text((budgetSettings.hideLeftList ? AppLocalizations.of(context)!.show : AppLocalizations.of(context)!.hide) + ' ' + AppLocalizations.of(context)!.leftListShort),
              onTap: () {
                Navigator.pop(context);
                _switchListVisibility(true);
              },
            ),
            ListTile(
              leading: budgetSettings.hideRightList ? const Icon(Icons.switch_right) : const Icon(Icons.switch_left),
              title: Text((budgetSettings.hideRightList ? AppLocalizations.of(context)!.show : AppLocalizations.of(context)!.hide) + ' ' + AppLocalizations.of(context)!.rightListShort),
              onTap: () {
                Navigator.pop(context);
                _switchListVisibility(false);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.print),
              title: Text(AppLocalizations.of(context)!.printWorkplan),
              onTap: () {
                Navigator.pop(context);
                PrintPdf().printBlockDetails(context, budgetSettings);
              },
            ),

            const Divider(),

              ListTile(
                leading: const Icon(Icons.archive),
                title: Text(AppLocalizations.of(context)!.exportAllFilesZip),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  ExportImportFiles().exportAllFilesAsZip(context, budgetSettings);
                },
              ),
              ListTile(
                leading: const Icon(Icons.unarchive),
                title: Text(AppLocalizations.of(context)!.importAllFilesZip),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  _importData();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.languageGerman),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  _showLanguage('de');
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.languageEnglish),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  _showLanguage('en');
                },
              ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                Navigator.pop(context);
                _editSettings();
              },
            ),

            SizedBox(height: 80,) // on some devices the last menu line is otherwise not touchable
          ],
        ),
      ),
      
      body: Column(
        children: [
            // Button row
            Row(
              children: [

                // Help Text, if booth lists are hidden
                if( budgetSettings.hideRightList && budgetSettings.hideLeftList)
                  Text('     ' + AppLocalizations.of(context)!.bothListsHidden, style: TextStyle(color: Colors.red, fontSize: 20), textAlign: TextAlign.center),

                // Left list buttons Add Item, Add Subitem
                if(!budgetSettings.hideLeftList)
                  ElevatedButton(
                    onPressed: () {
                      final newItemText = AppLocalizations.of(context)!.newItem;
                      setState(() {
                        leftItems.add(YearItem(text: newItemText));
                        leftExpanded.add(true);
                      });
                      _saveLeftData();
                    },
                    child: Text(AppLocalizations.of(context)!.addItemLeft),
                  ),

                if(!budgetSettings.hideLeftList)
                  ElevatedButton(
                    onPressed: selectedLeftIndex != null ? () {
                      final newSubitemText = AppLocalizations.of(context)!.newSubitem;
                      setState(() {
                        leftItems[selectedLeftIndex!].subitems.add(MonthItem(text: newSubitemText, startBudget: budgetSettings.defaultBudget));
                      });
                      _saveLeftData();
                    } : null,
                    child: Text(AppLocalizations.of(context)!.addSubitemLeft),
                  ),
                if(!budgetSettings.hideLeftList)
                  const Spacer(),

                // Copy from right list buttons
                if(!budgetSettings.hideRightList)
                  ElevatedButton(
                    onPressed: selectedRightIndex != null ? () {
                      var item = rightItems[selectedRightIndex!];
                      var newItem = YearItem(
                        text: item.text, 
                        subitems: item.subitems.map((s) => MonthItem(
                          text: s.text, 
                          startBudget: budgetSettings.defaultBudget, 
                          subitems: s.subitems.map((ss) => BookingItem(text: ss.text, value: ss.value)).toList()
                        )).toList()
                      );
                      setState(() {
                        leftItems.add(newItem);
                        leftExpanded.add(true);
                      });
                      _saveLeftData();
                    } : null,
                    child: Text(AppLocalizations.of(context)!.copyItemToLeft),
                  ),

                if(!budgetSettings.hideRightList && !budgetSettings.hideLeftList)
                  ElevatedButton(
                    onPressed: selectedRightIndex != null && selectedRightSubIndex != null && selectedLeftIndex != null ? () {
                      final s = rightItems[selectedRightIndex!].subitems[selectedRightSubIndex!];
                        setState(() {
                          leftItems[selectedLeftIndex!].subitems.add(MonthItem(
                            text: s.text, 
                            startBudget: budgetSettings.defaultBudget, 
                            subitems: s.subitems.map((ss) => BookingItem(text: ss.text, value: ss.value)).toList()
                          ));
                        });
                        _saveLeftData();
                      } : null,
                    child: Text(AppLocalizations.of(context)!.copySubitemToLeft),
                  ),
                
                if(!budgetSettings.hideRightList)
                  const Spacer(),

                // Right list buttons Add Item, Add Subitem
                if(!budgetSettings.hideRightList)
                  ElevatedButton(
                    onPressed: () {
                      final newItemText = AppLocalizations.of(context)!.newItem;
                      setState(() {
                        rightItems.add(YearItem(text: newItemText));
                        rightExpanded.add(true);
                      });
                      _saveRightData();
                    },
                    child: Text(AppLocalizations.of(context)!.addItemRight),
                  ),

                if(!budgetSettings.hideRightList)
                  ElevatedButton(
                    onPressed: selectedRightIndex != null ? () {
                      final newSubitemText = AppLocalizations.of(context)!.newSubitem;
                      setState(() {
                        rightItems[selectedRightIndex!].subitems.add(MonthItem(text: newSubitemText, startBudget: 0));
                      });
                      _saveRightData();
                    } : null,
                    child: Text(AppLocalizations.of(context)!.addSubitemRight),
                  ),
                
              ],
            ),

          Expanded(
            child: Row(
              children: [
                if(!budgetSettings.hideLeftList) 
                  Expanded(
                    child: Column(
                      children: [
                        //Text(' ', style: const TextStyle(fontSize: 12)),
                        //Text(AppLocalizations.of(context)!.leftList, style: const TextStyle(height: 1.5, fontSize: 20, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: leftItems.length,
                            itemBuilder: (context, index) {
                              var item = leftItems[index];
                              return ExpansionTile(
                                initiallyExpanded: leftExpanded[index],
                                backgroundColor: selectedLeftIndex == index ? const Color.fromARGB(255, 165, 164, 161) : null,
                                collapsedBackgroundColor: selectedLeftIndex == index ? const Color.fromARGB(255, 165, 164, 161) : null,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                childrenPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity(vertical: -4),
                                title: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedLeftIndex = index;
                                    });
                                  },
                                  onDoubleTap: () => _editText(item.text, (newText) {
                                    setState(() => item.text = newText);
                                    _saveLeftData();
                                  }),

                                  child: Row(
                                    children: [
                                      Expanded(child: Text(item.getText(), style: const TextStyle(height: 1.0, fontSize: 16, fontWeight: FontWeight.bold))),
                                      
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 22, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            leftItems.removeAt(index);
                                            leftExpanded.removeAt(index);
                                            if (selectedLeftIndex == index) selectedLeftIndex = null;
                                          });
                                          _saveLeftData();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_upward, size: 22),
                                        onPressed: index > 0 ? () {
                                          setState(() {
                                            var temp = leftItems[index];
                                            leftItems[index] = leftItems[index - 1];
                                            leftItems[index - 1] = temp;
                                            var tempExp = leftExpanded[index];
                                            leftExpanded[index] = leftExpanded[index - 1];
                                            leftExpanded[index - 1] = tempExp;
                                            selectedLeftIndex = index - 1;
                                          });
                                          _saveLeftData();
                                        } : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_downward, size: 22),
                                        onPressed: index < leftItems.length - 1 ? () {
                                          setState(() {
                                            var temp = leftItems[index];
                                            leftItems[index] = leftItems[index + 1];
                                            leftItems[index + 1] = temp;
                                            var tempExp = leftExpanded[index];
                                            leftExpanded[index] = leftExpanded[index + 1];
                                            leftExpanded[index + 1] = tempExp;
                                            selectedLeftIndex = index + 1;
                                          });
                                          _saveLeftData();
                                        } : null,
                                      ),
                                    ],
                                  ),
                                ),

                                children: item.subitems.map((sub) => ListTile(
                                  tileColor: null,  // selectedLeftIndex == index ? Color.fromARGB(255, 136, 134, 121) : null,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.circle, size: 16, color: sub.status == '(F)' ? Colors.green : Colors.yellow),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),  // reduziert die Mindestgröße
                                        splashRadius: 48,
                                        onPressed: () {
                                          setState(() { sub.changeStatus(); });
                                          _saveLeftData();
                                        },
                                      ),
                                      
                                      //Text(sub.status ?? '(P)', style: const TextStyle(height: 1.0, fontSize: 14)),

                                      const SizedBox(width: 8, height: 8),

                                      Expanded(
                                        child: GestureDetector(
                                          onDoubleTap: () => _editText(sub.text, (newText) {
                                            setState(() => sub.text = newText);
                                            _saveLeftData();
                                          }),
                                          child: Text(sub.getText(), style: const TextStyle(height: 1.0, fontSize: 16)),
                                        ),
                                      ),
                                    ],
                                  ),

                                  onTap: () {
                                    setState(() {
                                    selectedLeftIndex = index;
                                    });
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 20, color: Colors.red),
                                        onPressed: () {
                                          int subIndex = item.subitems.indexOf(sub);
                                          setState(() {
                                            item.subitems.removeAt(subIndex);
                                          });
                                          _saveLeftData();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_upward, size: 20),
                                        onPressed: () {
                                          int subIndex = item.subitems.indexOf(sub);
                                          if (subIndex > 0) {
                                            setState(() {
                                              var temp = item.subitems[subIndex];
                                              item.subitems[subIndex] = item.subitems[subIndex - 1];
                                              item.subitems[subIndex - 1] = temp;
                                            });
                                            _saveLeftData();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_downward, size: 20),
                                        onPressed: () {
                                          int subIndex = item.subitems.indexOf(sub);
                                          if (subIndex < item.subitems.length - 1) {
                                            setState(() {
                                              var temp = item.subitems[subIndex];
                                              item.subitems[subIndex] = item.subitems[subIndex + 1];
                                              item.subitems[subIndex + 1] = temp;
                                            });
                                            _saveLeftData();
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 31, height: 8), 
                                    ],
                                  ),
                                )).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                
                
                if(!budgetSettings.hideRightList)
                  Expanded(
                    child: Column(
                      children: [
                        Text(' ', style: const TextStyle(fontSize: 12)),
                        Text(AppLocalizations.of(context)!.rightList, style: const TextStyle(height: 1.5, fontSize: 20, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: rightItems.length,
                            itemBuilder: (context, index) {
                              var item = rightItems[index];
                              return ExpansionTile(
                                initiallyExpanded: rightExpanded[index],
                                backgroundColor: selectedRightIndex == index ? const Color.fromARGB(255, 136, 134, 121) : null,
                                collapsedBackgroundColor: selectedRightIndex == index ? const Color.fromARGB(255, 136, 134, 121) : null,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                                childrenPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity(vertical: -4),
                                title: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRightIndex = index;
                                      selectedRightSubIndex = null;
                                      // selectedLeftIndex = null;
                                    });
                                  },
                                  onDoubleTap: () => _editText(item.text, (newText) {
                                    setState(() => item.text = newText);
                                    _saveRightData();
                                  }),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(item.text, style: const TextStyle(height: 1.0, fontSize: 16, fontWeight: FontWeight.bold))),
                                      
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 22, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            rightItems.removeAt(index);
                                            rightExpanded.removeAt(index);
                                            if (selectedRightIndex == index) selectedRightIndex = null;
                                          });
                                          _saveRightData();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_upward, size: 22),
                                        onPressed: index > 0 ? () {
                                          setState(() {
                                            var temp = rightItems[index];
                                            rightItems[index] = rightItems[index - 1];
                                            rightItems[index - 1] = temp;
                                            var tempExp = rightExpanded[index];
                                            rightExpanded[index] = rightExpanded[index - 1];
                                            rightExpanded[index - 1] = tempExp;
                                            selectedRightIndex = index - 1;
                                          });
                                          _saveRightData();
                                        } : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_downward, size: 22),
                                        onPressed: index < rightItems.length - 1 ? () {
                                          setState(() {
                                            var temp = rightItems[index];
                                            rightItems[index] = rightItems[index + 1];
                                            rightItems[index + 1] = temp;
                                            var tempExp = rightExpanded[index];
                                            rightExpanded[index] = rightExpanded[index + 1];
                                            rightExpanded[index + 1] = tempExp;
                                            selectedRightIndex = index + 1;
                                          });
                                          _saveRightData();
                                        } : null,
                                      ),
                                    ],
                                  ),
                                ),
                                
                                children: item.subitems.map((sub) => ListTile(
                                  tileColor: selectedRightIndex == index && selectedRightSubIndex == item.subitems.indexOf(sub) ? Color.fromARGB(255, 136, 134, 121) : null,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: GestureDetector(
                                    onDoubleTap: () => _editText(sub.text, (newText) {
                                      setState(() => sub.text = newText);
                                      _saveRightData();
                                    }),
                                    child: Text(sub.text, style: const TextStyle(height: 1.0, fontSize: 16)),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedRightIndex = index;
                                      selectedRightSubIndex = item.subitems.indexOf(sub);
                                    });
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 20, color: Colors.red),
                                        onPressed: () {
                                          int subIndex = item.subitems.indexOf(sub);
                                          setState(() {
                                            item.subitems.removeAt(subIndex);
                                          });
                                          _saveRightData();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_upward, size: 20),
                                        onPressed: () {
                                          int subIndex = item.subitems.indexOf(sub);
                                          if (subIndex > 0) {
                                            setState(() {
                                              var temp = item.subitems[subIndex];
                                              item.subitems[subIndex] = item.subitems[subIndex - 1];
                                              item.subitems[subIndex - 1] = temp;
                                            });
                                            _saveRightData();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_downward, size: 20),
                                        onPressed: () {
                                          int subIndex = item.subitems.indexOf(sub);
                                          if (subIndex < item.subitems.length - 1) {
                                            setState(() {
                                              var temp = item.subitems[subIndex];
                                              item.subitems[subIndex] = item.subitems[subIndex + 1];
                                              item.subitems[subIndex + 1] = temp;
                                            });
                                            _saveRightData();
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 20, height: 8), 
                                    ],
                                  ),
                                )).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

              ]
          ),
          )
        ]
      )
    );
  }
}
