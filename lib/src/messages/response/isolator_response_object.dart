import 'package:isolator/src/messages/response/isolator_response_message.dart';

/// The answer from the isolate with the result in the form of an object.
class IsolatorResponseObject<T> implements IsolatorResponseMessage{
  final T sendObject;

  IsolatorResponseObject({required this.sendObject});
}