import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../data/services/api_service.dart';
import '../data/services/network_info_service.dart';
import '../domen/controllers/course_controller.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Services
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfoService>(
      () => NetworkInfoService(connectivity: sl<Connectivity>()));
  sl.registerLazySingleton<ApiService>(
      () => ApiService(networkInfoService: sl<NetworkInfoService>()));

  // Providers & Controllers
  sl.registerFactory<CourseController>(
      () => CourseController(apiService: sl<ApiService>()));
}
