import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/project_local_datasource.dart';
import '../../data/repositories/project_data_repository_impl.dart';

final projectDataProvider =
    ChangeNotifierProvider<ProjectDataRepositoryImpl>((ref) {
  return ProjectDataRepositoryImpl(ProjectLocalDatasource());
});
