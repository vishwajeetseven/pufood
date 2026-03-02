import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final Function(String) onFilterApplied;
  final String selectedOutlet;

  const FilterBottomSheet({
    super.key,
    required this.onFilterApplied,
    required this.selectedOutlet,
  });

  @override
  Widget build(BuildContext context) {
    final outlets = ['All', 'Food Court', 'Cafeteria', 'Canteen'];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Outlet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...outlets.map(
            (outlet) => ListTile(
              title: Text(outlet),
              leading: Radio<String>(
                value: outlet,
                groupValue: selectedOutlet,
                onChanged: (String? value) {
                  if (value != null) {
                    onFilterApplied(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}