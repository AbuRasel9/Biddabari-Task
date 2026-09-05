import 'package:biddabari_task/presentation/views/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/service_locator.dart';
import 'domen/controllers/course_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<CourseController>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biddabari Task App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CourseListView(),
    );
  }
}
