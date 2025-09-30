import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utills/app_images.dart';
import 'common_svg_container.dart';

class CommonLoaderScreen extends StatelessWidget {
  const CommonLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            // --- App Logo with bounce/scale animation ---
            CommonSvgContainer(
                  assetName: AppImages.splashIcon,
                  size: 80,
                  color: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  borderRadius: 12,
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  duration: 1200.ms,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  curve: Curves.easeInOut,
                )
                .fadeIn(duration: 800.ms),

            // --- Circular Progress Indicator ---
            CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  backgroundColor: colorScheme.primary.withOpacity(0.2),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: 1000.ms,
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.05, 1.05),
                  curve: Curves.easeInOut,
                ),

            // --- Loading Text ---
            Text(
                  "Loading...",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onBackground,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 800.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 800.ms,
                  curve: Curves.easeOut,
                )
                .shimmer(
                  duration: 2000.ms,
                  colors: [
                    Colors.transparent,
                    colorScheme.primary.withOpacity(0.4),
                    colorScheme.secondary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
