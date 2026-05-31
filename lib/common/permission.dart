import 'package:location/location.dart' ;

class Permission {
  
// Future<void> requestLocationPermission() async {
//   // 1. 检查权限状态
//   permission_handler.PermissionStatus status = await permission_handler.Permission.location.status;
  
//   // 2. 如果权限已被授予，直接返回
//   if (status.isGranted) {
//     return;
//   }

//   // 3. 如果权限未决定或已被拒绝但未永久，则弹出系统权限请求对话框
//   if (status.isDenied || status.isRestricted) {
//     // 在请求前，可弹出自定义对话框解释用途
//     // bool shouldRequest = await showDialog(...);
//     status = await permission_handler.Permission.location.request();
//   }

//   // 4. 处理最终状态
//   if (status.isGranted) {
//     // 权限已授予，可以开始定位
//     print("定位权限已授予");
//   } else if (status.isPermanentlyDenied) {
//     // 用户选择了"不再询问"，必须引导用户去设置中开启
//     print("定位权限已被永久拒绝，请引导用户去设置中开启");
//     // 可以调用 openAppSettings() 方法打开应用设置页
//     await permission_handler.openAppSettings();
//   }
// }



Future<LocationData?> getCurrentLocation() async {
  // 1. 创建 Location 实例
  Location location = Location();

  // 2. 检查并请求权限
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // 2.1 检查服务是否开启
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  // 2.2 检查权限状态
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  // 3. 权限检查通过，获取位置
  LocationData currentLocation = await location.getLocation();
  return currentLocation;
}

}
final permission = Permission();