// ignore: must_be_immutable
import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

// ignore: must_be_immutable
class WidgetImageDDWONEite extends StatelessWidget {
  List<ValueItem<dynamic>> options;
  String hitText;
  String? labelText;
  TextStyle hitTextStyle;
  String? Labelvlaue;
  void Function(List<ValueItem<dynamic>>)? onOptionSelected;
  final FormFieldValidator<List<ValueItem<dynamic>>>? validator;
  bool searchEnabled ;
  List<ValueItem<dynamic>>? initialSelectedOptions; // New parameter


  WidgetImageDDWONEite({
    super.key,
    this.Labelvlaue,
    this.initialSelectedOptions,
    required this.hitTextStyle,
    required this.options,
    required this.hitText,
    this.labelText,
    this.onOptionSelected,
    this.validator,
    required this.searchEnabled
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$Labelvlaue",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,color: AppColors().darkGreen),
          textDirection: TextDirection.rtl,
        ),
        FormField<List<ValueItem<dynamic>>>(
          initialValue: initialSelectedOptions,
          
          validator: validator,
          builder: (FormFieldState<List<ValueItem<dynamic>>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultiSelectDropDown(
                  optionBuilder:<User>(ctx, item, selected) {
                    return ListTile(
                     trailing:  CircleAvatar(backgroundImage: NetworkImage(item.value.image),),
                     title: Text(item.label),
                      
                      );
                    
                    
                  },
                  selectedOptions: initialSelectedOptions!, // Set initial selected options
                  searchEnabled: searchEnabled,
                  padding: EdgeInsets.only(left: 100),
                  borderRadius: 10,
                  fieldBackgroundColor:AppColors().darkGreenForms,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  borderWidth: 1,
                  borderColor: Colors.grey.shade100,
                  onOptionSelected: (selectedOptions) {
                    onOptionSelected?.call(selectedOptions);
                    state.didChange(selectedOptions);
                  },
                  hint: hitText,
                  options: options,
                  hintStyle: hitTextStyle,
                  singleSelectItemStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  selectionType: SelectionType.single,
                  
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}




class User {
  final String image;
  final String uid;
  final String tree;

  User({required this.image, required this.uid,required this.tree});

  @override
  String toString() {
    return 'User(image: $image, uid: $uid,tree:$tree)';
  }
}