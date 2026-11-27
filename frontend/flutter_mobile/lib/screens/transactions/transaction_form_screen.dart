import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  int? _selectedCategoryId;
  String _selectedType = 'expense';
  File? _receiptImage;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    if (transaction != null) {
      _amountController.text = transaction.amount.toString();
      _descriptionController.text = transaction.description ?? '';
      _selectedCategoryId = transaction.categoryId;
      _selectedType = transaction.categoryType ?? 'expense';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CategoryController>().fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickReceiptImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        setState(() => _receiptImage = File(image.path));
      }
    } on PlatformException catch (error) {
      if (mounted) {
        _showSnackBar(
          'Tidak dapat memilih gambar: ${error.message}',
          Colors.red,
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryId = _selectedCategoryId;
    if (categoryId == null) {
      _showSnackBar('Pilih kategori terlebih dahulu', Colors.red);
      return;
    }

    final controller = context.read<TransactionController>();
    final amount = double.parse(_amountController.text.trim());
    void onFinished(String message, bool succeeded) {
      if (!succeeded && mounted) _showSnackBar(message, Colors.red);
    }

    final transaction = widget.transaction;
    final success = transaction == null
        ? await controller.addTransaction(
            categoryId: categoryId,
            amount: amount,
            description: _descriptionController.text.trim(),
            receiptImage: _receiptImage,
            onFinished: onFinished,
          )
        : await controller.updateTransaction(
            id: transaction.id,
            categoryId: categoryId,
            amount: amount,
            description: _descriptionController.text.trim(),
            receiptImage: _receiptImage,
            onFinished: onFinished,
          );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            transaction == null
                ? 'Transaksi berhasil ditambahkan'
                : 'Transaksi berhasil diperbarui',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = context.watch<TransactionController>();
    final categoryController = context.watch<CategoryController>();
    final categories = categoryController.categories
        .where((category) => category.type == _selectedType)
        .toList();
    final selectedCategoryId =
        categories.any((category) => category.id == _selectedCategoryId)
        ? _selectedCategoryId
        : null;
    final isEdit = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleButtons(
                  isSelected: [
                    _selectedType == 'expense',
                    _selectedType == 'income',
                  ],
                  onPressed: (index) {
                    setState(() {
                      _selectedType = index == 0 ? 'expense' : 'income';
                      _selectedCategoryId = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _selectedType == 'expense'
                      ? Colors.red
                      : Colors.green,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 44,
                    minWidth: 120,
                  ),
                  children: const [Text('Pengeluaran'), Text('Pemasukan')],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _amountController,
                  label: 'Nominal (Rp)',
                  icon: Icons.attach_money,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final amount = double.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Masukkan nominal lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: const Icon(Icons.category, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                  validator: (value) =>
                      value == null ? 'Pilih kategori terlebih dahulu' : null,
                ),
                if (categoryController.error != null &&
                    categoryController.categories.isEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat kategori: ${categoryController.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: categoryController.fetchCategories,
                    child: const Text('Coba lagi'),
                  ),
                ] else if (categories.isEmpty &&
                    !categoryController.isLoading) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Belum ada kategori untuk jenis ini.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Catatan (Opsional)',
                  icon: Icons.note,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: _pickReceiptImage,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(
                    _receiptImage == null
                        ? 'Pilih foto nota'
                        : 'Ganti foto nota',
                  ),
                ),
                if (_receiptImage != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _receiptImage!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ] else if (isEdit &&
                    widget.transaction!.receiptImage != null &&
                    widget.transaction!.receiptImage!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.transaction!.receiptImage!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Text('Foto nota sebelumnya tidak tersedia.'),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                CustomButton(
                  text: isEdit ? 'Simpan Perubahan' : 'Tambah Transaksi',
                  isLoading: transactionController.isLoading,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
