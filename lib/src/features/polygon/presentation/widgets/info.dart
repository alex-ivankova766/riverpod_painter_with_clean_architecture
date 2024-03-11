import 'package:flutter/material.dart';

import 'consts.dart';

class Info extends StatelessWidget {
  const Info({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 9, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(CANCEL_BORDER_RADIUS)),
        child: Text(INFO, style: Theme.of(context).textTheme.bodyMedium));
  }
}
