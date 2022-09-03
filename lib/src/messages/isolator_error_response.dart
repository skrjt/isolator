import 'package:isolator/src/messages/isolator_response_message.dart';

class IsolatorErrorResponse implements IsolatorResponseMessage {
  final Object error;

  IsolatorErrorResponse({required this.error});
}