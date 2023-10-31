import 'package:flutter/material.dart';

class ModalBottomListItem extends StatelessWidget {
  const ModalBottomListItem({super.key, required this.title, required this.leading, required this.onPressed,});

  final Widget title;
  final Widget leading;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            leading,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: title,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
