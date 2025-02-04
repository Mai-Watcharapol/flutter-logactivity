import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'db/database_provider.dart';
import 'db/db_factory.dart';
import 'db/item.dart';
import 'log/LogType.dart';
import 'log/log_service.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late LogService logService;
  String logFilePath = '';
  String logFileDate = '';

  @override
  void initState() {
    super.initState();
    logService = LogService();
    logService.logInit().then((_) {
      setState(() {
        logFilePath = logService.getLogFilePath;
        logFileDate = logService.getLogFileDate;
      });
    });
    ref.read(isarServiceProvider).startIsar().then((_) {
      ref.refresh(itemsProvider);
    });
  }

  void _removeItem(Id itemId) {
    ref.read(removeItemProvider(itemId).future).then((_) {
      logService.addInfo(
          LogType.DB_Delete,
          'Item with ID $itemId removed',
          isWrite: true
      );
      ref.refresh(itemsProvider);
    });
  }

  void _editItem(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: item.name),
                onChanged: (value) {
                  item.name = value;
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: TextEditingController(
                    text: item.quantity?.toString()),
                onChanged: (value) {
                  item.quantity = int.tryParse(value);
                },
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ref.read(updateItemProvider(item).future).then((_) {
                  logService.addInfo(
                      LogType.DB_Update,
                      'Item with ID ${item.id} updated. Name: ${item
                          .name}, Quantity: ${item.quantity}',
                      isWrite: true
                  );
                  Navigator.pop(context);
                  ref.refresh(itemsProvider);
                });
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String generateRandomFruitName(int wordCount) {
    const fruitNames = [
      "Apple",
      "Banana",
      "Mango",
      "Orange",
      "Grape",
      "Watermelon",
      "Pineapple",
      "Strawberry",
      "Peach",
      "Blueberry",
      "Cherry",
      "Papaya",
      "Kiwi",
      "Lemon",
      "Lychee",
      "Coconut",
      "Plum",
      "Apricot",
      "Pear"
    ];
    final random = Random();
    return List.generate(
        wordCount, (_) => fruitNames[random.nextInt(fruitNames.length)]).join(
        ' ');
  }

  void _addItem() {
    var num = Random().nextInt(50);
    final newItem = Item()
      ..name = generateRandomFruitName(1)
      ..quantity = num;
    ref.read(addItemProvider(newItem).future).then((_) {
      logService.addInfo(
          LogType.DB_Insert,
          'New item with ID ${newItem.id} and Name: ${newItem
              .name}, Quantity: $num added',
          isWrite: true
      );
      ref.refresh(itemsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsyncValue = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Log File Path and Date
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log File Path: $logFilePath',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Log File Date: $logFileDate'),
                  ],
                ),
              ),
            ),
            // ListView for items
            Expanded(
              child: itemsAsyncValue.when(
                data: (items) =>
                    ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.name ?? 'No name'),
                          subtitle: Text('Quantity: ${item.quantity ?? 0}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editItem(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeItem(item.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),
            ),
          ],
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
