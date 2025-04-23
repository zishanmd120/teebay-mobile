import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../data/models/categories_model.dart';

class CategorySelectorWidget extends StatefulWidget {
  final List<CategoriesResponse> totalCategories;
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onSelectionChanged;

  const CategorySelectorWidget({
    super.key,
    required this.totalCategories,
    required this.selectedCategories,
    required this.onSelectionChanged,
  });

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  final MultiSelectController<String> multiSelectController = MultiSelectController<String>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      multiSelectController.selectWhere(
            (item) => widget.selectedCategories.contains(item.value),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<String>(
      items: widget.totalCategories.map((category) {
        return DropdownItem(
          label: category.label ?? '',
          value: category.value ?? '',
        );
      }).toList(),
      controller: multiSelectController,
      enabled: true,
      searchEnabled: false,
      chipDecoration: ChipDecoration(
        backgroundColor: Colors.blue.shade100,
        wrap: true,
        runSpacing: 2,
        spacing: 10,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'Categories',
        hintStyle: const TextStyle(color: Colors.black87),
        showClearIcon: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.black87),
        ),
      ),
      dropdownDecoration: const DropdownDecoration(
        marginTop: 2,
        maxHeight: 150,
      ),
      dropdownItemDecoration: const DropdownItemDecoration(
        selectedIcon: Icon(Icons.check_box, color: Colors.green),
        disabledIcon: Icon(Icons.lock, color: Colors.grey),
      ),
      onSelectionChange: (selectedItems) {
        final selectedLabels = selectedItems.map((e) => e).toList();
        print(selectedLabels);
        widget.onSelectionChanged(selectedLabels);
      },
    );
  }
}