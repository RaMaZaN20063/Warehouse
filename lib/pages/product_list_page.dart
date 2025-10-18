import 'package:dmark_mobile_intership/data/hive_boxess.dart';
import 'package:dmark_mobile_intership/models/product.dart';
import 'package:dmark_mobile_intership/pages/product_form_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Box productsBox;

  @override
  void initState() {
    super.initState();
    productsBox = Hive.box(HiveBoxes.productBox);
  }

  void _deleteProduct(String key) {
    final product = Product.fromMap(productsBox.get(key));
    final updated = product.copyWith(
      isDeleted: true,
      deletedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    productsBox.put(key, updated.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Список товаров'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormPage()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: productsBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Нет товаров'));
          }

          final items = box.values
              .map((e) => Product.fromMap(Map<String, dynamic>.from(e)))
              .where((p) => !p.isDeleted)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (items.isEmpty) {
            return const Center(child: Text('Все товары удалены'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Цена: ${product.price.toStringAsFixed(0)} ₸\nСоздан: ${product.createdAt.toLocal()}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(product.id),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductFormPage(
                          existingKey: product.id,
                          existingData: product.toMap(),
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
