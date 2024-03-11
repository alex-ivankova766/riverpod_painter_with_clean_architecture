import 'dart:ui';

class Point {
  Point({required this.dx, required this.dy});
  double dx;
  double dy;

  factory Point.fromOffset(Offset offset) =>
      Point(dx: offset.dx, dy: offset.dy);

  Offset toOffset() => Offset(dx, dy);

  @override
  bool operator ==(Object other) =>
      other is Point && dx == other.dx && dy == other.dy;

  @override
  int get hashCode => Object.hash(dx, dy);
}
