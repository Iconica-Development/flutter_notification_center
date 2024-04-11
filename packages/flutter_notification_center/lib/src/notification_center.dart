import 'package:flutter/material.dart';
import '../flutter_notification_center.dart';

/// Widget for displaying the notification center.
class NotificationCenter extends StatefulWidget {
  /// Constructs a new NotificationCenter instance.
  ///
  /// [config]: Configuration for the notification center.
  const NotificationCenter({
    required this.config,
    super.key,
  });

  /// Configuration for the notification center.
  final NotificationConfig config;

  @override
  NotificationCenterState createState() => NotificationCenterState();
}

/// State for the notification center.
class NotificationCenterState extends State<NotificationCenter> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    _notificationsFuture = widget.config.service.getActiveNotifications();
    widget.config.service.addListener(_listener);
  }

  @override
  void dispose() {
    widget.config.service.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.config.translations.appBarTitle,
          ),
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
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No unread notifications available."),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length * 2 - 1,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: widget.config.seperateNotificationsWithDivider
                          ? const Divider(
                              color: Colors.grey,
                              thickness: 1.0,
                            )
                          : Container(),
                    );
                  }
                  var notification = snapshot.data![index ~/ 2];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: widget.config
                        .notificationWidgetBuilder(notification, context),
                  );
                },
              );
            }
          },
        ),
      );
}
