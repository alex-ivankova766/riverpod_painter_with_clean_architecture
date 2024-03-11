import 'package:polygonal_draft/src/features/polygon/domain/entities/project_state.dart';

class Project {
  Project(states, index)
      : statesList = states ?? [],
        currentStateIndex = index ?? -1;
  List<ProjectState> statesList;
  int currentStateIndex;
}
