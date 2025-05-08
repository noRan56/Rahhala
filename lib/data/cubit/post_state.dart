part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {}

class PostsLoaded extends PostState {
  final List<PostModel> posts;

  PostsLoaded(this.posts);
}

class PostFailure extends PostState {
  final String error;

  const PostFailure(this.error);

  @override
  List<Object> get props => [error];
}
