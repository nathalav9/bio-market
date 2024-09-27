import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final bool isTextArea;

  const FormContainerWidget({
    super.key,
    this.controller,
    this.isPasswordField,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    this.isTextArea = false,
  });

  @override
  _FormContainerWidgetState createState() => new _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField ?? false ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator ?? (value) => null,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLines: widget.isTextArea ? null : 1,
        minLines: widget.isTextArea ? 5 : 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          helperText: widget.helperText,
          hintStyle: TextStyle(color: Colors.black45),
          suffixIcon: widget.isPasswordField == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _obscureText == false ? Colors.blue : Colors.grey,
                  ),
                )
              : null,
        ),
        textCapitalization: widget.isPasswordField == true
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        autocorrect: widget.isPasswordField != true,
      ),
    );
  }
}
