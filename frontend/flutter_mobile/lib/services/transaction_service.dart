import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/transaction_model.dart';
import 'api_client.dart';

class TransactionService {
  final ApiClient _apiClient = ApiClient.instance;

  // Ambil semua daftar transaksi
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await _apiClient.get('transactions');

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
    XFile? receiptImage,
  }) async {
    try {
      final fields = <String, String>{
        'category_id': categoryId.toString(),
        'amount': amount.toString(),
      };
      if (description != null && description.isNotEmpty) {
        fields['description'] = description;
      }

      final response = await _apiClient.sendMultipart(
        method: 'POST',
        path: 'transactions',
        fields: fields,
        files: receiptImage == null
            ? []
            : [
                http.MultipartFile.fromBytes(
                  'receipt_image',
                  await receiptImage.readAsBytes(),
                  filename: receiptImage.name,
                ),
              ],
      );
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
    XFile? receiptImage,
  }) async {
    try {
      final response = await _apiClient.sendMultipart(
        method: 'PUT',
        path: 'transactions/$id',
        fields: {
          'category_id': categoryId.toString(),
          'amount': amount.toString(),
          'description': description ?? '',
        },
        files: receiptImage == null
            ? []
            : [
                http.MultipartFile.fromBytes(
                  'receipt_image',
                  await receiptImage.readAsBytes(),
                  filename: receiptImage.name,
                ),
              ],
      );
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
      final response = await _apiClient.delete('transactions/$id');

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
