import 'package:flutter/material.dart';

class QuickModeSelector extends StatelessWidget {
  final List<String> modes;
  final String activeMode;
  final ValueChanged<String> onModeSelected;

  const QuickModeSelector({
    super.key,
    required this.modes,
    required this.activeMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Quick Modes',
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: modes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final mode = modes[index];
              final isSelected = mode == activeMode;
              return ChoiceChip(
                label: Text(
                  mode,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onModeSelected(mode);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
