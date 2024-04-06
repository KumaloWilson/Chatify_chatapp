
import 'package:chat_app/app/utils/constants/text_constants.dart';
import 'package:flutter/material.dart';

Padding continueWIth(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(TextConstants.continueWith,
                style: TextConstants.primarystyle(context)),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }