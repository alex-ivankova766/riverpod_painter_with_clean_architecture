import '../../domain/entities/project_state.dart';
import 'point_model.dart';

class ProjectStateModel {
  const ProjectStateModel(
      {required this.points, required this.isPolygonClosed});
  final List<PointModel> points;
  final bool isPolygonClosed;

  factory ProjectStateModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProjectStateModel(
      points: (json['points'] as List<dynamic>)
          .map((point) => PointModel.fromJson(point))
          .toList(),
      isPolygonClosed: json['isPolygonClosed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point.toJson()).toList(),
      'isPolygonClosed': isPolygonClosed,
    };
  }

  factory ProjectStateModel.fromEntity(ProjectState state) {
    return ProjectStateModel(
      points:
          state.points.map((point) => PointModel.fromEntity(point)).toList(),
      isPolygonClosed: state.isPolygonClosed,
    );
  }

  ProjectState toEntity() {
    return ProjectState(
      pointsFromDatasource: points.map((point) => point.toEntity()).toList(),
      isPolygonClosed: isPolygonClosed,
    );
  }
}
