import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  // Ambil daftar kategori dari backend
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories();
    } catch (e) {
      // Handle error jika diperlukan
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambah kategori baru (Khusus Owner)
  Future<bool> addCategory(String name, String type, Function(String, bool) onFinished) async {
    _isLoading = true;
    notifyListeners();

    final result = await _categoryService.createCategory(name, type);

    _isLoading = false;
    notifyListeners();

    if (result['success']) {
      await fetchCategories(); // Refresh daftar kategori setelah berhasil menambah
      onFinished(result['message'], true);
      return true;
    } else {
      onFinished(result['message'], false);
      return false;
    }
  }

  // Hapus kategori (Khusus Owner)
  Future<bool> removeCategory(int id, Function(String, bool) onFinished) async {
    final result = await _categoryService.deleteCategory(id);

    if (result['success']) {
      _categories.removeWhere((cat) => cat.id == id);
      notifyListeners();
      onFinished(result['message'], true);
      return true;
    } else {
      onFinished(result['message'], false);
      return false;
    }
  }
}