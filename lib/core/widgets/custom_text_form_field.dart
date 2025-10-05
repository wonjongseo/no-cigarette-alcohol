import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.widget,
    this.color,
    this.maxLines,
    this.readOnly,
    this.controller,
    this.sufficIcon,
    this.keyboardType,
    this.onTap,
    this.hintStyle,
    this.onFieldSubmitted,
    this.maxLength,
    this.focusNode,
  });

  final FocusNode? focusNode;
  final String? hintText;
  final Color? color;
  final Widget? widget;
  final int? maxLines;
  final bool? readOnly;
  final TextEditingController? controller;
  final Widget? sufficIcon;
  final Function()? onTap;
  final Function(String?)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextStyle? hintStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLength: maxLength,
              keyboardType: keyboardType,
              onFieldSubmitted: onFieldSubmitted,
              onTap: onTap,
              focusNode: focusNode,
              readOnly: readOnly ?? false,
              style: const TextStyle(fontSize: 12),
              maxLines: maxLines ?? 1,
              controller: controller,
              decoration: InputDecoration(
                hintStyle: hintStyle,
                counterText: "",
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 0,
                  minWidth: 0,
                ),
                suffixIconConstraints: const BoxConstraints(
                  minHeight: 0,
                  minWidth: 0,
                ),
                suffixIcon:
                    sufficIcon != null
                        ? Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: sufficIcon,
                        )
                        : null,
                contentPadding:
                    maxLines != null
                        ? EdgeInsets.all(15)
                        : EdgeInsets.symmetric(horizontal: 15),
                hintText: hintText,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (widget != null) widget!,
        ],
      ),
    );
  }
}
