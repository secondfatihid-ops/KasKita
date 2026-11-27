import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import 'auth_service.dart';

class CategoryService {
  final String baseUrl = 'http://10.0.2.2:3000/api';
  final AuthService _authService = AuthService();

  // Ambil semua daftar kategori
  Future<List<CategoryModel>> getCategories() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat kategori');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Tambah kategori baru (Khusus Owner)
  Future> createCategory(String name, String type) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'type': type, // 'income' atau 'expense'
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Kategori berhasil ditambahkan', 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menambah kategori'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Hapus kategori (Khusus Owner)
  Future> deleteCategory(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Kategori berhasil dihapus'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghapus kategori'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}