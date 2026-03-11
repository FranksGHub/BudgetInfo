import 'package:budget_info/models/booking_item.dart';
import 'package:budget_info/models/month_item.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/print.dart';

class EditDetailsDialog extends StatefulWidget {
  final MonthItem monthItem;
  final String yearInfo;
  final Function() onSave;

  const EditDetailsDialog({super.key, required this.monthItem, required this.yearInfo, required this.onSave});

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

  void _editText(String type) {
    TextEditingController controllerText = TextEditingController(text: '');
    String titleLine = '';
    if(type == 'finished') {
      if( widget.monthItem.status == null || widget.monthItem.status == '(P)') {
        // not finished yet, so set it to now
        widget.monthItem.changeStatus();
      }
      controllerText = TextEditingController(text: widget.monthItem.finishedAt);
      titleLine = AppLocalizations.of(context)!.editFinishedAt;
    }
    else if(type == 'budget') {
      controllerText = TextEditingController(text: widget.monthItem.startBudget.toStringAsFixed(2));
      titleLine = AppLocalizations.of(context)!.editBudgetForMonth;
    }
    else if(type == 'name') {
      controllerText = TextEditingController(text: widget.monthItem.text);
      titleLine = AppLocalizations.of(context)!.editMonthName;
    }
    else { _showError('type not found: ' + type); return; }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titleLine),
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
              if(type == 'budget' && double.tryParse(controllerText.text.replaceAll(",", ".")) == null) {
                _showError(AppLocalizations.of(context)!.noValidNumber); 
              } else {
                setState(() { 
                  if(type == 'finished') { widget.monthItem.finishedAt = controllerText.text; }
                  else if(type == 'name') { widget.monthItem.text = controllerText.text; }
                  else if(type == 'budget') { widget.monthItem.startBudget = double.parse(controllerText.text.replaceAll(",", ".")); }
                });
                widget.onSave();
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 119, 202, 126),
        title: Text('${widget.monthItem.text} - ${widget.yearInfo}'),
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
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.editMonthName),
              onTap: () {
                Navigator.pop(context);
                _editText('name');
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.editBudgetForMonth),
              onTap: () {
                Navigator.pop(context);
                _editText('budget');
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.editFinishedAt),
              onTap: () {
                Navigator.pop(context);
                _editText('finished');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.print),
              title: Text(AppLocalizations.of(context)!.printWorkplan),
              onTap: () {
                Navigator.pop(context);
                PrintPdf().printBookings(context, widget.monthItem);
              },
            ),

            SizedBox(height: 80,) // on some devices the last menu line is otherwise not touchable
          ],
        ),
      ),
      


      body: Column(
        children: [

          // Top button row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              children: [
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

          // List without Subitems, each line is a ListTile with two buttons
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

                        IconButton( icon: const Icon(Icons.edit, size: 20, color: Colors.green), onPressed: () { _editItem(item); }, ),

                        IconButton( icon: const Icon(Icons.remove_circle_outline_rounded, size: 22, color: Colors.red), 
                          onPressed: () { 
                            setState(() {
                              widget.monthItem.subitems.removeAt(index);
                              if (selectedIndex == index) { selectedIndex = null;
                              } else if (selectedIndex != null && selectedIndex! > index) { selectedIndex = selectedIndex! - 1; }
                              widget.onSave();
                            });
                          }, 
                        ),
                    
                        const SizedBox(width: 22),
                        
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