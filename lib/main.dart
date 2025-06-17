import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/hospital/hospital_bloc_exports.dart';
import 'blocs/gym/gym_bloc_exports.dart';
import 'blocs/jogging_track/jogging_track_bloc_exports.dart';
import 'screens/main_home_screen.dart';
import 'services/hospital_service.dart';
import 'services/gym_service.dart';
import 'services/jogging_track_service.dart';
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
          create: (context) => HospitalBloc(hospitalService: HospitalService()),
        ),
        BlocProvider<GymBloc>(
          create: (context) => GymBloc(gymService: GymService()),
        ),
        BlocProvider<JoggingTrackBloc>(
          create:
              (context) =>
                  JoggingTrackBloc(joggingTrackService: JoggingTrackService()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const MainHomeScreen(),
      ),
    );
  }
}
