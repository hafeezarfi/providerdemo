import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => BreadcrumbProvider(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/new': (context) => const NewBreadcrumbWidget(),
      },
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class Breadcrumb {
  bool isActive;
  final String name;
  final String uuid;

  Breadcrumb({
    required this.isActive,
    required this.name,
  }) : uuid = const Uuid().v4();

  void active() {
    isActive = true;
  }

  @override
  bool operator ==(covariant Breadcrumb other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (isActive ? '> ' : '');
}

class BreadcrumbProvider extends ChangeNotifier {
  final List<Breadcrumb> _items = [];
  UnmodifiableListView<Breadcrumb> get items => UnmodifiableListView(_items);

  void add(Breadcrumb breadcrumb) {
    for (final item in _items) {
      item.active();
    }
    _items.add(breadcrumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadcrumbWidget extends StatelessWidget {
  final UnmodifiableListView<Breadcrumb> breadcrumbs;
  const BreadcrumbWidget({super.key, required this.breadcrumbs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadcrumbs.map((breadcrumb) {
        return Text(
          breadcrumb.title,
          style: TextStyle(
            color: breadcrumb.isActive ? Colors.blue : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Consumer<BreadcrumbProvider>(
            builder: (context, value, child) {
              return BreadcrumbWidget(
                breadcrumbs: value.items,
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/new',
              );
            },
            child: const Text('Add new breadcrumb'),
          ),
          TextButton(
            onPressed: () {
              context.read<BreadcrumbProvider>().reset();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class NewBreadcrumbWidget extends StatefulWidget {
  const NewBreadcrumbWidget({super.key});

  @override
  State<NewBreadcrumbWidget> createState() => _NewBreadcrumbWidgetState();
}

class _NewBreadcrumbWidgetState extends State<NewBreadcrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new breadcrumb'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a new breadcrumb here',
            ),
          ),
          TextButton(
            onPressed: () {
              final text = _controller.text;
              if (text.isNotEmpty) {
                final breadcrumb = Breadcrumb(isActive: false, name: text);
                context.read<BreadcrumbProvider>().add(breadcrumb);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
