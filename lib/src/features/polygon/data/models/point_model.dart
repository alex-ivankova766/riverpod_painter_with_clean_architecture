import '../../domain/entities/point.dart';

class PointModel {
  const PointModel({
    required this.dx,
    required this.dy,
  });
  final double dx;
  final double dy;

  factory PointModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PointModel(
      dx: json['dx'],
      dy: json['dy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dx': dx,
      'dy': dy,
    };
  }

  factory PointModel.fromEntity(Point point) {
    return PointModel(dx: point.dx, dy: point.dy);
  }

  Point toEntity() {
    return Point(dx: dx, dy: dy);
  }
}
