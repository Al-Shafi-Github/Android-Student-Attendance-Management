import 'package:flutter/material.dart';
import 'db_helper.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final nameController = TextEditingController();
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  void loadStudents() async {
    final data = await DBHelper.getStudents();
    if (mounted) {
      setState(() { students = data; });
    }
  }

  void addStudent() async {
    if (nameController.text.isEmpty) return;
    await DBHelper.addStudent(nameController.text);
    nameController.clear();
    loadStudents();
  }

  void editStudent(int id, String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Student'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              await DBHelper.updateStudent(id, controller.text);
              if (mounted) {
                Navigator.pop(context);
                loadStudents();
              }
            },
            child: const Text('Update'),
          )
        ],
      )
    );
  }

  void deleteStudent(int id) async {
    await DBHelper.deleteStudent(id);
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Class Attendance Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: addStudent, child: const Text('Add')),
            ]),
            const SizedBox(height: 20),
            Expanded(
              child: students.isEmpty ? const Center(child: Text('No students added'))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      child: ListTile(
                        title: Text(student['name']),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(icon: const Icon(Icons.edit), onPressed: () => editStudent(student['id'], student['name'])),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteStudent(student['id'])),
                        ]),
                      ),
                    );
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}
