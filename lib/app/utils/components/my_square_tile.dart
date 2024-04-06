import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const SquareTile({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: child,
      ),
    );
  }
}
