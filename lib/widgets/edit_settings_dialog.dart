import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/budget_settings.dart';
import '../models/filename_helper.dart';
import '../l10n/app_localizations.dart';
import 'dart:async';

class EditSettingsDialog extends StatefulWidget {
  final BudgetSettings settings;
  final Function(BudgetSettings) onSave;

  const EditSettingsDialog({super.key, required this.settings, required this.onSave});

  @override
  State<EditSettingsDialog> createState() => _EditSettingsDialogState();
}

class _EditSettingsDialogState extends State<EditSettingsDialog> {
  late TextEditingController titleLineController;
  late TextEditingController budgetController;
  late TextEditingController leftListFilenameController;
  late TextEditingController rightListFilenameController;
  late bool showOpenOnly;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    titleLineController = TextEditingController(text: widget.settings.titleLine.length == 0 ? 'Budget Info' : widget.settings.titleLine);
    budgetController = TextEditingController(text: widget.settings.defaultBudget.toString());
    showOpenOnly = widget.settings.showOpenOnly;
    leftListFilenameController = TextEditingController(text: widget.settings.workplanFilename.length == 0 ? FilenameHelper.getDefaultLeftFilename(false) : widget.settings.workplanFilename);
    rightListFilenameController = TextEditingController(text: widget.settings.suggestionsFilename.length == 0 ? FilenameHelper.getDefaultRightFilename(false) : widget.settings.suggestionsFilename);
    titleLineController.addListener(() { _onSettingChanged(); });
    budgetController.addListener(() { _onSettingChanged(); });
    leftListFilenameController.addListener(() { _onSettingChanged(); });
    rightListFilenameController.addListener(() { _onSettingChanged(); });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    titleLineController.dispose();
    budgetController.dispose();
    leftListFilenameController.dispose();
    rightListFilenameController.dispose();
    super.dispose();
  }

  void _onSettingChanged() { 
    if (_debounce?.isActive ?? false) _debounce!.cancel(); 
    _debounce = Timer(const Duration(milliseconds: 900), () { 
      // this happens after the timer elapsed
      // e.g. validiate, store, setState, and so on })
      _debounce!.cancel();
      bool changed = false;
      
      if(widget.settings.titleLine != titleLineController.text) { changed = true; widget.settings.titleLine = titleLineController.text; }
      
      if(widget.settings.defaultBudget != budgetController.text) { changed = true; widget.settings.defaultBudget = double.parse(budgetController.text); }
      
      if(widget.settings.workplanFilename != leftListFilenameController.text) { 
        if( FilenameHelper.getDefaultLeftFilename(false) == leftListFilenameController.text) {
          if(widget.settings.workplanFilename.length != 0) { changed = true; widget.settings.workplanFilename = ''; }
          } else { 
          changed = true; widget.settings.workplanFilename = leftListFilenameController.text; 
        }
      }
      
      if(widget.settings.suggestionsFilename != rightListFilenameController.text) { 
        if( FilenameHelper.getDefaultRightFilename(false) == rightListFilenameController.text) {
          if(widget.settings.suggestionsFilename.length != 0) { changed = true; widget.settings.suggestionsFilename = ''; }
          } else { 
          changed = true; widget.settings.suggestionsFilename = rightListFilenameController.text; 
        }
      }
      
      if(changed) {
        setState(() {});
        widget.onSave(widget.settings);
      }
    });
  }

  void _onSettingChangedDirectly() { 
    bool changed = false;
    if(widget.settings.showOpenOnly != showOpenOnly) { changed = true; widget.settings.showOpenOnly = showOpenOnly; }
    if(changed) {
      setState(() {});
      widget.onSave(widget.settings);
    }
  }

  Widget _buildSettingRow({ required String label, required TextEditingController controller,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 6),
          SizedBox( width: 120, child: Text(label)),
          //Expanded( flex: 2, child: Text(label)),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                isDense: true, // macht das TextField kompakter
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSettingIntegerRow({ required String label, required String? hint, required TextEditingController controller,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 6),
          SizedBox( width: 120, child: Text(label)),
          //Expanded( flex: 2, child: Text(label)),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "",
                hintText: hint,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) { return AppLocalizations.of(context)!.enterAValue; }
                // Keine Tausendertrennzeichen erlaubt
                if (value.contains(RegExp(r'\d[.,]\d{3}[.,]'))) { return AppLocalizations.of(context)!.noThousandsSep; }
                // Komma oder Punkt → einheitlich Punkt
                final normalized = value.replaceAll(",", ".");
                // Prüfen, ob es eine gültige Dezimalzahl ist
                final parsed = double.tryParse(normalized);
                if (parsed == null) { return AppLocalizations.of(context)!.noValidNumber; }
                if (parsed < 0) { return AppLocalizations.of(context)!.noNegativeNumbers; }  // should not be possible
                return null;
              },
            )
          )
        ]
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( title: Text(AppLocalizations.of(context)!.settings)), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 

            // 2 Text lines
            _buildSettingRow(
              label: AppLocalizations.of(context)!.editTitle,
              controller: titleLineController,
            ),
            _buildSettingIntegerRow(
              label: AppLocalizations.of(context)!.editBudget,
              hint: AppLocalizations.of(context)!.editBudgetHint,
              controller: budgetController,
            ),
            _buildSettingRow(
              label: AppLocalizations.of(context)!.workplanFilename,
              controller: leftListFilenameController,
            ),
            _buildSettingRow(
              label: AppLocalizations.of(context)!.suggestionsFilename,
              controller: rightListFilenameController,
            ),

            //const SizedBox(height: 8),

            // Checkbox for notes setting
            Row(
              children: [
                const SizedBox(width: 122),
                Checkbox(
                  value: showOpenOnly,
                  onChanged: (value) { showOpenOnly = value ?? false; _onSettingChangedDirectly(); }
                ),
                Text(AppLocalizations.of(context)!.showOpenOnly),
              ],
            ),

          ],
        ),
      ),
    );
  }
}