import 'package:flutter/material.dart';
import 'package:flutter_notification_center/src/models/notification.dart';
import 'package:flutter_notification_center/src/models/notification_theme.dart';
import 'package:flutter_notification_center/src/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationCenter extends StatefulWidget {
  final NotificationService notificationCenterService;
  final NotificationStyle? notificationTheme;

  const NotificationCenter({
    Key? key,
    required this.notificationCenterService,
    this.notificationTheme,
  }) : super(key: key);

  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture =
        widget.notificationCenterService.getActiveNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No unread notifications available.'));
          } else {
            final unreadNotifications = snapshot.data!.toList();

            return ListView.builder(
              itemCount: unreadNotifications.length,
              itemBuilder: (context, index) {
                final notification = unreadNotifications[index];
                final formattedDateTime = notification.dateTimePushed != null
                    ? DateFormat('yyyy-MM-dd HH:mm')
                        .format(notification.dateTimePushed!)
                    : 'Pending';
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: widget.notificationTheme?.titleTextStyle ??
                            const TextStyle(),
                      ),
                      Text(
                        notification.body,
                        style: widget.notificationTheme?.subtitleTextStyle ??
                            const TextStyle(),
                      ),
                      Text(
                        formattedDateTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        widget.notificationCenterService
                            .dismissActiveNotification(notification);
                        print('Notification dismissed: $notification');
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.notificationCenterService.createRecurringNotification(
            NotificationModel(
                id: 3,
                title: 'HALLO',
                body: 'DIT IS DE BODY',
                recurring: true,
                occuringInterval: OcurringInterval.debug,
                scheduledFor: DateTime.now().add(const Duration(seconds: 5))),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
