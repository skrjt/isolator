import 'package:isolator/src/messages/response/isolator_response_message.dart';

/// Container with an erroneous response from the isolate.
class IsolatorErrorResponse implements IsolatorResponseMessage {
  final Object error;

  IsolatorErrorResponse({required this.error});
}