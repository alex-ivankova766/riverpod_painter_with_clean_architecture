import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/repositories/project_data_repository_impl.dart';
import 'consts.dart';

class Cancel extends StatelessWidget {
  const Cancel({
    super.key,
    required this.projectProvider,
  });

  final ProjectDataRepositoryImpl projectProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: WHITE_COLOR,
          borderRadius: BorderRadius.circular(CANCEL_BORDER_RADIUS)),
      child: Container(
        margin: CANCEL_INNER_MARGIN,
        padding: CANCEL_INNER_PADDING,
        decoration: BoxDecoration(
            color: CANCEL_BUTTON_COLOR,
            borderRadius: BorderRadius.circular(CANCEL_INNER_BORDER_RADIUS)),
        child: InkWell(
          onTap: () => projectProvider.cancelLastChange(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svg/cancel.svg'),
                const Text(
                  'Отменить действие',
                  style: TextStyle(
                      fontSize: 12,
                      // height: 16,
                      color: Color.fromRGBO(125, 125, 125, 1)),
                )
              ]),
        ),
      ),
    );
  }
}
