import 'package:flutter/material.dart';
import 'package:nearby_hospital/screens/gym_screen.dart';
import 'package:nearby_hospital/screens/jogging_track_screen.dart';
import '../constants/app_constants.dart';
import 'hospital_screen.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Network Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                children: [
                  _buildPlaceCard(
                    context,
                    'Hospitals',
                    'Find partnered hospitals near you',
                    Icons.local_hospital,
                    Colors.green,
                    Colors.green[100]!,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HospitalScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPlaceCard(
                    context,
                    'Gyms',
                    'Access exclusive fitness centers',
                    Icons.fitness_center,
                    Colors.orange,
                    Colors.orange[100]!,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GymScreen()),
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('Gyms feature coming soon!'),
                      //   ),
                      // );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPlaceCard(
                    context,
                    'Jogging Tracks',
                    'Explore outdoor wellness spots',
                    Icons.directions_run,
                    Colors.purple,
                    Colors.purple[100]!,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoggingTrackScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Color backcolor,
    VoidCallback onTap,
  ) {
    return Material(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: backcolor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Icon(icon, size: 35, color: color)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              //const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 25),
            ],
          ),
        ),
      ),
    );
  }
}
