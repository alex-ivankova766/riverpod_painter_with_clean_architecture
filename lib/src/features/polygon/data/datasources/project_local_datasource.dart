import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/project.dart';
import '../models/project_model.dart';

Logger logger = Logger();

abstract class ProjectDatasource {
  Future<Project?> getProjectData();
  Future<void> saveProjectData(ProjectModel projectdata);
}

class ProjectLocalDatasource extends ProjectDatasource {
  ProjectLocalDatasource();

  @override
  Future<Project?> getProjectData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? project = prefs.getString('project');
    if (project == null) {
      logger.e('project == null');
      return null;
    }
    logger.i(project);
    return ProjectModel.fromJson(json.decode(project)).toEntity();
  }

  @override
  Future<void> saveProjectData(ProjectModel projectdata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> projectDataJson = projectdata.toJson();
    prefs.setString('project', json.encode(projectDataJson));
  }
}
