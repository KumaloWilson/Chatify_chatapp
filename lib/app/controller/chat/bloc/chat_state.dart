part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {} 

class ChatSuccess extends ChatState {}

class NavigatedSearchPageDoneState extends ChatState{}

class BottomSheetSuccessState extends ChatState{}

class GalleryImageSentSuccessState extends ChatState{}

class VideoCallWorkingState extends ChatState {
  final String token;
  final String name;
  VideoCallWorkingState({
    required this.token,
    required this.name,
  });
}
class ChattedUserDeletedState extends ChatState{}