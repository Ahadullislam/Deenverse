import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaWidget extends StatelessWidget {
  const QiblaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterQiblah.androidDeviceSensorSupport(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == true) {
          return SizedBox(
            height: 200,
            child: StreamBuilder<QiblahDirection>(
              stream: FlutterQiblah.qiblahStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final direction = snapshot.data!.qiblah;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.explore, size: 64, color: Colors.green),
                      Text('Qibla: ${direction.toStringAsFixed(2)}°'),
                    ],
                  );
                } else {
                  return const Text('Unable to get Qibla direction.');
                }
              },
            ),
          );
        } else {
          return const Text('Qibla direction not supported on this device.');
        }
      },
    );
  }
}
