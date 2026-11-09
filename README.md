# 🤖 Gemini AI App

**A Flutter chat app for Android powered by Google Gemini: ask with text, photos, voice notes, video, PDFs or text files, get streamed Markdown answers, and keep every conversation on your phone.**

[![CI](https://github.com/Umair-Habibx123/gemini-ai-app/actions/workflows/ci.yml/badge.svg)](https://github.com/Umair-Habibx123/gemini-ai-app/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/v/release/Umair-Habibx123/gemini-ai-app?label=APK)](https://github.com/Umair-Habibx123/gemini-ai-app/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

**[⬇️ Download the latest APK](https://github.com/Umair-Habibx123/gemini-ai-app/releases/latest)** · Android 7.0+ · enable "Install unknown apps" for your browser or file manager first.

## Features

- **Chat with Gemini:** replies stream in word by word and render as Markdown (code blocks, lists, tables)
- **Attachments:**
  - Images: from the gallery
  - Voice notes: recorded in the app, with playback
  - Files: video, audio, PDF, and text files (`.md`, `.csv`, `.json`)
- **Model picker with automatic fallback:** choose a Gemini model; if it's overloaded or unavailable, the app tries the next one in the list
- **Chat history:** conversations and messages saved on the phone (SQLite); start, reopen or delete chats
- **Message actions:** copy, share, and full-screen image preview with zoom
- **Light and dark themes,** remembered between launches
- **Offline aware:** detects a lost connection and offers to try again

## Install

1. Open the **[latest release](https://github.com/Umair-Habibx123/gemini-ai-app/releases/latest)** and download `gemini_ai_app-vX.Y.Z.apk`.
2. Optionally check it against the `.sha256` file next to it.
3. Open the APK on your phone and allow installing from that app if Android asks.

Releases from v1.2.0 on are signed with the same key, so new versions install over old ones. v1.0 and v1.1 used the old app ID, so uninstall them first.

## Build it yourself

You need **Flutter 3.47+**, the Android SDK and a free Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey).

```bash
git clone https://github.com/Umair-Habibx123/gemini-ai-app.git
cd gemini-ai-app
```

Create a `.env` file in the project root:

```env
API_KEY=your_gemini_api_key
# Model fallback chain, highest priority first. Models your key can't use are skipped.
GEMINI_MODELS=gemini-2.5-flash,gemini-2.5-flash-lite,gemini-2.0-flash
```

```bash
flutter pub get
flutter run                     # on a connected phone or emulator
flutter build apk --release     # APK in build/app/outputs/flutter-apk/
```

Without `android/key.properties`, release builds are signed with the debug key. That's fine for testing on your own phone.

| Command | What it does |
|---|---|
| `flutter test` | Runs the tests: model-list parsing, theme persistence, and the offline screen |
| `flutter analyze` | Static analysis |

> **About the API key:** the app calls Gemini directly from the phone, so the key is inside the APK and can be extracted. The published releases use a key on a free-tier project with no billing, restricted to the Gemini API, so the worst case is someone using up its free quota. For your own builds, use a key you're comfortable treating as public, or put Gemini behind your own backend.

## How it's built

| Part | What it uses |
|---|---|
| AI | `google_generative_ai` (streaming chat sessions, multimodal parts) |
| State | `provider` |
| Storage | `sqflite` for chats and messages, `shared_preferences` for settings |
| Media | `image_picker`, `file_picker`, `record`, `audioplayers`, `photo_view` |
| Rendering | `gpt_markdown` |
| Device | `connectivity_plus`, `permission_handler`, `share_plus`, `url_launcher`, `open_filex` |

```
lib/
├── main.dart          app setup, .env loading, model list
├── screens/           chat, splash, offline screen
├── widgets/           app bar, input area, message list, Markdown view, image preview, audio player
├── DB/                SQLite chat history
├── providers/         theme
├── services/          connectivity
└── theme/             light and dark themes
```

## Releasing (for maintainers)

Pushing a version tag builds a signed APK in GitHub Actions and publishes it as a release:

```bash
git tag v1.2.0
git push origin v1.2.0
```

The workflow needs these repository secrets: `GEMINI_API_KEY`, `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`. See [`.github/workflows/release.yml`](.github/workflows/release.yml).

## License

[MIT](LICENSE) © 2025 [Umair Habib](https://github.com/Umair-Habibx123)
