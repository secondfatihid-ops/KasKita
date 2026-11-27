import 'dart:io';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionController extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Hitung Total Pemasukan
  double get totalIncome {
    return _transactions
        .where((t) => t.categoryType == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Hitung Total Pengeluaran
  double get totalExpense {
    return _transactions
        .where((t) => t.categoryType == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Hitung Saldo Bersih (Pemasukan - Pengeluaran)
  double get netBalance => totalIncome - totalExpense;

  // Ambil daftar transaksi dari backend
  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _transactionService.getTransactions();
    } catch (e) {
      // Handle error jika diperlukan
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambah transaksi baru (mendukung upload gambar nota)
  Future<bool> addTransaction({
    required int categoryId,
    required double amount,
    String? description,
    File? receiptImage,
    required Function(String, bool) onFinished,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _transactionService.createTransaction(
      categoryId: categoryId,
      amount: amount,
      description: description,
      receiptImage: receiptImage,
    );

    _isLoading = false;
    notifyListeners();

    if (result['success']) {
      await fetchTransactions(); // Refresh data setelah berhasil menambah
      onFinished(result['message'], true);
      return true;
    } else {
      onFinished(result['message'], false);
      return false;
    }
  }

  // Hapus transaksi
  Future<bool> removeTransaction(int id, Function(String, bool) onFinished) async {
    final result = await _transactionService.deleteTransaction(id);

    if (result['success']) {
      _transactions.removeWhere((tx) => tx.id == id);
      notifyListeners();
      onFinished(result['message'], true);
      return true;
    } else {
      onFinished(result['message'], false);
      return false;
    }
  }
}