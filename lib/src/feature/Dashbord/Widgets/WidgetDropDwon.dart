import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

// ignore: must_be_immutable
class DropDwon extends StatefulWidget {

  final List<ValueItem<dynamic>> options;
  final String hitText;
  final String? labelText;
  final TextStyle hitTextStyle;
  final String? Labelvlaue;
  final void Function(List<ValueItem<dynamic>>)? onOptionSelected;
  final FormFieldValidator<List<ValueItem<dynamic>>>? validator;
  final bool searchEnabled;

  DropDwon({
    super.key,
    this.Labelvlaue,
    required this.hitTextStyle,
    required this.options,
    required this.hitText,
    this.labelText,
    this.onOptionSelected,
    this.validator,
    required this.searchEnabled,
  });

  @override
  _DropDwonState createState() => _DropDwonState();
}

class _DropDwonState extends State<DropDwon> {
  List<ValueItem<dynamic>> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${widget.Labelvlaue}",
          style: TextStyle(color: Color(0xFF006400),fontSize: 15, fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
        ),
        FormField<List<ValueItem<dynamic>>>(
          validator: widget.validator,
          builder: (FormFieldState<List<ValueItem<dynamic>>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultiSelectDropDown(
                  searchEnabled: widget.searchEnabled,
                  padding: EdgeInsets.only(left: 100),
                  borderRadius: 10,
                  fieldBackgroundColor: AppColors().darkGreenForms,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  borderWidth: 1,
                  borderColor: Colors.grey.shade100,
                  onOptionSelected: (selectedOptions) {
                    setState(() {
                      this.selectedOptions = selectedOptions;
                    });
                    widget.onOptionSelected?.call(selectedOptions);
                    state.didChange(selectedOptions);
                  },
                  
                  hint: widget.hitText,
                  options: widget.options,
                  hintStyle: widget.hitTextStyle,
                  singleSelectItemStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  selectionType: SelectionType.single,
                  
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
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
