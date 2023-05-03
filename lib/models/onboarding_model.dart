import 'package:flutter/material.dart';

class OnbordingModel {
  String img;
  String title;
  String desc;

  OnbordingModel({
    required this.img,
    required this.title,
    required this.desc,
  });
}

List<OnbordingModel> contents = [
  OnbordingModel(
    img: 'assets/images/ic_onboarding1.png',
    title: "Hello! I'll help you to choose a movie!",
    desc:
        "Going to enjoy Movie Night? Don't know which movie will like your friends? I'll solve this problem easily!",
  ),
  OnbordingModel(
    img: 'assets/images/ic_onboarding2.png',
    title: "Invite friends for great movie night!",
    desc:
        "Only one tap to start! Cooperate with your friends, create personal Movie Night or eccept your friends invitations!",
  ),
  OnbordingModel(
    img: 'assets/images/ic_onboarding3.png',
    title: "Choose genres that you prefer the most!",
    desc:
        "Pick your favorite genres, and relevant movies will be included to the voting list.",
  ),
];
