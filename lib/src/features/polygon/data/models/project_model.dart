import '../../domain/entities/project.dart';
import 'project_state_model.dart';

class ProjectModel {
  const ProjectModel({
    required this.statesList,
    required this.currentStateIndex,
  });
  final List<ProjectStateModel> statesList;
  final int currentStateIndex;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      statesList: (json['statesList'] as List<dynamic>)
          .map((state) => ProjectStateModel.fromJson(state))
          .toList(),
      currentStateIndex: json['currentStateIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statesList': statesList.map((state) => state.toJson()).toList(),
      'currentStateIndex': currentStateIndex,
    };
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      statesList: project.statesList
          .map((state) => ProjectStateModel.fromEntity(state))
          .toList(),
      currentStateIndex: project.currentStateIndex,
    );
  }

  Project toEntity() {
    return Project(
      statesList.map((state) => state.toEntity()).toList(),
      currentStateIndex,
    );
  }
}
