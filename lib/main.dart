import 'package:flutter/material.dart';
import 'widgets/item.dart';
import 'database/database.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    retrieveItems();
  }

  void retrieveItems() async {
    List<Item> itemList = await dbController.items();
    setState(() {
      items = itemList;
    });
  }

  void _addItem() async {
    Item newItem = Item(description: "", checked: false);
    await dbController.insertItem(newItem);
    retrieveItems();
  }

  void _updateItem(String newDescription, bool checked, int id) async {
    await dbController.updateItemDescription(newDescription, checked, id);
    retrieveItems();
  }

  void _deleteItem(int id) async {
    await dbController.deleteItem(id); // Assuming you have a method to delete by ID in your database
    retrieveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ClipRect (
          child: SizedBox(
            width: 500.0,
            height: 600.0,
            child: Stack(
              children: <Widget>[
                if (items.isEmpty)
                  const Text(
                    "Add a task to get started!",
                    style: TextStyle(
                      fontSize: 25,
                      
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ListView(
                  children: items.map((item) {
                    return ToDoItem(
                      id: item.id ?? 0, // Pass item's ID
                      description: item.description,
                      onEdit: (id, newDescription, checked) => _updateItem(newDescription, checked, id),
                      checked: item.checked, 
                      onDelete: _deleteItem, // Pass deletion handler
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
