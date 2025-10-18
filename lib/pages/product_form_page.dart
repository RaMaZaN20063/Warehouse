import 'package:dmark_mobile_intership/data/hive_boxess.dart';
import 'package:dmark_mobile_intership/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProductFormPage extends StatefulWidget {
  final String? existingKey;
  final Map? existingData;

  const ProductFormPage({this.existingKey, this.existingData});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _gtinCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final product = Product.fromMap(widget.existingData!);
      _nameCtrl.text = product.name;
      _gtinCtrl.text = product.gtin;
      _priceCtrl.text = product.price.toString();
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box(HiveBoxes.productBox);

      final now = DateTime.now();
      final id = widget.existingKey ?? now.toIso8601String();

      final product = Product(
        id: id,
        name: _nameCtrl.text,
        gtin: _gtinCtrl.text,
        price: double.parse(_priceCtrl.text),
        createdAt: widget.existingData != null
            ? DateTime.parse(widget.existingData!['createdAt'])
            : now,
        updatedAt: now,
      );

      box.put(id, product.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.existingData == null ? 'Добавить товар' : 'Редактировать товар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Название товара'),
                validator: (v) => v!.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _gtinCtrl,
                decoration: const InputDecoration(labelText: 'GTIN (13 цифр)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Введите GTIN';
                  if (v.length != 13 || !RegExp(r'^\d+$').hasMatch(v))
                    return 'GTIN должен быть из 13 цифр';
                  return null;
                },
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Цена (₸)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Введите цену' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
