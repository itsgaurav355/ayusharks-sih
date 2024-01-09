import "package:ayusharks/widget/widget.dart";
import "package:flutter/material.dart";

import "../pages/chat/community/chat_screen.dart";

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;
  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupName,
      required this.groupId});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
          context,
          ChatScreen(
              groupName: widget.groupName,
              groupId: widget.groupId,
              userName: widget.userName),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
