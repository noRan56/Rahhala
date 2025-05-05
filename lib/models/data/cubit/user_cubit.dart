import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/models/data/cubit/user_state.dart';
import 'package:travel_app/models/model/shared_perferences.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final username = await SharedPerferencesHelper.getUserName();
      final image = await SharedPerferencesHelper.getUserImage();

      emit(
        state.copyWith(
          username: username,
          imageUrl: image,
          status: UserStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateUser(String username, String? imageUrl) async {
    try {
      emit(state.copyWith(status: UserStatus.loading));

      // Save to SharedPreferences
      await SharedPerferencesHelper.saveUserName(username);
      if (imageUrl != null) {
        await SharedPerferencesHelper.saveUserImage(imageUrl);
      }

      emit(
        state.copyWith(
          username: username,
          imageUrl: imageUrl,
          status: UserStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.error, errorMessage: e.toString()),
      );
    }
  }
}

enum UserStatus { initial, loading, loaded, error }
