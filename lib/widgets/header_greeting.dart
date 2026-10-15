import 'package:flutter/material.dart';

class HeaderGreeting extends StatelessWidget {
  final String userName;
  final int activeDeviceCount;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onNotificationTap;
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;
  final TextEditingController? searchController;

  const HeaderGreeting({
    super.key,
    required this.userName,
    required this.activeDeviceCount,
    required this.onSearchChanged,
    required this.onNotificationTap,
    this.onThemeToggle,
    this.isDarkMode = false,
    this.searchController,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: colorScheme.onPrimary.withValues(
                          alpha: 0.16,
                        ),
                        child: Icon(
                          Icons.person,
                          color: colorScheme.onPrimary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              userName,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onThemeToggle != null)
                      IconButton(
                        tooltip: isDarkMode
                            ? 'Switch to Light Mode'
                            : 'Switch to Dark Mode',
                        onPressed: onThemeToggle,
                        icon: Icon(
                          isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode_outlined,
                          color: colorScheme.onPrimary,
                          size: 24,
                        ),
                      ),
                    IconButton(
                      tooltip: 'Active notifications',
                      onPressed: onNotificationTap,
                      icon: Badge(
                        isLabelVisible: activeDeviceCount > 0,
                        backgroundColor: colorScheme.tertiary,
                        textColor: colorScheme.onTertiary,
                        label: Text('$activeDeviceCount'),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: colorScheme.onPrimary,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
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
