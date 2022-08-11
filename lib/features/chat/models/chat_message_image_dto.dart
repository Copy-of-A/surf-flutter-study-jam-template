import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class ChatMessageImageDto extends ChatMessageDto {
  /// Image url.
  final List<String> imageUrls;

  /// Constructor for [ChatMessageImageDto].
  ChatMessageImageDto({
    required ChatUserDto chatUserDto,
    required this.imageUrls,
    required String message,
    required DateTime createdDate,
  }) : super(
    chatUserDto: chatUserDto,
    message: message,
    createdDateTime: createdDate,
  );

  /// Named constructor for converting DTO from [StudyJamClient].
  ChatMessageImageDto.fromSJClient({
    required SjMessageDto sjMessageDto,
    required SjUserDto sjUserDto,
  })  : imageUrls = sjMessageDto.images!,
        super(
        createdDateTime: sjMessageDto.created,
        message: sjMessageDto.text,
        chatUserDto: ChatUserDto.fromSJClient(sjUserDto),
      );

  // @override
  // String toString() => '${imageUrls[0]}';
}
