import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? transaction; // Jika null = Tambah, jika ada = Edit

  const TransactionFormScreen({Key? key, this.transaction}) : super(key: key);

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategoryId;
  String _selectedType = 'expense'; // Default tipe: expense atau income
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Ambil daftar kategori saat halaman dimuat agar dropdown kategori terisi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryController>(context, listen: false).fetchCategories();
    });

    // Jika mode edit, isi form dengan data transaksi sebelumnya
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _descriptionController.text = widget.transaction!.description ?? '';
      _selectedType = widget.transaction!.type;
      _selectedCategoryId = widget.transaction!.categoryId;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih kategori terlebih dahulu'), backgroundColor: Colors.red),
        );
        return;
      }

      final transactionController = Provider.of<TransactionController>(context, listen: false);
      final double amount = double.tryParse(_amountController.text) ?? 0.0;

      bool success;
      if (widget.transaction == null) {
        // Tambah transaksi baru
        success = await transactionController.addTransaction(
          title: _titleController.text.trim(),
          amount: amount,
          type: _selectedType,
          categoryId: _selectedCategoryId!,
          date: _selectedDate,
          description: _descriptionController.text.trim(),
          onError: (errorMessage) {
            _showSnackBar(errorMessage, Colors.red);
          },
        );
      } else {
        // Edit transaksi
        success = await transactionController.updateTransaction(
          id: widget.transaction!.id,
          title: _titleController.text.trim(),
          amount: amount,
          type: _selectedType,
          categoryId: _selectedCategoryId!,
          date: _selectedDate,
          description: _descriptionController.text.trim(),
          onError: (errorMessage) {
            _showSnackBar(errorMessage, Colors.red);
          },
        );
      }

      if (success && mounted) {
        _showSnackBar(
          widget.transaction == null ? 'Transaksi berhasil ditambahkan' : 'Transaksi berhasil diperbarui',
          Colors.green,
        );
        Navigator.pop(context);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context);
    final categoryController = Provider.of<CategoryController>(context);
    final isEdit = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pilihan Tipe Transaksi (Income / Expense)
                ToggleButtons(
                  isSelcted: [_selectedType == 'expense', _selectedType == 'income'], // Perhatikan sesuaikan getter/setter state
                  isSelected: [_selectedType == 'expense', _selectedType == 'income'],
                  onPressed: (index) {
                    setState(() {
                      _selectedType = index == 0 ? 'expense' : 'income';
                      _selectedCategoryId = null; // Reset kategori saat tipe berubah
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _selectedType == 'expense' ? Colors.red : Colors.green,
                  color: Colors.black,
                  constraints: const BoxConstraints(minHeight: 40, minWidth: 150),
                  children: const [
                    Text('Pengeluaran', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Pemasukan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _titleController,
                  label: 'Judul Transaksi',
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  label: 'Nominal (Rp)',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nominal tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Dropdown Kategori berdasarkan tipe yang dipilih
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: const Icon(Icons.category, color: Colors.blue),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: categoryController.categories
                      .where((cat) => cat.type == _selectedType)
                      .map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih kategori terlebih dahulu' : null,
                ),
                const SizedBox(height: 16),
                // Pilihan Tanggal
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Pilih Tanggal'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Catatan (Opsional)',
                  icon: Icons.note,
                  maxLines: 3,
                ),
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