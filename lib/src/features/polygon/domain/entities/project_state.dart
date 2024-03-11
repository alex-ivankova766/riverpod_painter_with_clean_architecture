import 'point.dart';

class ProjectState {
  ProjectState({pointsFromDatasource, this.isPolygonClosed = false})
      : points = pointsFromDatasource ?? [];
  List<Point> points;
  bool isPolygonClosed;
  bool isIntersectionCatched = false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectState &&
        _listEquals(other.points, points) &&
        other.isPolygonClosed == isPolygonClosed;
  }

  bool _listEquals(List<Point> a, List<Point> b) {
    if (a.isEmpty && b.isEmpty) return true;
    if (a.isEmpty || b.isEmpty || a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode => points.hashCode ^ isPolygonClosed.hashCode;
}
