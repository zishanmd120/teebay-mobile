import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationTextFieldWidget extends StatefulWidget {
  final String hintText;
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
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color cursorColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final String? fromValue;
  final Brightness? keyboardAppearance;
  final bool autocorrect;
  final TextDirection textDirection;
  final bool readOnly;
  final MouseCursor? mouseCursor;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(PointerDownEvent)? onTapOutside;

  const AuthenticationTextFieldWidget({
    super.key,
    this.cursorColor = Colors.black,
    required this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.autocorrect = false,
    this.obscureText = false,
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
    this.keyboardAppearance,
    this.mouseCursor,
    this.autofillHints,
    this.onTap,
    this.onTextChange,
    this.onTextSubmitted,
    this.inputFormatters,
    this.validator,
    this.onTapOutside,
  });

  @override
  State<AuthenticationTextFieldWidget> createState() => _AuthenticationTextFieldWidgetState();
}

class _AuthenticationTextFieldWidgetState extends State<AuthenticationTextFieldWidget> {
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
        // isDense: true,
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
      keyboardAppearance: widget.keyboardAppearance,
      style: widget.textStyle,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      mouseCursor: widget.mouseCursor,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
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
