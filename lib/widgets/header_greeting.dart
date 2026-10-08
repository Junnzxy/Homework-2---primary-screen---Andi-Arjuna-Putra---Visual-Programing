import 'package:flutter/material.dart';

class HeaderGreeting extends StatelessWidget {
  final String userName;
  final int activeDeviceCount;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onNotificationTap;

  const HeaderGreeting({
    super.key,
    required this.userName,
    required this.activeDeviceCount,
    required this.onSearchChanged,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.onPrimary.withValues(
                        alpha: 0.16,
                      ),
                      child: Icon(
                        Icons.person,
                        color: colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          userName,
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onNotificationTap,
                  icon: Badge(
                    isLabelVisible: activeDeviceCount > 0,
                    backgroundColor: colorScheme.tertiary,
                    textColor: colorScheme.onTertiary,
                    label: Text('$activeDeviceCount'),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search devices or rooms...',
                hintStyle: TextStyle(
                  color: colorScheme.onPrimary.withValues(alpha: 0.72),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onPrimary.withValues(alpha: 0.72),
                ),
                filled: true,
                fillColor: colorScheme.onPrimary.withValues(alpha: 0.16),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
