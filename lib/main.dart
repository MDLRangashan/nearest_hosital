import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/hospital/hospital_bloc_exports.dart';
import 'screens/home_screen.dart';
import 'services/hospital_service.dart';
import 'themes/app_theme.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HospitalBloc>(
          create:
              (context) =>
                  HospitalBloc(hospitalService: HospitalService())
                    ..add(FetchHospitals()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
