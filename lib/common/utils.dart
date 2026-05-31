import 'package:wenshiji/constants/config_constant.dart';

class Utils {
  static Season getSeason(DateTime time) {
    switch (time.month) {
      case 3||4||5:
        return Season.spring;
      case 6||7||8:
        return Season.summer;
      case 9||10||11:
       return Season.autumn;
      case 12||1||2:
        return Season.winter;
      default:
        return Season.spring;
    }
  }
}