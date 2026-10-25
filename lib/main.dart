import 'package:flutter/material.dart';

// จุดเริ่มต้นของแอพ
void main() {
  runApp(const MyApp());
}

// ตั้งค่าหน้าตาโดยรวมของแอพ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

// ข้อมูลของสิ่งของหนึ่งรายการ
class Todo {
  Todo({
    required this.title,
    this.isDone = false,
  });

  final String title;
  bool isDone;
}

// หน้าจอที่ข้อมูลเปลี่ยนได้
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // ใช้อ่านและล้างข้อความในช่องกรอก
  final TextEditingController taskController =
      TextEditingController();

  // รายการสิ่งของที่ต้องเตรียม
  final List<Todo> todos = [
    Todo(title: 'เสื้อผ้า'),
    Todo(title: 'ที่ชาร์จโทรศัพท์'),
  ];

  // เพิ่มสิ่งของใหม่
  void addTodo() {
    // อ่านข้อความและตัดช่องว่างหัวท้าย
    final String text = taskController.text.trim();

    // ถ้าไม่มีข้อความ ให้หยุดทำงานตรงนี้
    if (text.isEmpty) {
      return;
    }

    // เปลี่ยนข้อมูลและแจ้งให้หน้าจออัปเดต
    setState(() {
      todos.add(
        Todo(title: text),
      );
    });

    // ล้างช่องกรอกเพื่อเตรียมพิมพ์รายการต่อไป
    taskController.clear();
  }

  // เปลี่ยนสถานะเตรียมแล้ว / ยังไม่เตรียม
  void toggleTodo(Todo todo, bool isDone) {
    setState(() {
      todo.isDone = isDone;
    });
  }

  // ลบสิ่งของที่เลือกออกจากรายการ
  void removeTodo(Todo todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  // คืนทรัพยากรเมื่อหน้าจอนี้ถูกนำออก
  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  // ประกอบหน้าจอจากข้อมูลปัจจุบัน
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กระเป๋าพร้อมเที่ยว'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'เตรียมของให้พร้อมก่อนออกเดินทาง',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // ช่องกรอกสิ่งของที่ต้องเตรียม
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'ของที่ต้องเตรียม',
                  hintText: 'เช่น เสื้อผ้า ที่ชาร์จ ยาประจำตัว',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // ปุ่มเพิ่มสิ่งของ
              ElevatedButton(
                onPressed: addTodo,
                child: const Text('เพิ่มของ'),
              ),
              const SizedBox(height: 16),

              // ส่วนแสดงรายการ ใช้พื้นที่ที่เหลือ
              Expanded(
                child: todos.isEmpty
                    ? const Center(
                        child: Text(
                          'ยังไม่มีของที่ต้องเตรียม ลองเพิ่มรายการแรกกัน!',
                        ),
                      )
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final Todo todo = todos[index];

                          return Card(
                            key: ObjectKey(todo),
                            child: ListTile(
                              leading: Checkbox(
                                value: todo.isDone,
                                onChanged: (value) {
                                  toggleTodo(
                                    todo,
                                    value ?? false,
                                  );
                                },
                              ),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                                tooltip: 'ลบรายการ',
                                onPressed: () {
                                  removeTodo(todo);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}