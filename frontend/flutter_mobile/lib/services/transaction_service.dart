import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';
import 'auth_service.dart';

class TransactionService {
  static const String baseUrl = AuthService.baseUrl;
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
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data
            .map(
              (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Gagal memuat daftar transaksi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Tambah transaksi baru (mendukung upload gambar nota via multipart/form-data)
  Future<Map<String, dynamic>> createTransaction({
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
        return {
          'success': true,
          'message': 'Transaksi berhasil disimpan',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menyimpan transaksi',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> updateTransaction({
    required int id,
    required int categoryId,
    required double amount,
    String? description,
    File? receiptImage,
  }) async {
    try {
      final token = await _authService.getToken();
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/transactions/$id'),
      )..headers['Authorization'] = 'Bearer $token';
      request.fields['category_id'] = categoryId.toString();
      request.fields['amount'] = amount.toString();
      request.fields['description'] = description ?? '';
      if (receiptImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('receipt_image', receiptImage.path),
        );
      }
      final response = await http.Response.fromStream(await request.send());
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Transaksi berhasil diperbarui',
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal memperbarui transaksi',
      };
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteTransaction(int id) async {
    try {
      final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Transaksi berhasil dihapus'};
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus transaksi',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
