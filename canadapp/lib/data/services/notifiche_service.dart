import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificheService {
  final notifichePlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //inizialize
  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    const initializationSettingsAndroid = AndroidInitializationSettings(
      'assets/logo_app.png',
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notifichePlugin.initialize(initializationSettings);

    _isInitialized = true;
  }

  //notifiche setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'canadapp_channel',
        'CanadApp Notifications',
        channelDescription: 'Channel for CanadApp notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  //mostra notifiche
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notifichePlugin.show(id, title, body, notificationDetails());
  }

  //notifica scadenza certificato
  Future<void> notificaScadenzaCertificato(String dataScadenza) async {
    final notiDate = DateTime.parse(
      dataScadenza,
    ).subtract(const Duration(days: 14));
    //final notiDate = DateTime.now().add(const Duration(seconds: 10));        per testare
    await notifichePlugin.zonedSchedule(
      0,
      'Certificato in scadenza',
      'Il tuo certificato medicao scadrà tra 14 giorni',
      tz.TZDateTime.from(notiDate, tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    await checkPendingNotifications();
  }

  //elimina notifica scadenza certificato
  Future<void> deleteNotificaScadenzaCertificato() async {
    await notifichePlugin.cancel(0);
  }

  //vede se ci sono notifiche pendenti
  Future<void> checkPendingNotifications() async {
    final pendingNotifications =
        await notifichePlugin.pendingNotificationRequests();
    print('Notifiche pendenti: ${pendingNotifications.length}');
    for (var notification in pendingNotifications) {
      print('ID: ${notification.id}, Title: ${notification.title}');
    }
  }

  //notifica sessione sala pesi un'ora prima
  Future<void> notificaSessioneSalaPesi(String data, String ora) async {
    final notiDate = DateTime.parse(
      '$data $ora',
    ).subtract(const Duration(hours: 1));
    final id = await idNotificaSessioneSalaPesi(data, ora);

    await notifichePlugin.zonedSchedule(
      id,
      'Sessione Sala Pesi',
      'Hai una sessione in sala pesi tra un\'ora.',
      tz.TZDateTime.from(notiDate, tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    await checkPendingNotifications();
  }

  //cancella una notifica
  Future<void> deleteNotificaSalaPesi(int id) async {
    await notifichePlugin.cancel(id);
    await checkPendingNotifications();
  }

  //mi crea hashcode per id notifica
  Future<int> idNotificaSessioneSalaPesi(String data, String ora) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection('prenotazioni') // nome della tua collection
            .where('userId', isEqualTo: userId)
            .where('data', isEqualTo: data)
            .where('ora', isEqualTo: ora) // campo che contiene l'ID utente
            .get();

    String prenotazioneId = querySnapshot.docs.first.id;
    return prenotazioneId.hashCode;
  }
}
