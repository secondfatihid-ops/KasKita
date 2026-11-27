import 'package:material_ui/material_ui.dart';

import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Ambil daftar kategori dari backend
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tambah kategori baru (Khusus Owner)
  Future<bool> addCategory(
    String name,
    String type,
    Function(String, bool) onFinished,
  ) async {
    _isLoading = true;
    notifyListeners();

    late final Map<String, dynamic> result;
    try {
      result = await _categoryService.createCategory(name, type);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    if (result['success']) {
      await fetchCategories(); // Refresh daftar kategori setelah berhasil menambah
      onFinished(result['message'], true);
      return true;
    } else {
      onFinished(result['message'], false);
      return false;
    }
  }

  Future<bool> updateCategory(
    int id,
    String name,
    String type,
    Function(String, bool) onFinished,
  ) async {
    _isLoading = true;
    notifyListeners();
    late final Map<String, dynamic> result;
    try {
      result = await _categoryService.updateCategory(id, name, type);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    if (result['success']) {
      await fetchCategories();
      onFinished(result['message'], true);
      return true;
    } else {
      onFinished(result['message'], false);
      return false;
    }
  }

  Future<bool> deleteCategory(int id, Function(String, bool) onFinished) async {
    final result = await _categoryService.deleteCategory(id);
    if (result['success']) {
      _categories.removeWhere((category) => category.id == id);
      notifyListeners();
      onFinished(result['message'], true);
      return true;
    }
    onFinished(result['message'], false);
    return false;
  }
}
