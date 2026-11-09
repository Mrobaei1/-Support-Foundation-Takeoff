import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('offline support register contains exactly 176 unique foundations',
      () async {
    final source = await rootBundle.loadString('data/supports.json');
    final document = jsonDecode(source) as Map<String, dynamic>;
    final supports = document['supports'] as List<dynamic>;
    final ids = supports
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toList();

    expect(ids, hasLength(176));
    expect(ids.toSet(), hasLength(176));
    expect(ids.first, 'SU-004');
    expect(ids[25], 'SU-029');
    expect(ids[26], 'SU-034');
    expect(ids.last, 'SU-183');
  });
}
