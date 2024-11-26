import 'package:get/get.dart';
import '../models/room_model.dart';
import '../services/device_service.dart';
import '../services/api_service.dart';

class RoomListController extends GetxController {
  final DeviceService _deviceService = DeviceService();
  final ApiService _apiService = ApiService();

  final RxList<Room> rooms = <Room>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      final userIdentify = await _deviceService.getUniqueDeviceIdentifier();
      rooms.value = await _apiService.getRoomsByUser(userIdentify);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch rooms');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Room> createNewRoom() async {
    try {
      final userIdentify = await _deviceService.getUniqueDeviceIdentifier();
      final newRoom = await _apiService.createRoom(userIdentify);
      rooms.add(newRoom);
      return newRoom;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create room');
      rethrow;
    }
  }
}