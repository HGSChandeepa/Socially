import 'package:flutter/material.dart';
import 'package:socially/models/reel_model.dart';
import 'video_player_widget.dart';

class ReelWidget extends StatelessWidget {
  final Reel reel;

  const ReelWidget({required this.reel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reel.caption,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayerWidget(videoUrl: reel.videoUrl),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  // Handle like functionality
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Handle edit functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Handle delete functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
