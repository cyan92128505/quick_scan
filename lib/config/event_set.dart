import 'dart:convert';

class EventSet {
  static const READY = 'charon_ready';
  static const READY_INVOKE = 'charon_ready_invoke';
  static const EVENT_CHANNEL = 'charon_event_channel';
  static const DEEP_LINK = 'charon.deep.link';
  static const NOTIFICATION = 'charon_notification';

  static Map<String, dynamic> decode(String nativeMessage) {
    return jsonDecode(nativeMessage);
  }
}
