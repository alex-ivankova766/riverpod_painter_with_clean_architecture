// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/line_segment.dart';
import '../../domain/entities/point.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_state.dart';
import '../../domain/repositories/project_data_repository.dart';
import '../datasources/project_local_datasource.dart';
import '../models/project_model.dart';

Logger logger = Logger();
const ATTENTION_DURATION = Duration(milliseconds: 900);

class ProjectDataRepositoryImpl extends ProjectDataRepository
    with ChangeNotifier {
  ProjectDataRepositoryImpl(this.projectLocalDatasource) {
    getProjectData();
  }
  final ProjectLocalDatasource projectLocalDatasource;
  Project projectData = Project(null, null);
  bool isPolygonWasClosed = false;
  List<Point> cashedPoints = [];
  Point? lastChangingPoint;

  ProjectState get currentState {
    if (projectData.currentStateIndex == -1) {
      return ProjectState();
    } else {
      return projectData.statesList[projectData.currentStateIndex];
    }
  }

  List<Point> get points => currentState.points;

  bool get isPolygonClosed => currentState.isPolygonClosed;

  int get statesLength => projectData.statesList.length;

  @override
  Future<void> getProjectData() async {
    Project? projectDataFromLocalBase =
        await projectLocalDatasource.getProjectData();
    if (projectDataFromLocalBase != null) {
      projectData = projectDataFromLocalBase;
      logger.i(statesLength);
      notifyListeners();
    }
  }

  @override
  void saveProjectData() {
    projectLocalDatasource
        .saveProjectData(ProjectModel.fromEntity(projectData));
  }

  @override
  void switchToPreviousState() {
    if ((projectData.currentStateIndex) > -1) {
      projectData.currentStateIndex--;
      notifyListeners();
    }
  }

  @override
  void switchToNextState() {
    if ((projectData.currentStateIndex + 1) < statesLength) {
      projectData.currentStateIndex++;
      notifyListeners();
    }
  }

  @override
  void cancelLastChange() {
    if (projectData.currentStateIndex == -1) {
      return;
    }
    projectData.currentStateIndex--;
    projectData.statesList.removeLast();
    notifyListeners();
    saveProjectData();
  }

  @override
  void putPoint(Offset offset) {
    if (projectData.currentStateIndex == -1) {
      projectData.statesList.clear();
    }
    if (projectData.currentStateIndex != statesLength - 1) {
      projectData.statesList =
          projectData.statesList.sublist(0, projectData.currentStateIndex + 1);
    }
    isPolygonWasClosed = isPolygonClosed;
    cashedPoints = points.toList();
    setProjectState();
    projectData.statesList[projectData.currentStateIndex].points
        .add(Point.fromOffset(offset));
    notifyListeners();
    saveProjectData();
  }

  @override
  bool checkIntersection(int index, Offset offset) {
    List<Point> checkinPoints = points.toList();
    if (index < checkinPoints.length) {
      checkinPoints[index] = Point.fromOffset(offset);
    } else {
      checkinPoints.add(Point.fromOffset(offset));
    }
    List<LineSegment> lineSegments = [];
    for (int index = 0; index < checkinPoints.length - 1; index++) {
      lineSegments.add(LineSegment(
        start: Point(dx: checkinPoints[index].dx, dy: checkinPoints[index].dy),
        end: Point(
            dx: checkinPoints[index + 1].dx, dy: checkinPoints[index + 1].dy),
      ));
    }
    if (isPolygonClosed) {
      lineSegments.add(
          LineSegment(start: checkinPoints.last, end: checkinPoints.first));
    }
    for (LineSegment segment in lineSegments) {
      for (LineSegment anotherSegment in lineSegments) {
        if (segment == anotherSegment) {
          continue;
        }
        if (segment.doTheSegmentsIntersect(anotherSegment)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  int whatPointIsNear(Offset offset, {double deviation = kTouchSlop}) {
    if (points.isEmpty) {
      return -1;
    }
    List<Offset> offsets = points.map((point) => point.toOffset()).toList();
    List<double> distances = offsets
        .map((offsetFromPolygon) => (offset - offsetFromPolygon).distance)
        .toList();
    double minDistance = distances.reduce(min);
    if (minDistance <= deviation) {
      return distances.indexOf(minDistance);
    }
    return -1;
  }

  @override
  void changePointChoords(int index, Offset offset) {
    if (projectData.currentStateIndex != statesLength - 1) {
      projectData.statesList =
          projectData.statesList.sublist(0, projectData.currentStateIndex);
    }
    projectData.statesList[projectData.currentStateIndex].points[index] =
        Point.fromOffset(offset);
    notifyListeners();
    saveProjectData();
  }

  @override
  void setPolygonClosed() {
    cashedPoints = points.toList();
    projectData.statesList.add(ProjectState());
    projectData.statesList.last.isPolygonClosed = true;
    projectData.statesList.last.points.addAll(cashedPoints);
    projectData.currentStateIndex++;
    notifyListeners();
    saveProjectData();
  }

  @override
  void intersectionAlarm() {
    currentState.isIntersectionCatched = true;
    notifyListeners();
    Future.delayed(ATTENTION_DURATION, () {
      currentState.isIntersectionCatched = false;
      notifyListeners();
    });
  }

  @override
  void gluing() {
    if (points.length == 1) {
      return;
    } else {
      setPolygonClosed();
      points.removeLast();
      saveProjectData();
      return;
    }
  }

  @override
  void setProjectState() {
    projectData.statesList.add(ProjectState());
    projectData.statesList.last.isPolygonClosed = isPolygonWasClosed;
    projectData.statesList.last.points.addAll(cashedPoints);
    projectData.currentStateIndex++;
    saveProjectData();
  }

  @override
  void changePointChoordsStart() {
    if (projectData.currentStateIndex == -1) {
      projectData.statesList.clear();
    }
    if (projectData.currentStateIndex != statesLength - 1) {
      projectData.statesList =
          projectData.statesList.sublist(0, projectData.currentStateIndex + 1);
    }
    isPolygonWasClosed = isPolygonClosed;
    cashedPoints = points.toList();
    projectData.statesList.add(ProjectState());
    projectData.statesList.last.isPolygonClosed = isPolygonWasClosed;
    projectData.statesList.last.points.addAll(cashedPoints);
    projectData.currentStateIndex++;
    saveProjectData();
  }
}
