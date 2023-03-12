import 'package:flutter/material.dart';
import 'package:uber_rider_app/Global/constants.dart';

enum MessageState {
  error,
  success,
  info,
  warning,
}

class ShowMessage extends StatelessWidget {
  final String? message;
  final String? title;
  final MessageState? state;

  const ShowMessage(
      {Key? key, this.state = MessageState.info, this.message, this.title})
      : super(key: key);

  getIcon(MessageState? state) {
    switch (state) {
      case MessageState.error:
        return const Icon(
          Icons.error,
          color: Colors.red,
        );
      case MessageState.success:
        return const Icon(
          Icons.check,
          color: Colors.green,
        );
      case MessageState.info:
        return const Icon(
          Icons.info,
          color: Colors.blue,
        );
      case MessageState.warning:
        return const Icon(
          Icons.warning,
          color: Colors.orange,
        );
      default:
        return const Icon(
          Icons.info,
          color: Colors.blue,
        );
    }
  }

  getBorderColor(MessageState? state) {
    switch (state) {
      case MessageState.error:
        return Colors.red;
      case MessageState.success:
        return Colors.green;
      case MessageState.info:
        return Colors.blue;
      case MessageState.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        // color: getBorderColor(state),
        border: Border.all(
          color: getBorderColor(state),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 70,
      width: getSize(context).width,
      child: Row(
        children: [
          const SizedBox(width: 16),
          getIcon(state),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                    fontSize: FONT_SIZE_16,
                    fontFamily: FONT_BOLT_BOLD,
                    color: getBorderColor(state),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message ?? "",
                  style: TextStyle(
                    fontSize: FONT_SIZE_16,
                    fontFamily: FONT_BOLT_REGULAR,
                    color: getBorderColor(state),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
