import 'dart:ui';

extension NullableIntHelper on int? {
  int? add(int? value) {
    if (this == null || value == null) return null;
    return this! + value;
  }

  int? subtract(int? value) {
    if (this == null || value == null) return null;
    return this! - value;
  }
}

extension DoubleHelper on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

int convertColor(int color, int alpha) => Color(color).withAlpha(alpha).value;
int convertOldColor(int color, int old) =>
    convertColor(color, Color(old).alpha);
