import 'profiler_data.dart';
import 'package:flutter/foundation.dart';

class Profiler {
  static final Profiler instance = new Profiler._();
  bool _bStarted = false;

  List<ProfilerData> _data = List<ProfilerData>();

  Profiler._();

  void start() {
    this._data.clear();
    this._bStarted = true;
  }

  void stop() {
    this._bStarted = false;
    this._data.clear();
  }

  void add(ProfilerData data) {
    if (this._bStarted) this._data.add(data);
  }

  @override
  String toString() {
    if (false == this._bStarted || this._data.length <= 1) {
      return "";
    }

    String profilerInformation = '';
    Iterator<ProfilerData> _iterator = this._data.iterator;
    _iterator.moveNext(); // Advance to first item.
    ProfilerData firstData = _iterator.current;
    Map<String, int> _catogirizeNumber = Map<String, int>();

    profilerInformation +=
        "----------------------- BEGIN PROFILER DATA ------------------------ \r\n\r\n ";

    profilerInformation +=
        "------------------------------ Step wise performance information ------------------";
    while (_iterator.moveNext()) {
      ProfilerData current = _iterator.current;
      profilerInformation += "\r\n" +
          "${firstData.category}:${firstData.description} took ${current.time.microsecondsSinceEpoch - firstData.time.microsecondsSinceEpoch} micro seconds to execute upto ${current.category}:${current.description}";

      if (_catogirizeNumber.containsKey(firstData.category)) {
        _catogirizeNumber[firstData.category] +=
            current.time.microsecondsSinceEpoch -
                firstData.time.microsecondsSinceEpoch;
      } else {
        _catogirizeNumber[firstData.category] =
            current.time.microsecondsSinceEpoch -
                firstData.time.microsecondsSinceEpoch;
      }

      firstData = current;
    }

    if (_catogirizeNumber.length > 0) {
      profilerInformation += "\r\n" +
          "------------------------------ Category wise performance information ------------------";

      _catogirizeNumber.forEach((str, time) {
        profilerInformation += "\r\n" + "Category $str took $time microseconds";
      });

      profilerInformation +=
          "\r\n \r\n ----------------------- END PROFILER DATA ------------------------";
    }

    return profilerInformation;
  }

  void print() {
    if (this._data.length <= 1) {
      debugPrint("Atleast two entries are needed for profiler to return data");
    }

    debugPrint(this.toString());
    clear();
  }

  void clear() {
    this._data.clear();
  }
}
