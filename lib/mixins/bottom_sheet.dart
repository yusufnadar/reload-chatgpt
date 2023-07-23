import 'package:flutter/material.dart';
import '../constants/color_constants.dart';
import '../widgets/drop_down.dart';
import '../widgets/text_widget.dart';

mixin CustomSheet{
  Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorConstants.scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(
                  label: "Chosen Model:",
                  fontSize: 16,
                ),
              ),
              Flexible(flex: 2, child: ModelsDrowDownWidget()),
            ],
          ),
        );
      },
    );
  }

}