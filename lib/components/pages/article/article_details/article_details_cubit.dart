import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';

class ArticleDetailsCubit extends Cubit<ArticleDetailsState> {
  ArticleDetailsCubit() : super(ArticleDetailsInitial());

  void loadArticle(Map<String, dynamic> articleData) {
    final description = articleData['description']['ops'];
    final controller = QuillController(
      document: Document.fromJson(description),
      selection: TextSelection.collapsed(offset: 0),
    );
    emit(ArticleDetailsLoaded(controller));
  }
}

abstract class ArticleDetailsState {}

class ArticleDetailsInitial extends ArticleDetailsState {}

class ArticleDetailsLoaded extends ArticleDetailsState {
  final QuillController controller;

  ArticleDetailsLoaded(this.controller);
}
