import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final title = TextEditingController();
  final note = TextEditingController();

  TaskCategory category = TaskCategory.study;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  bool reminder = false;
  bool error = false;

  @override
  void dispose() {
    title.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (result != null && mounted) {
      setState(() => date = result);
    }
  }

  Future<void> pickTime() async {
    final result = await showTimePicker(context: context, initialTime: time);

    if (result != null && mounted) {
      setState(() => time = result);
    }
  }

  void saveTask() {
    if (title.text.trim().isEmpty) {
      setState(() => error = true);
      return;
    }

    final task = TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.text.trim(),
      note: note.text.trim(),
      category: category,
      dateTime: DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
      reminder: reminder,
    );

    context.read<TaskProvider>().addTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 50,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Նոր առաջադրանք',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                    ),

                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25413D),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFFB5D4CE),
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),

                _label('ՎԵՐՆԱԳԻՐ'),

                TextField(
                  controller: title,
                  onChanged: (_) {
                    if (error) {
                      setState(() => error = false);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Գրիր առաջադրանքի անունը',
                    errorText: error ? 'Վերնագիրը պարտադիր է' : null,
                  ),
                ),

                _label('ՆՇՈՒՄ'),

                TextField(
                  controller: note,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Ավելացրու նշում (ոչ պարտադիր)',
                  ),
                ),

                _label('ԿԱՏԵԳՈՐԻԱ'),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: TaskCategory.values.map((item) {
                    final selected = category == item;

                    return ChoiceChip(
                      label: Text(item.label),
                      selected: selected,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                      selectedColor: AppTheme.green,
                      backgroundColor: AppTheme.background,
                      side: BorderSide(
                        color: selected ? AppTheme.green : AppTheme.border,
                      ),
                      labelStyle: TextStyle(
                        color: selected ? AppTheme.background : AppTheme.muted,
                      ),
                      onSelected: (_) {
                        setState(() => category = item);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pickDate,
                        icon: const Icon(Icons.calendar_month),
                        label: Text('${date.day}/${date.month}/${date.year}'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 35, 72, 63),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pickTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(time.format(context)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 35, 72, 63),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Հիշեցում'),
                  value: reminder,
                  activeColor: AppTheme.green,
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 35, 72, 63),
                  ),
                  onChanged: (value) {
                    setState(() => reminder = value);
                  },
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: FilledButton(
                    onPressed: saveTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      foregroundColor: AppTheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Ավելացնել',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.green,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
