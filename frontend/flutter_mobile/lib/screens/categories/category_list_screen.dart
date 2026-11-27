import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';
import 'category_form_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat daftar kategori saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryController>(context, listen: false).fetchCategories();
    });
  }

  void _confirmDelete(BuildContext context, String categoryId, String categoryName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Apakah kamu yakin ingin menghapus kategori "$categoryName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final categoryController = Provider.of<CategoryController>(context, listen: false);
              bool success = await categoryController.deleteCategory(categoryId, (errorMessage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                );
              });

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kategori berhasil dihapus'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kategori'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          if (categoryController.isLoading && categoryController.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categoryController.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada kategori',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CategoryFormScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Kategori'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => categoryController.fetchCategories(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) {
                final CategoryModel category = categoryController.categories[index];
                final bool isIncome = category.type == 'income';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isIncome ? 'Pemasukan (Income)' : 'Pengeluaran (Expense)',
                      style: TextStyle(
                        color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryFormScreen(category: category),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, category.id, category.name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}