import 'package:budget_info/models/booking_item.dart';
import 'package:budget_info/models/month_item.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class EditDetailsDialog extends StatefulWidget {
  final MonthItem monthItem;
  final Function() onSave;

  const EditDetailsDialog({super.key, required this.monthItem, required this.onSave});

  @override
  State<EditDetailsDialog> createState() => _EditDetailsDialogState();
}

class _EditDetailsDialogState extends State<EditDetailsDialog> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showError(String message) {
    if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 2)));}
  }

  void _editItem(BookingItem item) {
    BookingItem newItem = new BookingItem(text: item.text, value: item.value);
    TextEditingController controllerText = TextEditingController(text: newItem.text);
    TextEditingController controllerValue = TextEditingController(text: newItem.value.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editBooking),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField( controller: controllerText, autofocus: true, ),
            TextField( controller: controllerValue,),
          ]
        ),
        
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),

          TextButton(
            onPressed: () {
              final parsed = double.tryParse(controllerValue.text.replaceAll(",", "."));
              if (parsed == null) { _showError(AppLocalizations.of(context)!.noValidNumber); }
              else {
                setState(() {
                  item.value = double.parse(controllerValue.text.replaceAll(",", "."));
                  item.text = controllerText.text;
                 });
                widget.onSave();
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _editText() {
    TextEditingController controllerText = TextEditingController(text: widget.monthItem.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editMonthName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField( controller: controllerText, autofocus: true, ),
          ]
        ),
        
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),

          TextButton(
            onPressed: () {
              setState(() { widget.monthItem.text = controllerText.text; });
                widget.onSave();
                Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 119, 202, 126),
        title: Text('${AppLocalizations.of(context)!.settings}: ${widget.monthItem.text}'),
      ),
      body: Column(
        children: [
          // Top button row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() { _editText(); });
                    widget.onSave();
                  },
                  child: Text(AppLocalizations.of(context)!.editMonthName),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.monthItem.subitems.add(BookingItem(text: '?', value: 0));
                    });
                    widget.onSave();
                  },
                  child: Text(AppLocalizations.of(context)!.newBudgetItem),
                ),

                const Spacer(),
              ],
            ),
          ),

          // Liste ohne Subitems, jede Zeile ist eine ListTile mit zwei Buttons
          Expanded(
            child: ListView.builder(
              itemCount: widget.monthItem.subitems.length,
              itemBuilder: (context, index) {
                final item = widget.monthItem.subitems[index];
                final isSelected = selectedIndex == index;

                return Container(
                  color: isSelected ? const Color.fromARGB(255, 218, 218, 218) : null,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: GestureDetector(
                      onTap: () { setState(() { selectedIndex = index; });},
                      onDoubleTap: () { _editItem(item); },
                      child: Text(
                        item.getText(),
                        style: const TextStyle(height: 1.0, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
                          onPressed: () { _editItem(item); },
                        ),

                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded, size: 22, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.monthItem.subitems.removeAt(index);
                              if (selectedIndex == index) {
                                selectedIndex = null;
                              } else if (selectedIndex != null && selectedIndex! > index) {
                                selectedIndex = selectedIndex! - 1;
                              }
                              widget.onSave();
                            });
                          },
                        ),
                        
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}