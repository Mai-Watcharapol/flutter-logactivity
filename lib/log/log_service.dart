import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'LogType.dart';

class LogService {
  String _filePath = "";
  DateTime? _logFileDate;

  String get getLogFilePath => _filePath;

  String get getLogFileDate => _logFileDate.toString().split(' ')[0];

  Future<void> logInit() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month.toString().padLeft(2, '0');
      String day = DateTime.now().day.toString().padLeft(2, '0');
      String logDirPath = '${directory.path}/LOG/$year/$year-$month-${day}_activity.log';

      // สร้างโฟลเดอร์ถ้าไม่มี
      Directory logDirectory = Directory('${directory.path}/LOG/$year');
      if (!await logDirectory.exists()) {
        await logDirectory.create(recursive: true);
      }

      _filePath = logDirPath;

      // ตรวจสอบว่าไฟล์ของวันนั้นๆ ถูกสร้างหรือยัง
      if (await verifyDailyLogFileIsCreated(_filePath)) {
        _logFileDate = await File(_filePath).lastModified();
        if (isOldLogFile()) {
          deleteFile();
          createFile();
        }
      } else {
        createFile();
      }
    }
  }

  Future<bool> verifyDailyLogFileIsCreated(String path) async {
    File logFile = File(path);
    return await logFile.exists();
  }

  void addInfo(LogType logType, String msg, {bool isWrite = false}) {
    String logString = 'INFO ${createLogFormat(logType, msg)}';
    if (isWrite) {
      print(logString);
      writeLog(logString);
    } else {
      print(logString);
    }
  }

  void addWarn(LogType logType, String msg, {bool isWrite = false}) {
    String logString = 'WARN ${createLogFormat(logType, msg)}';
    if (isWrite) {
      print(logString);
      writeLog(logString);
    } else {
      print(logString);
    }
  }

  void addError(LogType logType, String msg, {bool isWrite = false}) {
    String logString = 'ERROR ${createLogFormat(logType, msg)}';
    if (isWrite) {
      print(logString);
      writeLog(logString);
    } else {
      print(logString);
    }
  }

  String createLogFormat(LogType logType, String msg) {
    return '[${DateTime.now()}] [User_1123] [${logType.toString().split('.').last}] - $msg\n';
  }

  bool isOldLogFile() {
    Duration diff = DateTime.now().difference(_logFileDate!);
    return diff.inDays >= (365 * 13 / 12);
  }

  void createFile() {
    File logFile = File(_filePath);
    logFile.createSync();
    _logFileDate = DateTime.now();
  }

  void deleteFile() {
    File logFile = File(_filePath);
    logFile.deleteSync();
  }

  void writeLog(String log) {
    File logFile = File(_filePath);
    logFile.writeAsStringSync(log, mode: FileMode.append);
  }
}
