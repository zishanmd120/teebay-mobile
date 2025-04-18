import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:teebay_mobile/features/product/presentation/controllers/product_controller.dart';

import 'add_product_screen.dart';

class MyProductEditScreen extends GetView<ProductController> {
  const MyProductEditScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldTitle(title: "Title",),
              ProductTextFieldWidget(
                controller: controller.titleEditingControllerUp,
              ),
              const SizedBox(height: 15,),
              FieldTitle(title: "Categories",),
              Obx(()=> controller.isCatSet.value ? const SizedBox.shrink() :
                MultiDropdown<String>(
                  items: controller.categoriesList.map((category) {
                    return DropdownItem(
                      label: category.label ?? '',
                      value: category.value ?? '',
                    );
                  }).toList(),
                  controller: controller.multiSelectController.value,
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
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                    disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  ),
                  onSelectionChange: (selectedItems) {
                    controller.selectedCategoryList = selectedItems;
                    print(controller.selectedCategoryList);
                  },
                ),
              ),
              FieldTitle(title: "Description",),
              ProductTextFieldWidget(
                controller: controller.desEditingControllerUp,
                maxLines: 5,
                minLines: 5,
              ),
              const SizedBox(height: 15,),
              FieldTitle(title: "Purchase Price",),
              ProductTextFieldWidget(
                controller: controller.ppEditingControllerUp,
              ),
              const SizedBox(height: 15,),
              FieldTitle(title: "Rental Price",),
              ProductTextFieldWidget(
                controller: controller.rpEditingControllerUp,
              ),
              const SizedBox(height: 15,),
              DropdownMenuTheme(
                data: DropdownMenuThemeData(
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.white,),
                  ),
                ),
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width * 0.925,
                  initialSelection: controller.selectedOption,
                  menuHeight: 150,
                  hintText: "Options",
                  onSelected: (String? value) {
                    controller.selectedOption = value ?? "";
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  dropdownMenuEntries: controller.optionTypes.map((String division) {
                    return DropdownMenuEntry(value: division, label: division,);
                  }).toList(),
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints.tight(const Size.fromHeight(45)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    child: EditProductButton(
                      title: "Cancel",
                      color: Colors.red,
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: EditProductButton(
                      title: "Save Changes",
                      color: Colors.purple,
                      onTap: (){
                        controller.updateProductData();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FieldTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0,),
      child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 17.0,),),
    );
  }

  Widget EditProductButton({required String title, required Color color, required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        // width: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.0,),
        ),
        alignment: Alignment.center,
        child: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500,),
        ),
      ),
    );
  }
}