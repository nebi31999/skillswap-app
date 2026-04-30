import 'package:flutter/material.dart';

class SkillSelector extends StatelessWidget {
  final List<String> availableSkills;
  final List<String> selectedSkills;
  final Function(List<String>) onSelectionChanged;

  const SkillSelector({
    super.key,
    required this.availableSkills,
    required this.selectedSkills,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableSkills.map((skill) {
        final isSelected = selectedSkills.contains(skill);
        return FilterChip(
          label: Text(skill),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedSkills);
            if (selected) {
              newSelection.add(skill);
            } else {
              newSelection.remove(skill);
            }
            onSelectionChanged(newSelection);
          },
          backgroundColor: Colors.grey[200],
          selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }
}
