import 'package:ayusharks/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConnectionRequestWidget extends StatefulWidget {
  const ConnectionRequestWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConnectionRequestWidgetState createState() =>
      _ConnectionRequestWidgetState();
}

class _ConnectionRequestWidgetState extends State<ConnectionRequestWidget> {
  bool _isLoading = false;
  List<Map<String, dynamic>>? connectionRequests;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    getAllRequest();
  }

  getAllRequest() async {
    setState(() {
      _isLoading = true;
    });
    connectionRequests =
        await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
            .getAllConnectionRequests(uid);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Connection request",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : connectionRequests == null
              ? const Center(
                  child: Text("No Request present"),
                )
              : ListView.builder(
                  itemCount: connectionRequests!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> request = connectionRequests![index];
                    String senderId = request['senderId'];
                    String status = request['status'];

                    return ListTile(
                      title: Text(senderId),
                      subtitle: Text('Status: $status'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Implement accept connection logic
                              DatabaseServices(uid: uid)
                                  .acceptConnection(senderId, uid);
                            },
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Implement reject connection logic
                              DatabaseServices(uid: uid)
                                  .rejectConnectionRequest(senderId);
                            },
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
