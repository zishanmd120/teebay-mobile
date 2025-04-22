import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../main/routes/app_routes.dart';
import '../product/presentation/controllers/product_controller.dart';

class NotificationUtils {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final NotificationUtils _instance = NotificationUtils._internal();

  factory NotificationUtils() => _instance;

  NotificationUtils._internal();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'teebay',
    'teebay notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    showBadge: true,
  );

  Future<void> setupNotification() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      defaultPresentBadge: true,
    );

    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _setupForegroundListener();
    _setupBackgroundListener();
    _setupTerminatedMessage();
  }

  void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
          ),
          payload: message.data['product_id'],
        );
      }
    });
  }

  void _setupBackgroundListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data);
      final productIdStr = message.data['product_id'];
      print(productIdStr);
      final productId = int.tryParse(productIdStr ?? '');
      _navigateToScreen(productId);
    });
  }

  void _setupTerminatedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    print(initialMessage?.data);
    if (initialMessage != null) {
      final productIdStr = initialMessage.data['product_id'];
      print(productIdStr);
      final productId = int.tryParse(productIdStr ?? '');
      _navigateToScreen(productId);
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    print(response.payload);
    int? productId = int.tryParse(response.payload ?? '0');
    _navigateToScreen(productId);
  }

  void _navigateToScreen(int? productId) {
    print("productId $productId");
    Get.toNamed(AppRoutes.productDetails);
    var controller = Get.find<ProductController>();
    controller.fetchSingleProduct(productId ?? 0,);
  }
}
