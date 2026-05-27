import 'package:flutter/foundation.dart';

class AppConfig {
  static const String backendUrl = 'https://questlogbackend-production.up.railway.app/api/v1';
  
  static const String googleClientId = kDebugMode
      ? '531228559747-1ctb1pg7511ol94unltiiv4mb528uhqk.apps.googleusercontent.com' // Debug client ID
      : '531228559747-04vh3kol55mm7mp4fvsavv7stio02ed1.apps.googleusercontent.com'; // Release client ID
}
