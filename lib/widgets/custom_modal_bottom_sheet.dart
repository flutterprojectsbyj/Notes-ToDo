import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key, required this.listChild,});

  final List<Widget> listChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FractionallySizedBox(
            widthFactor: 0.25,
            child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                child: Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                  ),
                ),
            ),
          ),
          Column(
            children: [
              for(int i = 0; i < listChild.length; i++)...[
                listChild[i],
              ]
            ],
          )
        ],
      ),
    );
  }
}

Widget buildListItem(
    BuildContext context, {
      required Widget title,
      required Widget leading,
      required onPressed,
    }) {
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