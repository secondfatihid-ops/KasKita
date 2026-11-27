import 'package:flutter_mobile/models/transaction_model.dart';
import 'package:flutter_mobile/widgets/summary_card.dart';
import 'package:flutter_mobile/widgets/transaction_item_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_mobile/main.dart';

void main() {
  testWidgets('login screen renders at a phone-sized viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp(isLoggedIn: false));
    await tester.pumpAndSettle();

    expect(find.text('KasKita'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    final exception = tester.takeException();
    expect(exception, isNull, reason: exception?.toString());
  });

  testWidgets('dashboard cards fit on a narrow phone viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final transaction = TransactionModel(
      id: 1,
      userId: 1,
      categoryId: 1,
      amount: 12500,
      categoryName: 'Pembelian bahan',
      categoryType: 'expense',
      description: 'Bahan baku produksi',
      createdAt: '2026-11-27T10:00:00.000Z',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SummaryCard(
                  totalBalance: 1500000,
                  totalIncome: 2500000,
                  totalExpense: 1000000,
                ),
                TransactionItemCard(
                  transaction: transaction,
                  onDelete: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  test('transaction model reads the API response fields', () {
    final transaction = TransactionModel.fromJson({
      'id': 12,
      'user_id': 3,
      'category_id': 7,
      'amount': '12500.50',
      'description': 'Bahan baku',
      'created_at': '2026-11-27T10:00:00.000Z',
      'user_name': 'Kasir',
      'category_name': 'Belanja',
      'category_type': 'expense',
    });

    expect(transaction.id, 12);
    expect(transaction.amount, 12500.5);
    expect(transaction.categoryName, 'Belanja');
    expect(transaction.categoryType, 'expense');
  });
}
