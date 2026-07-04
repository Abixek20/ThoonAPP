// ─────────────────────────────────────────────────────────────────────────────
// THOON – FCM Notification Service Stub
// Replace stubs with actual firebase_messaging SDK calls.
// ─────────────────────────────────────────────────────────────────────────────

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  // ─── INIT ──────────────────────────────────────────────────────────────────

  /// Call once at app startup (after Firebase.initializeApp)
  Future<void> initialize() async {
    // TODO:
    // await FirebaseMessaging.instance.requestPermission();
    // _fcmToken = await FirebaseMessaging.instance.getToken();
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   _handleForegroundMessage(message);
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   _handleNotificationTap(message);
    // });
    _fcmToken = 'demo_fcm_token_12345';
  }

  // ─── SUBSCRIBE TOPICS ──────────────────────────────────────────────────────

  Future<void> subscribeToTopic(String topic) async {
    // TODO: await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    // TODO: await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  // ─── LOCAL NOTIFICATION TYPES ──────────────────────────────────────────────
  // These are the notification types the backend (Node.js) sends via FCM:

  // complaint_registered   → Sent when user submits complaint
  // employee_assigned      → Sent when admin assigns an employee
  // site_visit_scheduled   → Sent when site visit is confirmed
  // payment_success        → Sent after Razorpay payment confirmation
  // service_completed      → Sent when work is marked complete
  // offer_alert            → Sent for promotional offers
  // booking_update         → General booking status updates

  void _handleForegroundMessage(dynamic message) {
    // TODO: Show in-app overlay using PushNotificationOverlay.show(...)
  }

  void _handleNotificationTap(dynamic message) {
    // TODO: Navigate to relevant screen based on message data
  }
}
