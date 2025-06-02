import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TafsirAudioService {
  static final TafsirAudioService _instance = TafsirAudioService._internal();
  factory TafsirAudioService() => _instance;
  TafsirAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentReciter;
  int? _currentSurah;
  int? _currentVerse;

  final List<Map<String, String>> _reciters = [
    {
      'name': 'Saad Al-Ghamdi',
      'name_bn': 'সা\'দ আল-গামিদী',
      'url': 'https://example.com/reciter1.mp3',
    },
    {
      'name': 'Mishary Rashid Alafasy',
      'name_bn': 'মিশারি রশিদ আল-আফাসি',
      'url': 'https://example.com/reciter2.mp3',
    },
    {
      'name': 'Abdul Basit',
      'name_bn': 'আব্দুল বাসিত',
      'url': 'https://example.com/reciter3.mp3',
    },
    {
      'name': 'Saud Al-Shuraim',
      'name_bn': 'সাউদ আল-শুরাইম',
      'url': 'https://example.com/reciter4.mp3',
    },
    {
      'name': 'Maher Al-Muaiqly',
      'name_bn': 'মাহের আল-মুয়াইকলি',
      'url': 'https://example.com/reciter5.mp3',
    },
  ];

  List<String> get availableReciters => _reciters.map((e) => e['name']!).toList();
  bool get isPlaying => _isPlaying;
  String? get currentReciter => _currentReciter;
  int? get currentSurah => _currentSurah;
  int? get currentVerse => _currentVerse;

  Future<void> playVerse({
    required String reciter,
    required int surahNumber,
    required int verseNumber,
  }) async {
    try {
      if (_isPlaying) {
        await stop();
      }

      // TODO: Replace with actual audio URL
      final audioUrl = 'https://example.com/audio/$reciter/$surahNumber/$verseNumber.mp3';
      
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      
      _isPlaying = true;
      _currentReciter = reciter;
      _currentSurah = surahNumber;
      _currentVerse = verseNumber;
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    _isPlaying = true;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentReciter = null;
    _currentSurah = null;
    _currentVerse = null;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
} 