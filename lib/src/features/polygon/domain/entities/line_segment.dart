// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'point.dart';

// I cannot find what error rate occurs in Dart with double calculations, if yout know, change it please
const double ERROR_RATE = 0.01;

class LineSegment {
  const LineSegment({required this.start, required this.end});
  final Point start;
  final Point end;

  bool doTheSegmentsIntersect(LineSegment anotherSegment) {
    double a1 = (end.dx - start.dx == 0)
        ? 0
        : (end.dy - start.dy) / (end.dx - start.dx);
    double b1 = start.dy - a1 * start.dx;
    double a2 = (anotherSegment.end.dx - anotherSegment.start.dx == 0)
        ? 0
        : (anotherSegment.end.dy - anotherSegment.start.dy) /
            (anotherSegment.end.dx - anotherSegment.start.dx);
    double b2 = anotherSegment.start.dy - a2 * anotherSegment.start.dx;
    if ((a1 - a2).abs() < ERROR_RATE && (b1 - b2).abs() < ERROR_RATE) {
      return false;
    }
    double intersectionX = (a1 - a2 == 0) ? 0 : (b2 - b1) / (a1 - a2);
    double intersectionY = a1 * intersectionX + b1;
    if ((intersectionX - start.dx).abs() < ERROR_RATE &&
            (intersectionY - start.dy).abs() < ERROR_RATE ||
        (intersectionX - end.dx).abs() < ERROR_RATE &&
            (intersectionY - end.dy).abs() < ERROR_RATE) {
      return false;
    }

    if (intersectionX > min(start.dx, end.dx) - ERROR_RATE &&
        intersectionX < max(start.dx, end.dx) + ERROR_RATE &&
        intersectionY > min(start.dy, end.dy) - ERROR_RATE &&
        intersectionY < max(start.dy, end.dy) + ERROR_RATE &&
        intersectionX >
            min(anotherSegment.start.dx, anotherSegment.end.dx) - ERROR_RATE &&
        intersectionX <
            max(anotherSegment.start.dx, anotherSegment.end.dx) + ERROR_RATE &&
        intersectionY >
            min(anotherSegment.start.dy, anotherSegment.end.dy) - ERROR_RATE &&
        intersectionY <
            max(anotherSegment.start.dy, anotherSegment.end.dy) + ERROR_RATE) {
      return true;
    }

    return false;
  }

  @override
  bool operator ==(Object other) =>
      other is LineSegment && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}
