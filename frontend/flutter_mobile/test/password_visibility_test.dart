import 'package:flutter_mobile/widgets/custom_textfield.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('password visibility can be toggled without losing input', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            label: 'Password',
            icon: Icons.lock,
            isPassword: true,
          ),
        ),
      ),
    );

    final textField = find.byType(TextField);
    expect(tester.widget<TextField>(textField).obscureText, isTrue);

    await tester.enterText(textField, 'kaskita123');
    await tester.tap(find.byTooltip('Tampilkan password'));
    await tester.pump();

    expect(tester.widget<TextField>(textField).obscureText, isFalse);
    expect(controller.text, 'kaskita123');

    await tester.tap(find.byTooltip('Sembunyikan password'));
    await tester.pump();

    expect(tester.widget<TextField>(textField).obscureText, isTrue);
    expect(controller.text, 'kaskita123');
  });
}
