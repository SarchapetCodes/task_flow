import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/main.dart';

void main() {
  testWidgets('Task Flow app opens', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskFlowApp());

    await tester.pumpAndSettle();

    expect(find.text('Վիճակագրություն'), findsWidgets);
  });
}
