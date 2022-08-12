import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_location_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_local_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../models/chat_geolocation_geolocation_dto.dart';
import '../models/chat_message_image_dto.dart';

/// Main screen of chat app, containing messages.
class ChatScreen extends StatefulWidget {
  /// Repository for chat functionality.
  final IChatRepository chatRepository;

  /// Constructor for [ChatScreen].
  const ChatScreen({
    required this.chatRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _nameEditingController = TextEditingController();
  late ChatGeolocationDto _location;
  bool _hasLocation = false;

  Iterable<ChatMessageDto> _currentMessages = [];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: _ChatAppBar(
          controller: _nameEditingController,
          onUpdatePressed: _onUpdatePressed,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ChatBody(
              messages: _currentMessages,
            ),
          ),
          _ChatTextField(
              onSendPressed: _onSendPressed,
              onAddLocationPressed: _onAddLocationPressed),
        ],
      ),
    );
  }

  Future<void> _onUpdatePressed() async {
    final messages = await widget.chatRepository.getMessages();
    setState(() {
      _currentMessages = messages;
    });
  }

  Future<void> _onSendPressed(String messageText) async {
    final messages = _hasLocation
        ? await widget.chatRepository
            .sendGeolocationMessage(message: messageText, location: _location)
        : await widget.chatRepository.sendMessage(messageText);
    setState(() {
      _currentMessages = messages;
      _hasLocation = false;
    });
  }

  void _onAddLocationPressed(ChatGeolocationDto location) {
    print("!location: $location");
    setState(() {
      _location = location;
      _hasLocation = true;
    });
  }
}

class _ChatBody extends StatelessWidget {
  final Iterable<ChatMessageDto> messages;

  const _ChatBody({
    required this.messages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) => _ChatMessage(
        chatData: messages.elementAt(index),
      ),
    );
  }
}

class _ChatTextField extends StatelessWidget {
  final ValueChanged<String> onSendPressed;
  final Function(ChatGeolocationDto) onAddLocationPressed;

  final _textEditingController = TextEditingController();

  _ChatTextField({
    required this.onSendPressed,
    required this.onAddLocationPressed,
    Key? key,
  }) : super(key: key);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getLocation() {
    _determinePosition().then((value) {
      final String oldValue = _textEditingController.text.toString();
      _textEditingController.value = TextEditingValue(
          text: "GEO: (${value.latitude};${value.longitude}) $oldValue",
          selection: TextSelection.fromPosition(
            const TextPosition(offset: 0),
          ));
      onAddLocationPressed(
          ChatGeolocationDto.fromGeoPoint([value.latitude, value.longitude]));
    }).catchError((e) => print("error$e"));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + 8,
          left: 16,
        ),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
            IconButton(
                onPressed: () => getLocation(),
                icon: const Icon(Icons.location_pin)),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Сообщение',
                ),
              ),
            ),
            IconButton(
              onPressed: () => onSendPressed(_textEditingController.text),
              icon: const Icon(Icons.send),
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final VoidCallback onUpdatePressed;
  final TextEditingController controller;

  const _ChatAppBar({
    required this.onUpdatePressed,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onUpdatePressed,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final ChatMessageDto chatData;

  const _ChatMessage({
    required this.chatData,
    Key? key,
  }) : super(key: key);

  Future<void> openMap(double latitude, double longitude) async {
    var url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (Platform.isIOS) {
      url = Uri.parse('http://maps.apple.com/?ll=$latitude,$longitude');
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: chatData.chatUserDto is ChatUserLocalDto
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            _ChatAvatar(userData: chatData.chatUserDto),
            const SizedBox(width: 16),
            Expanded(
              child: ChatBubble(
                clipper: ChatBubbleClipper1(
                    type: chatData.chatUserDto is ChatUserLocalDto
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble),
                margin: const EdgeInsets.only(right: 5, top: 15),
                backGroundColor: chatData.chatUserDto is ChatUserLocalDto
                    ? colorScheme.primary.withOpacity(.3)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      chatData.chatUserDto.name == null
                          ? 'Unknown name'
                          : chatData.chatUserDto.name!.trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(chatData.message ?? ''),
                    if (chatData is ChatMessageGeolocationDto)
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.cyanAccent),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () => openMap(
                            (chatData as ChatMessageGeolocationDto)
                                .location
                                .latitude,
                            (chatData as ChatMessageGeolocationDto)
                                .location
                                .longitude),
                        child: const Text("Open maps"),
                      ),
                    if (chatData is ChatMessageImageDto)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            (chatData as ChatMessageImageDto).imageUrls.length,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        itemBuilder: ((_, index) => Image.network(
                            (chatData as ChatMessageImageDto)
                                .imageUrls[index])),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  static const double _size = 42;
  static const List<Color> colors = [
    Colors.redAccent,
    Colors.amber,
    Colors.lightGreen,
    Colors.deepPurpleAccent,
    Colors.lightBlue,
    Colors.pinkAccent
  ];

  Color getColorByName(String str) {
    return colors[str.codeUnitAt(0) % colors.length];
  }

  final ChatUserDto userData;

  const _ChatAvatar({
    required this.userData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = getColorByName(userData.name ?? "Unknown name");
    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            userData.name != null
                ? '${userData.name!.split(' ').first[0]}${userData.name!.split(' ').last[0]}'
                : '?',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
