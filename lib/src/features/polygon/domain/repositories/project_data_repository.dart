import 'dart:ui';

abstract class ProjectDataRepository {
  Future<void> getProjectData();
  void saveProjectData();

  void switchToPreviousState();
  void switchToNextState();
  void cancelLastChange();
  void setProjectState();

  /// return index of point or -1
  int whatPointIsNear(Offset offset, {double deviation});
  void putPoint(Offset offset);
  bool checkIntersection(int index, Offset offset);
  void changePointChoordsStart();
  void changePointChoords(int index, Offset offset);
  void setPolygonClosed();
  void intersectionAlarm();
  void gluing();
}
