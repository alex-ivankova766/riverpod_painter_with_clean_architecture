import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/repositories/project_data_repository_impl.dart';
import 'consts.dart';

class SwitchStateButtons extends StatelessWidget {
  const SwitchStateButtons({
    super.key,
    required this.projectProvider,
  });

  final ProjectDataRepositoryImpl projectProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SWITCH_STATE_BUTTON_SIZE.width,
      height: SWITCH_STATE_BUTTON_SIZE.height,
      decoration: BoxDecoration(
          color: SWITCH_STATE_BUTTON_COLOR,
          borderRadius:
              BorderRadius.circular(SWITCH_STATE_BUTTON_BORDER_RADIUS)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: SWITCH_STATE_BUTTON_SIZE.width / 2 - DIVIDER_WIDTH / 2,
              child: InkWell(
                onTap: () => projectProvider.projectData.currentStateIndex < 0
                    ? null
                    : projectProvider.switchToPreviousState(),
                child: projectProvider.projectData.currentStateIndex < 0
                    ? SvgPicture.asset('assets/svg/arrow_back_innactive.svg')
                    : SvgPicture.asset('assets/svg/arrow_back.svg'),
              )),
          Container(
            height: DIVIDER_HEIGHT,
            width: DIVIDER_WIDTH,
            color: DIVIDER_COLOR,
          ),
          SizedBox(
              width: SWITCH_STATE_BUTTON_SIZE.width / 2 - DIVIDER_WIDTH / 2,
              child: InkWell(
                onTap: () => projectProvider.projectData.statesList.isEmpty ||
                        projectProvider.currentState ==
                            projectProvider.projectData.statesList.last
                    ? null
                    : projectProvider.switchToNextState(),
                child: projectProvider.projectData.statesList.isEmpty ||
                        projectProvider.currentState ==
                            projectProvider.projectData.statesList.last
                    ? SvgPicture.asset('assets/svg/arrow_forward_innactive.svg')
                    : SvgPicture.asset('assets/svg/arrow_forward.svg'),
              )),
        ],
      ),
    );
  }
}
