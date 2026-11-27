import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class CategoryFormScreen extends StatefulWidget {
  final CategoryModel?
  category; // Jika null berarti Mode Tambah, jika ada isi berarti Mode Edit

  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // Contoh tipe kategori: 'income' (pemasukan) atau 'expense' (pengeluaran)
  String _selectedType = 'expense';

  @override
  void initState() {
    super.initState();
    // Jika dalam mode edit, isi form dengan data yang sudah ada
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedType = widget
          .category!
          .type; // Pastikan model kategori memiliki properti 'type'
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final categoryController = Provider.of<CategoryController>(
        context,
        listen: false,
      );

      bool success;
      if (widget.category == null) {
        // Logika Tambah Kategori Baru
        success = await categoryController.addCategory(
          _nameController.text.trim(),
          _selectedType,
          (message, succeeded) {
            if (!succeeded) _showSnackBar(message, Colors.red);
          },
        );
      } else {
        // Logika Edit Kategori
        success = await categoryController.updateCategory(
          widget.category!.id, // Pastikan model kategori memiliki properti 'id'
          _nameController.text.trim(),
          _selectedType,
          (message, succeeded) {
            if (!succeeded) _showSnackBar(message, Colors.red);
          },
        );
      }

      if (success && mounted) {
        _showSnackBar(
          widget.category == null
              ? 'Kategori berhasil ditambahkan'
              : 'Kategori berhasil diperbarui',
          Colors.green,
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya (List Kategori)
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Provider.of<CategoryController>(context);
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kategori' : 'Tambah Kategori'),
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
                Text(
                  isEdit ? 'Perbarui Informasi Kategori' : 'Buat Kategori Baru',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tentukan nama dan jenis kategori untuk pencatatan keuanganmu.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Kategori',
                  icon: Icons.category,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Pilihan Tipe Kategori (Pemasukan / Pengeluaran)
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Jenis Kategori',
                    prefixIcon: const Icon(Icons.swap_vert, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'expense',
                      child: Text('Pengeluaran (Expense)'),
                    ),
                    DropdownMenuItem(
                      value: 'income',
                      child: Text('Pemasukan (Income)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: isEdit ? 'Simpan Perubahan' : 'Tambah Kategori',
                  isLoading: categoryController.isLoading,
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
