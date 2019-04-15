import 'package:flutter/services.dart';

import 'package:quick_scan/config/event_set.dart';

class ChannelService {
  EventChannel eventChannel = EventChannel(EventSet.EVENT_CHANNEL);
  MethodChannel methodChannel = MethodChannel(EventSet.READY);

  static final ChannelService _instance = new ChannelService._();

  factory ChannelService() {
    return _instance;
  }

  ChannelService._();
}
