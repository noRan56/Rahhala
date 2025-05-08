import 'package:equatable/equatable.dart';
import 'package:travel_app/data/cubit/user_cubit.dart';

class UserState extends Equatable {
  final String? username;
  final String? imageUrl;
  final UserStatus status;
  final String? errorMessage;

  const UserState({
    this.username,
    this.imageUrl,
    this.status = UserStatus.initial,
    this.errorMessage,
  });

  UserState copyWith({
    String? username,
    String? imageUrl,
    UserStatus? status,
    String? errorMessage,
  }) {
    return UserState(
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [username, imageUrl, status, errorMessage];
}
