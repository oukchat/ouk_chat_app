import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_list_controller.dart';
import '../controllers/chat_controller.dart';
import '../models/room_model.dart';
import 'chat_screen.dart';

class RoomListScreen extends GetView<RoomListController> {
  const RoomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 채팅방', style: TextStyle(fontFamily: 'Retrosans'))),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.rooms.length,
          itemBuilder: (context, index) {
            if(index == 0) {
              return ListTile(
                title: Text('새 채팅', style: TextStyle(fontFamily: 'Retrosans'),),
                trailing: Icon(Icons.add, size: 25, weight: 40,),
                onTap: () async {
                  final newRoom = await controller.createNewRoom();
                  Get.to(() => ChatScreen(room: newRoom),
                      binding: BindingsBuilder(() {
                        Get.put(ChatController(newRoom));
                      })
                  );
                },
              );
            }

            final room = controller.rooms.reversed.toList()[index];
            return ListTile(
              title: Text('채팅방 ${room.id}', style: TextStyle(fontFamily: 'Retrosans'),),
              subtitle: Text(room.createdAt?.toString() ?? '', style: TextStyle(fontFamily: 'Retrosans'),),
              onTap: () {
                Get.to(() => ChatScreen(room: room),
                    binding: BindingsBuilder(() {
                      Get.put(ChatController(room));
                    })
                );
              },
            );
          },
        );
      }),
    );
  }
}