import 'package:flutter/material.dart';

class ProductTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget ? prefix;
  final Widget ? prefixIcon;
  final Widget ? suffix;
  final Widget ? suffixIcon;
  final ValueChanged<String>? onTextChange;
  final ValueChanged<String>? onTextSubmitted;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color cursorColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final String? fromValue;
  final bool autocorrect;
  final TextDirection textDirection;
  final bool readOnly;
  final List<String>? autofillHints;
  final void Function(PointerDownEvent)? onTapOutside;

  const ProductTextFieldWidget({
    super.key,
    this.cursorColor = Colors.black,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.autocorrect = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.textStyle = const TextStyle(color: Colors.black,),
    this.textDirection = TextDirection.ltr,
    this.textInputAction,
    this.decoration,
    this.maxLines = 1,
    this.minLines = 1,
    this.controller,
    this.keyboardType,
    this.focusNode,
    this.fromValue,
    this.autofillHints,
    this.onTap,
    this.onTextChange,
    this.onTextSubmitted,
    this.onTapOutside,
  });

  @override
  State<ProductTextFieldWidget> createState() => _ProductTextFieldWidgetState();
}

class _ProductTextFieldWidgetState extends State<ProductTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      autocorrect: widget.autocorrect,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        suffixIcon: widget.suffixIcon,
        suffix: widget.suffix,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffC4C4C4),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      style: widget.textStyle,
      keyboardType: widget.keyboardType,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      autofillHints: widget.autofillHints,
      onTap: widget.onTap,
      onTapOutside: (PointerDownEvent event){
        widget.focusNode?.unfocus();
      },
      onChanged: (value) {
        widget.onTextChange?.call(value);
        if (value.isNotEmpty) {

        }
      },
    );
  }
}