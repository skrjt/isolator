import 'package:isolator/src/messages/isolator_response_message.dart';

class IsolatorResponseObject<T> implements IsolatorResponseMessage{
  final T sendObject;

  IsolatorResponseObject({required this.sendObject});
}