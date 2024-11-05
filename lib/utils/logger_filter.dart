import 'package:logger/logger.dart';

class LoggerFIlter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
