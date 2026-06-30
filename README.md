# NexusNet

A modern, scalable networking package for Flutter built on top of Dio.

NexusNet provides:

- 🚀 Simple HTTP APIs
- 🔐 Authentication support
- 🔄 Automatic token refresh
- 📤 Multipart file uploads
- 📥 File downloads
- 📶 Connectivity checking
- ❌ Request cancellation
- 🔁 Automatic retries
- 📝 Request logging
- ⚡ Clean architecture
- 🎯 Minimal configuration

---

## Installation

```yaml
dependencies:
  nexus_net: ^1.0.0
```

---

## Initialize

```dart
await NexusClient.initialize(
  config: NetworkConfig(
    baseUrl: 'https://api.example.com',

    authProvider: JwtAuthProvider(storage),

    tokenManager: AppTokenManager(storage),

    refreshEndpoint: '/auth/refresh',

    refreshRequestBodyBuilder: (refreshToken) {
      return {
        'refresh_token': refreshToken,
      };
    },

    refreshTokenParser: (json) {
      return TokenPair(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );
    },

    enableLogs: true,
  ),
);
```

---

## GET Request

```dart
final api = ApiService();

final response = await api.get(
  '/users',
);

print(response.data);
```

---

## POST Request

```dart
await api.post(
  '/login',
  body: {
    'email': email,
    'password': password,
  },
);
```

---

## Public Request

```dart
await api.get(
  '/countries',
  options: const NetworkRequestOptions(
    requiresAuth: false,
  ),
);
```

---

## Upload Files

```dart
final upload = UploadService();

await upload.upload(
  endpoint: '/upload',
  files: [
    UploadFile(
      path: image.path,
      fieldName: 'avatar',
    ),
  ],
);
```

---

## Download File

```dart
final download = DownloadService();

await download.download(
  url: fileUrl,
  savePath: savePath,
);
```

---

## Cancel Requests

```dart
await api.get(
  '/search',
  options: const NetworkRequestOptions(
    tag: 'search',
  ),
);
```

```dart
CancellationManager.cancelTag(
  'search',
);
```

---

## Error Handling

```dart
try {
  await api.get('/profile');
} on NetworkException catch (e) {
  print(e.message);
}
```

---

## Features

- Authentication
- Automatic Token Refresh
- Upload & Download
- Connectivity Checking
- Retry Support
- Request Cancellation
- Progress Tracking
- Logging