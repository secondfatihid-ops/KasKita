import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import 'auth_service.dart';

class TransactionService {
  final String baseUrl = 'http://10.0.2.2:3000/api';
  final AuthService _authService = AuthService();

  // Ambil semua daftar transaksi
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar transaksi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Tambah transaksi baru (mendukung upload gambar nota via multipart/form-data)
  Future> createTransaction({
    required int categoryId,
    required double amount,
    String? description,
    File? receiptImage,
  }) async {
    try {
      final token = await _authService.getToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/transactions'),
      );

      // Header autentikasi
      request.headers['Authorization'] = 'Bearer $token';

      // Field data transaksi
      request.fields['category_id'] = categoryId.toString();
      request.fields['amount'] = amount.toString();
      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }

      // Lampirkan file gambar nota jika ada
      if (receiptImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'receipt_image', // Sesuaikan dengan nama field di backend multer
            receiptImage.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Transaksi berhasil disimpan', 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menyimpan transaksi'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Hapus transaksi
  Future> deleteTransaction(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Transaksi berhasil dihapus'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghapus transaksi'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}