import 'dart:async';

import 'package:quick_scan/config/event_set.dart';
import 'package:quick_scan/services/channel_service.dart';

ChannelService channelService = ChannelService();

class VibrateService {
  static Future<void> vibrate() =>
      channelService.methodChannel.invokeMethod(EventSet.VIBRATE);
}
