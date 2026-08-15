import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const filters = [
      "All",
      "Pending",
      "Completed",
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final bool isSelected =
              selectedFilter == filter;

          Color chipColor;
          Color selectedColor;

          if (filter == "All") {
            chipColor = Colors.brown.shade100;
            selectedColor = Colors.brown;
          } else if (filter == "Pending") {
            chipColor = Colors.brown.shade100;
            selectedColor = Colors.brown.shade700;
          } else {
            chipColor = Colors.brown.shade100;
            selectedColor = Colors.brown.shade700;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : selectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              selected: isSelected,

              selectedColor: selectedColor,

              backgroundColor: chipColor,

              checkmarkColor: Colors.white,

              side: BorderSide(
                color: selectedColor,
                width: 1,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),

              avatar: Icon(
                filter == "All"
                    ? Icons.list
                    : filter == "Pending"
                    ? Icons.pending_actions
                    : Icons.check_circle,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : selectedColor,
              ),

              onSelected: (_) {
                onSelected(filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}