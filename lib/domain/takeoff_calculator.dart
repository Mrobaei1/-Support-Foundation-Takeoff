class FoundationTakeoffInput {
  const FoundationTakeoffInput({
    required this.lengthM,
    required this.widthM,
    required this.thicknessM,
    required this.groundLevelM,
    required this.topOfFoundationLevelM,
    this.workingSpaceEachSideM = 0.6,
    this.blindingThicknessM = 0.1,
    this.blindingOverhangEachSideM = 0,
    this.permanentVolumeInsideExcavationM3,
  });

  final double lengthM;
  final double widthM;
  final double thicknessM;
  final double groundLevelM;
  final double topOfFoundationLevelM;
  final double workingSpaceEachSideM;
  final double blindingThicknessM;
  final double blindingOverhangEachSideM;

  /// Must include all permanent concrete volume below ground, including
  /// footing, blinding and any pedestal portion inside the excavation.
  /// Backfill remains unavailable until this is known.
  final double? permanentVolumeInsideExcavationM3;

  double get excavationDepthM =>
      groundLevelM -
      (topOfFoundationLevelM - thicknessM - blindingThicknessM);

  double get excavationVolumeM3 {
    _validate();
    final excavationLength =
        lengthM + 2 * workingSpaceEachSideM;
    final excavationWidth =
        widthM + 2 * workingSpaceEachSideM;
    return excavationLength * excavationWidth * excavationDepthM;
  }

  double get blindingConcreteM3 {
    _validate();
    final length =
        lengthM + 2 * blindingOverhangEachSideM;
    final width =
        widthM + 2 * blindingOverhangEachSideM;
    return length * width * blindingThicknessM;
  }

  double get foundationConcreteM3 {
    _validate();
    return lengthM * widthM * thicknessM;
  }

  double get foundationFormworkM2 {
    _validate();
    return 2 * (lengthM + widthM) * thicknessM;
  }

  double? get backfillM3 {
    final permanent = permanentVolumeInsideExcavationM3;
    if (permanent == null) return null;
    _validate();
    final result = excavationVolumeM3 - permanent;
    if (result < -1e-9) {
      throw ArgumentError(
        'Permanent volume inside excavation exceeds excavation volume.',
      );
    }
    return result < 0 ? 0 : result;
  }

  void _validate() {
    if (lengthM <= 0 ||
        widthM <= 0 ||
        thicknessM <= 0 ||
        workingSpaceEachSideM < 0 ||
        blindingThicknessM < 0 ||
        blindingOverhangEachSideM < 0) {
      throw ArgumentError('Dimensions and allowances are invalid.');
    }
    if (excavationDepthM <= 0) {
      throw ArgumentError(
        'Calculated excavation depth must be greater than zero.',
      );
    }
    if (permanentVolumeInsideExcavationM3 != null &&
        permanentVolumeInsideExcavationM3! < 0) {
      throw ArgumentError('Permanent volume cannot be negative.');
    }
  }
}
