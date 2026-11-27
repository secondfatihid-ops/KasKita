import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/transaction_item_card.dart';
import '../auth/login_screen.dart';
import '../categories/category_list_screen.dart';
import '../transactions/transaction_form_screen.dart';
import '../transactions/transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Muat data transaksi atau ringkasan saat dashboard dibuka
      Provider.of<TransactionController>(context, listen: false).fetchTransactions();
    });
  }

  void _handleLogout() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KasKita Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Kelola Kategori',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryListScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Consumer<TransactionController>(
        builder: (context, transactionController, child) {
          if (transactionController.isLoading && transactionController.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => transactionController.fetchTransactions(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu Ringkasan Keuangan (Menggunakan summary_card.dart)
                  SummaryCard(
                    totalBalance: transactionController.totalBalance,
                    totalIncome: transactionController.totalIncome,
                    totalExpense: transactionController.totalExpense,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text(
                        'Transaksi Terbaru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionListScreen(),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  transactionController.transactions.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'Belum ada transaksi tercatat',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactionController.transactions.length > 5
                              ? 5
                              : transactionController.transactions.length, // Batasi 5 transaksi terbaru di dashboard
                          itemBuilder: (context, index) {
                            final transaction = transactionController.transactions[index];
                            return TransactionItemCard(
                              transaction: transaction,
                            );
                          },
                        ),
                ],
              ),
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
            MaterialPageRoute(builder: (context) => const TransactionFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}