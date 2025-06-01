import 'package:flutter/material.dart';

class ComingSoonDuaWidget extends StatelessWidget {
  const ComingSoonDuaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6D5FFD), // Soft blue
            Color(0xFF46C6E8), // Aqua
            Color(0xFFB8F2E6), // Mint
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_active_rounded,
                size: 64, color: Colors.white.withOpacity(0.9)),
            const SizedBox(height: 24),
            Text(
              'Dua Reminders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stay tuned for personalized dua reminders and notifications!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
