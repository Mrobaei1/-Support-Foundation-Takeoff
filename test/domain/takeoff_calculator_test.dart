import 'package:flutter_test/flutter_test.dart';
import 'package:support_foundation_takeoff/domain/takeoff_calculator.dart';

void main() {
  group('FoundationTakeoffInput', () {
    const input = FoundationTakeoffInput(
      lengthM: 1.6,
      widthM: 1.6,
      thicknessM: 0.5,
      groundLevelM: 24.37,
      topOfFoundationLevelM: 24.07,
    );

    test('calculates footing, blinding and excavation quantities', () {
      expect(input.foundationConcreteM3, closeTo(1.28, 1e-9));
      expect(input.blindingConcreteM3, closeTo(0.256, 1e-9));
      expect(input.excavationDepthM, closeTo(0.9, 1e-9));
      expect(input.excavationVolumeM3, closeTo(7.056, 1e-9));
      expect(input.foundationFormworkM2, closeTo(3.2, 1e-9));
    });

    test('does not invent backfill without permanent below-ground volume',
        () {
      expect(input.backfillM3, isNull);
    });

    test('calculates backfill only when permanent volume is supplied', () {
      const withPermanentVolume = FoundationTakeoffInput(
        lengthM: 1.6,
        widthM: 1.6,
        thicknessM: 0.5,
        groundLevelM: 24.37,
        topOfFoundationLevelM: 24.07,
        permanentVolumeInsideExcavationM3: 1.536,
      );
      expect(withPermanentVolume.backfillM3, closeTo(5.52, 1e-9));
    });

    test('rejects invalid excavation geometry', () {
      const invalid = FoundationTakeoffInput(
        lengthM: 1,
        widthM: 1,
        thicknessM: 0.5,
        groundLevelM: 1,
        topOfFoundationLevelM: 2,
      );
      expect(() => invalid.excavationVolumeM3, throwsArgumentError);
    });
  });
}
