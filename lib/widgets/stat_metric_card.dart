import 'package:flutter/material.dart';

class StatMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final bool highlighted;
  final VoidCallback? onTap;

  const StatMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = highlighted
        ? colorScheme.onPrimary
        : colorScheme.onSecondaryContainer;

    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        color: highlighted
            ? colorScheme.primary
            : colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: foreground, size: highlighted ? 32 : 28),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.82),
                    fontSize: highlighted ? 14 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: foreground,
                        fontSize: highlighted ? 34 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        color: foreground.withValues(alpha: 0.82),
                        fontSize: highlighted ? 15 : 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
