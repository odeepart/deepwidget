# Deep Widget

Deep Widget là ứng dụng Flutter dành cho Android, giúp đưa một ảnh từ bộ sưu
tập lên màn hình chính dưới dạng widget. Ảnh được chuẩn hóa thành PNG và giữ
nguyên kênh alpha, vì vậy vùng trong suốt của ảnh cho phép hình nền launcher
xuyên qua.

Tài liệu này dành cho cả người dùng chỉ muốn cài ứng dụng và người mới bắt đầu
muốn tải mã nguồn, chỉnh sửa, chạy debug bằng VS Code hoặc hỗ trợ phát triển dự
án.

> **Trạng thái phát hành:** dự án hiện ở phiên bản `1.0.2+3`, tập trung cho
> Android 7.0/API 24 trở lên. Build `release` yêu cầu khóa riêng của maintainer
> và sẽ dừng nếu chưa cấu hình, để tránh phát hành nhầm bằng khóa debug công khai.
> Hãy đọc phần [Tạo bản phát hành chính thức](#tạo-bản-phát-hành-chính-thức)
> trước khi phân phối ứng dụng cho cộng đồng hoặc đưa lên Google Play.

## Mục lục

- [Chức năng](#chức-năng)
- [Cài ứng dụng dành cho người dùng](#cài-ứng-dụng-dành-cho-người-dùng)
- [Chuẩn bị môi trường phát triển từ đầu](#chuẩn-bị-môi-trường-phát-triển-từ-đầu)
- [Cài Codex trong VS Code](#cài-codex-trong-vs-code)
- [Tải và mở mã nguồn](#tải-và-mở-mã-nguồn)
- [Cài thư viện và kiểm tra dự án](#cài-thư-viện-và-kiểm-tra-dự-án)
- [Kết nối điện thoại Android qua USB](#kết-nối-điện-thoại-android-qua-usb)
- [Chạy debug](#chạy-debug)
- [Tự động hot reload sau khi lưu](#tự-động-hot-reload-sau-khi-lưu)
- [Cách sử dụng Deep Widget](#cách-sử-dụng-deep-widget)
- [Build và cài APK](#build-và-cài-apk)
- [Tạo bản phát hành chính thức](#tạo-bản-phát-hành-chính-thức)
- [Cấu trúc mã nguồn](#cấu-trúc-mã-nguồn)
- [Đưa mã nguồn lên GitHub](#đưa-mã-nguồn-lên-github)
- [Đóng góp cho dự án](#đóng-góp-cho-dự-án)
- [Xử lý lỗi thường gặp](#xử-lý-lỗi-thường-gặp)
- [Quyền riêng tư và giới hạn hiện tại](#quyền-riêng-tư-và-giới-hạn-hiện-tại)
- [Giấy phép mã nguồn mở](#giấy-phép-mã-nguồn-mở)

## Chức năng

- Chọn ảnh PNG, JPG hoặc WebP từ bộ sưu tập.
- Chuẩn hóa ảnh thành PNG mà không phủ nền màu đặc.
- Giữ vùng alpha trong suốt để hình nền màn hình chính xuyên qua.
- Điều chỉnh mức bo góc widget từ `0%` đến `50%`.
- Xem trước mức bo góc ngay trong ứng dụng.
- Tự cập nhật tất cả Deep Widget đang có trên màn hình chính.
- Yêu cầu ghim widget trực tiếp trên launcher hỗ trợ Android API 26 trở lên.
- Hướng dẫn thêm thủ công nếu launcher không hỗ trợ ghim nhanh.
- Hỗ trợ thay đổi kích thước ngang và dọc; ảnh luôn giữ đúng tỉ lệ.
- Cài mới luôn ở trạng thái trống, không đóng gói ảnh mẫu hoặc dữ liệu cá nhân.
- Không yêu cầu quyền đọc toàn bộ thư viện ảnh.
- Không tải ảnh của người dùng lên máy chủ.

### Giới hạn cần biết

- Phiên bản hiện tại chỉ hỗ trợ Android.
- Tất cả widget đang ghim dùng chung ảnh và mức bo góc hiện tại.
- Một số launcher không hỗ trợ nút ghim nhanh. Trong trường hợp đó cần thêm
  widget thủ công từ màn hình chính.
- PNG chỉ xuyên nền nếu chính tệp nguồn thật sự có pixel alpha trong suốt. Ảnh
  nền trắng được lưu dưới dạng PNG không tự động trở thành ảnh trong suốt.

## Cài ứng dụng dành cho người dùng

Phần này dành cho người chỉ muốn dùng Deep Widget, không cần cài Flutter, VS
Code, Android Studio hoặc Codex.

### Cài từ tệp APK phát hành

1. Mở trang **Releases** của kho mã nguồn chính thức nơi bạn đang đọc README
   này.
2. Chọn bản phát hành mới nhất, đọc ghi chú thay đổi và tải tệp APK phát hành.
   Chỉ tải từ trang của dự án; không cài APK được gửi từ nguồn không rõ ràng.
3. Nếu dự án công bố mã SHA-256, hãy đối chiếu mã trước khi cài.
4. Mở tệp APK trên điện thoại.
5. Android có thể yêu cầu cho phép ứng dụng đang mở APK cài ứng dụng không rõ
   nguồn. Chỉ cấp quyền cho trình duyệt hoặc trình quản lý tệp bạn đang dùng.
6. Chọn **Install/Cài đặt**.
7. Sau khi cài xong, mở **Deep Widget** từ danh sách ứng dụng.

Bạn không cần bật USB debugging nếu chỉ cài APK trực tiếp trên điện thoại.

### Cập nhật ứng dụng

Tải APK mới hơn từ cùng trang Releases rồi cài đè. Android chỉ cho phép cập
nhật nếu APK mới có cùng `applicationId` và được ký bằng cùng khóa với bản đang
cài.

Nếu Android báo `App not installed` hoặc `INSTALL_FAILED_UPDATE_INCOMPATIBLE`,
hai APK có thể được ký bằng hai khóa khác nhau. Gỡ bản cũ rồi cài bản mới sẽ làm
mất ảnh và thiết lập đang lưu trong ứng dụng, vì vậy chỉ làm việc này sau khi
đã hiểu nguyên nhân.

## Chuẩn bị môi trường phát triển từ đầu

Hướng dẫn dưới đây ưu tiên Windows 10/11 64-bit. Người dùng macOS hoặc Linux có
thể dùng cùng các lệnh Flutter nhưng cần làm theo hướng dẫn cài đặt tương ứng
của từng hệ điều hành.

### Máy tính và thiết bị cần có

- Windows 10/11 64-bit.
- Tối thiểu khoảng 8 GB RAM; 16 GB trở lên thuận tiện hơn nếu dùng Android
  Emulator.
- Khoảng 20 GB dung lượng trống cho Flutter, Android Studio, Android SDK và bộ
  nhớ build. Emulator cần thêm dung lượng.
- Internet để tải công cụ và package lần đầu.
- Điện thoại Android 7.0/API 24 trở lên.
- Cáp USB có truyền dữ liệu. Nhiều cáp rẻ chỉ hỗ trợ sạc và sẽ không được ADB
  nhận diện.

Môi trường đã dùng để kiểm tra dự án:

| Thành phần | Phiên bản đã kiểm tra |
| --- | --- |
| Flutter | `3.44.4`, kênh stable |
| Dart | `3.12.2` |
| Android SDK | `36` |
| Java/JDK | `17` |
| Android tối thiểu | API `24` |

Không bắt buộc phải cài đúng từng bản vá ở bảng trên. Nên dùng Flutter stable
và Android Studio stable hiện hành, sau đó chạy `flutter doctor -v` để phát
hiện điểm chưa tương thích.

### 1. Cài Visual Studio Code

1. Tải **User Installer** từ
   [trang cài VS Code cho Windows](https://code.visualstudio.com/docs/setup/windows).
2. Chạy tệp `VSCodeUserSetup-<version>.exe`.
3. Giữ tùy chọn thêm lệnh `code` vào `PATH` nếu trình cài đặt hiển thị tùy chọn
   này.
4. Hoàn tất cài đặt rồi đóng và mở lại PowerShell.
5. Kiểm tra:

```powershell
code --version
```

Nếu lệnh `code` chưa được nhận, khởi động lại Windows hoặc mở VS Code bằng menu
Start. Việc thiếu lệnh `code` không ngăn bạn dùng giao diện VS Code.

### 2. Cài Git

Git dùng để tải mã nguồn, tạo nhánh và gửi đóng góp.

1. Tải Git từ [Git for Windows](https://git-scm.com/install/windows), hoặc cài
   bằng `winget`:

```powershell
winget install --id Git.Git -e --source winget
```

2. Đóng và mở lại PowerShell.
3. Kiểm tra:

```powershell
git --version
```

Các lựa chọn mặc định của trình cài Git phù hợp với hầu hết người mới.

### 3. Cài Flutter và Dart trong VS Code

Tài liệu chính thức:
[Install Flutter using VS Code](https://docs.flutter.dev/install/with-vs-code).

1. Mở VS Code.
2. Nhấn `Ctrl+Shift+X` để mở **Extensions**.
3. Tìm `Flutter` do **Dart Code** phát hành và chọn **Install**. Extension Flutter
   sẽ cài thêm extension Dart.
4. Nhấn `Ctrl+Shift+P`, nhập `Flutter: New Project`.
5. Nếu VS Code báo chưa tìm thấy Flutter SDK, chọn **Download SDK**.
6. Chọn một thư mục đơn giản, ví dụ `C:\src\flutter`. Tránh đặt Flutter trong
   `C:\Program Files` vì đường dẫn có khoảng trắng và thường cần quyền quản trị.
7. Chọn **Add SDK to PATH** khi VS Code đề nghị.
8. Đóng toàn bộ terminal và khởi động lại VS Code.
9. Kiểm tra trong PowerShell:

```powershell
flutter --version
dart --version
```

Nếu đã tải Flutter thủ công, thêm thư mục `<FLUTTER_SDK>\bin` vào biến môi
trường `Path`, sau đó mở lại terminal. Không cần cài Dart riêng vì Flutter SDK
đã bao gồm Dart.

### 4. Cài Android Studio và Android SDK

VS Code dùng để viết mã, còn Android Studio cung cấp Android SDK, ADB, JDK và
các công cụ build cần thiết.

1. Tải bản stable từ
   [Android Studio](https://developer.android.com/studio/install).
2. Trên Windows nên dùng tệp `.exe`, chạy trình cài đặt và hoàn tất Setup
   Wizard.
3. Mở Android Studio.
4. Từ màn hình chào chọn **More Actions > SDK Manager**. Nếu đang mở một dự án,
   chọn **Tools > SDK Manager**.
5. Trong **SDK Platforms**, cài Android SDK Platform mà Flutter stable hiện yêu
   cầu. Dự án này đã được kiểm tra với API 36.
6. Trong **SDK Tools**, bảo đảm có các thành phần sau:

   - Android SDK Build-Tools
   - Android SDK Command-line Tools (latest)
   - Android SDK Platform-Tools
   - Android Emulator nếu muốn chạy máy ảo
   - CMake và NDK (Side by side) theo khuyến nghị của Flutter

7. Chọn **Apply**, chấp nhận giấy phép và đợi tải xong.

Không cần cài Visual Studio Community nếu bạn chỉ build Android. Visual Studio
Community là công cụ dành cho target Windows desktop, trong khi dự án này hiện
chỉ có target Android.

### 5. Chấp nhận giấy phép Android và kiểm tra môi trường

Mở PowerShell mới rồi chạy:

```powershell
flutter doctor --android-licenses
```

Đọc từng giấy phép và nhập `y` để chấp nhận khi phù hợp. Sau đó chạy:

```powershell
flutter doctor -v
```

Các mục quan trọng cho dự án này là:

- Flutter: dấu kiểm màu xanh.
- Android toolchain: dấu kiểm màu xanh.
- Android Studio: được nhận diện.
- VS Code: được nhận diện.

Nếu `flutter doctor` cảnh báo về Visual Studio nhưng các mục Flutter và Android
đều tốt, có thể bỏ qua cảnh báo đó vì Deep Widget không build Windows desktop.

## Cài Codex trong VS Code

Codex là công cụ hỗ trợ lập trình tùy chọn. Codex **không phải dependency của
Deep Widget** và không cần thiết để build hoặc sử dụng ứng dụng. Phần này dành
cho người muốn dùng AI để đọc mã nguồn, sửa lỗi hoặc phát triển tính năng.

Tài liệu OpenAI chính thức:
[Codex IDE extension](https://learn.chatgpt.com/docs/codex/ide).

### Cài extension chính thức

1. Mở VS Code và nhấn `Ctrl+Shift+X`.
2. Tìm **Codex – OpenAI's coding agent**.
3. Kiểm tra publisher là **OpenAI**. ID extension hiện là `OpenAI.chatgpt`.
4. Chọn **Install**.

Có thể cài bằng terminal:

```powershell
code --install-extension OpenAI.chatgpt
```

Không cài extension có tên gần giống nếu publisher không phải OpenAI. Liên kết
Marketplace chính thức được dẫn từ
[tài liệu Codex của OpenAI](https://developers.openai.com/codex/ide).

### Đăng nhập

1. Chọn Codex ở thanh bên VS Code.
2. Nếu không thấy, nhấn `Ctrl+Shift+P` và chạy
   `Codex: Open Codex Sidebar`.
3. Chọn **Sign in/Đăng nhập**.
4. Trình duyệt sẽ mở luồng xác thực. Đăng nhập bằng tài khoản ChatGPT được phép
   dùng Codex trong gói cá nhân hoặc workspace của bạn.
5. Chấp nhận yêu cầu xác thực rồi quay lại VS Code.
6. Mở thư mục dự án và bắt đầu một cuộc trò chuyện.

Quyền truy cập, model và giới hạn sử dụng có thể khác nhau theo gói ChatGPT hoặc
chính sách workspace. Không ghi mật khẩu, mã đăng nhập, API key hoặc token vào
README, source code, issue hay commit Git.

Ví dụ yêu cầu phù hợp cho người mới:

```text
Hãy giải thích cấu trúc dự án Deep Widget trước khi sửa mã.
```

```text
Hãy chạy flutter analyze và flutter test, giải thích lỗi rồi mới đề xuất sửa.
```

```text
Hãy thêm tính năng này, giữ toàn bộ màu trong deep_widget_colors.dart,
sau đó chạy test và build debug trên thiết bị Android USB.
```

Luôn xem diff, đọc các lệnh Codex muốn chạy và tạo commit Git trước thay đổi
lớn để có thể quay lại trạng thái ổn định.

## Tải và mở mã nguồn

### Cách 1: Clone bằng Git

Sau khi dự án được đưa lên GitHub hoặc Git server công khai, sao chép URL của
kho mã nguồn rồi chạy:

```powershell
cd C:\Data_user
git clone <REPOSITORY_URL> deepwidget
cd deepwidget
code .
```

Thay `<REPOSITORY_URL>` bằng URL thật của dự án. Lệnh `code .` phải được chạy
tại thư mục chứa `pubspec.yaml`.

### Cách 2: Tải ZIP

1. Trên trang kho mã nguồn chọn **Code > Download ZIP**.
2. Giải nén vào một đường dẫn ngắn, không chứa ký tự lạ, ví dụ
   `C:\Data_user\deepwidget`.
3. Trong VS Code chọn **File > Open Folder**.
4. Chọn thư mục `deepwidget`, không chỉ mở riêng tệp `README.md`.
5. Nếu VS Code hỏi Workspace Trust, chỉ chọn tin cậy nếu mã nguồn đến từ kho
   chính thức mà bạn đã kiểm tra.

## Cài thư viện và kiểm tra dự án

Mở **Terminal > New Terminal** trong VS Code. Kiểm tra terminal đang đứng ở thư
mục chứa `pubspec.yaml`, sau đó chạy lần lượt:

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Ý nghĩa:

- `flutter pub get`: tải package được khai báo trong `pubspec.yaml`.
- `dart format`: kiểm tra định dạng mã Dart.
- `flutter analyze`: phát hiện lỗi kiểu dữ liệu và vi phạm lint.
- `flutter test`: chạy bộ test tự động.

Các dependency chính:

| Package | Vai trò |
| --- | --- |
| `home_widget` | Giao tiếp giữa Flutter và widget Android native |
| `image_picker` | Chọn ảnh bằng bộ chọn ảnh của hệ thống |
| `flutter_riverpod` | Quản lý trạng thái màn hình chỉnh widget |
| `path` | Xử lý tên và đường dẫn tệp |

Không sửa tay nội dung `.dart_tool`, `build` hoặc Pub Cache. Đây là các thư mục
được công cụ tạo tự động.

## Kết nối điện thoại Android qua USB

### 1. Bật Developer options

Trên phần lớn điện thoại:

1. Mở **Settings/Cài đặt > About phone/Giới thiệu điện thoại**.
2. Tìm **Build number/Số hiệu bản tạo**.
3. Nhấn liên tục 7 lần và nhập mã khóa màn hình nếu được yêu cầu.

Trên Samsung thường là:

`Cài đặt > Thông tin điện thoại > Thông tin phần mềm > Số hiệu bản tạo`.

### 2. Bật USB debugging

1. Quay lại Settings.
2. Mở **Developer options/Tùy chọn nhà phát triển**.
3. Bật **USB debugging/Gỡ lỗi USB**.
4. Kết nối điện thoại với máy tính bằng cáp dữ liệu.
5. Chọn chế độ USB **File transfer/Truyền tệp (MTP)** thay vì chỉ sạc.
6. Khi điện thoại hỏi cho phép gỡ lỗi USB cho máy tính này, kiểm tra dấu vân tay
   RSA rồi chọn **Allow/Cho phép**.

Tham khảo:
[Configure on-device developer options](https://developer.android.com/studio/debug/dev-options).

### 3. Kiểm tra thiết bị

Trong PowerShell:

```powershell
flutter devices
```

Hoặc kiểm tra trực tiếp bằng ADB:

```powershell
adb devices -l
```

Một thiết bị sẵn sàng sẽ có trạng thái `device`, ví dụ:

```text
<DEVICE_SERIAL>    device product:... model:<DEVICE_MODEL> ...
```

Các trạng thái khác:

- `unauthorized`: mở khóa điện thoại và chấp nhận hộp thoại RSA.
- `offline`: rút/cắm lại cáp rồi khởi động lại ADB.
- danh sách trống: đổi cáp/cổng USB, chọn File transfer và cài USB driver của
  hãng điện thoại nếu Windows chưa nhận thiết bị.

Làm mới ADB:

```powershell
adb kill-server
adb start-server
adb devices -l
```

Nếu lệnh `adb` không có trong `PATH`, vẫn có thể dùng `flutter devices`; hoặc
chạy `adb.exe` trong thư mục Android SDK `platform-tools`. Android Studio có
**Tools > Troubleshoot Device Connections** để hỗ trợ kiểm tra kết nối.

## Chạy debug

### Chạy bằng VS Code

1. Mở đúng thư mục chứa `pubspec.yaml`.
2. Nhìn thanh trạng thái dưới cùng và chọn thiết bị Android. Nếu thấy
   **No Devices**, quay lại phần kết nối USB.
3. Nhấn `F5` hoặc chọn **Run > Start Debugging**.
4. Lần chạy đầu có thể mất vài phút vì Gradle cần tải dependency và build APK.
5. Khi ứng dụng hiện trên điện thoại và thanh trạng thái VS Code đổi màu, phiên
   debug đã được kết nối.

### Chạy bằng terminal

Liệt kê thiết bị:

```powershell
flutter devices
```

Nếu chỉ có một thiết bị Android:

```powershell
flutter run --debug
```

Nếu có nhiều thiết bị, dùng ID hiển thị bởi `flutter devices`:

```powershell
flutter run -d <DEVICE_ID> --debug
```

Trong terminal của `flutter run`:

- Nhấn `r` để hot reload.
- Nhấn `R` để hot restart.
- Nhấn `q` để dừng phiên debug.

Debug mode dùng cho phát triển và hỗ trợ hot reload; không dùng APK debug để
phát hành cho người dùng cuối.

## Tự động hot reload sau khi lưu

Hot reload chỉ hoạt động khi ứng dụng đang chạy ở debug mode. Trong VS Code:

1. Nhấn `Ctrl+,` để mở Settings.
2. Tìm `Flutter Hot Reload On Save`.
3. Chọn `allIfDirty` để reload khi tệp có thay đổi được lưu.

Hoặc mở **Preferences: Open User Settings (JSON)** và thêm:

```json
{
  "dart.flutterHotReloadOnSave": "allIfDirty",
  "[dart]": {
    "editor.formatOnSave": true
  }
}
```

Sau đó nhấn `F5` một lần để bắt đầu debug. Mỗi lần lưu tệp Dart có thay đổi,
Flutter extension sẽ tự gửi hot reload nếu mã không có lỗi biên dịch.

Một số thay đổi không thể hot reload, ví dụ sửa Kotlin/Java, Android Manifest,
Gradle, resource XML, dependency hoặc mã khởi tạo native. Khi đó hãy dừng phiên
debug và chạy lại `F5`, hoặc dùng hot restart nếu thay đổi chỉ liên quan Dart.

## Cách sử dụng Deep Widget

### Chọn ảnh và chỉnh bo góc

1. Mở Deep Widget.
2. Lần chạy đầu hiển thị trạng thái **Chưa có ảnh**; ứng dụng không kèm ảnh mẫu.
3. Chọn **Chọn ảnh từ bộ sưu tập**.
4. Chọn PNG, JPG hoặc WebP.
5. Quan sát vùng caro trong phần xem trước. Đây là vùng trong suốt.
6. Kéo thanh **Bo góc widget**:

   - `0%`: góc vuông.
   - `50%`: bo tròn tối đa.

7. Khi thả thanh trượt, ứng dụng lưu giá trị và cập nhật widget đang có.

Để có kết quả xuyên nền đẹp nhất, dùng PNG đã tách nền thật sự. Deep Widget giữ
alpha sẵn có nhưng không phải công cụ AI xóa nền.

### Thêm widget từ trong ứng dụng

1. Chọn **Thêm vào màn hình chính**.
2. Xác nhận hộp thoại của launcher.
3. Quay về màn hình chính.
4. Nhấn giữ widget và kéo các cạnh để đổi kích thước nếu launcher hỗ trợ.

### Thêm widget thủ công

Nếu không có hộp thoại ghim nhanh:

1. Nhấn giữ vùng trống trên màn hình chính.
2. Chọn **Widgets/Tiện ích**.
3. Tìm **Deep Widget**.
4. Nhấn giữ mẫu widget rồi kéo ra màn hình chính, hoặc chọn **Add/Thêm**.

### Thay ảnh sau khi đã ghim

Mở lại ứng dụng, chọn ảnh mới hoặc chỉnh bo góc. Tất cả Deep Widget đang ghim sẽ
dùng ảnh và mức bo góc mới. Nếu launcher chưa vẽ lại ngay, trở về màn hình chính
hoặc xóa rồi thêm lại widget.

## Build và cài APK

Trước mọi bản build nên chạy:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

### APK debug

```powershell
flutter build apk --debug
```

Tệp kết quả:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Cài và chạy trực tiếp lên thiết bị:

```powershell
flutter run -d <DEVICE_ID> --debug
```

### APK release

```powershell
flutter build apk --release
```

Tệp kết quả:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Cài bản release lên điện thoại USB:

```powershell
flutter install -d <DEVICE_ID> --release
```

Hoặc cài đúng APK đã build:

```powershell
flutter install -d <DEVICE_ID> --use-application-binary=build/app/outputs/flutter-apk/app-release.apk
```

> Lệnh build release chỉ chạy sau khi đã cấu hình `android/key.properties` với
> khóa riêng. Không đưa tệp khóa hoặc mật khẩu vào kho mã nguồn.

### APK nhỏ hơn theo kiến trúc CPU

```powershell
flutter build apk --release --split-per-abi
```

Flutter tạo APK riêng cho ARM 32-bit, ARM 64-bit và x86-64. Hầu hết điện thoại
Android hiện đại dùng `arm64-v8a`.

### App Bundle cho Google Play

Sau khi cấu hình ký release chính thức:

```powershell
flutter build appbundle --release
```

Kết quả:

```text
build/app/outputs/bundle/release/app-release.aab
```

Google Play ưu tiên AAB. Không thể chạm trực tiếp vào tệp AAB để cài như APK.

## Tạo bản phát hành chính thức

Đọc tài liệu Flutter chính thức trước khi thực hiện:
[Build and release an Android app](https://docs.flutter.dev/deployment/android).

### 1. Tăng phiên bản

Trong `pubspec.yaml`:

```yaml
version: 1.0.2+3
```

- `1.0.2` là `versionName` người dùng nhìn thấy.
- `3` là `versionCode`; mỗi bản đưa lên Google Play phải có số lớn hơn bản
  trước.

### 2. Tạo upload keystore

Tìm đường dẫn Java bằng `flutter doctor -v`, rồi dùng `keytool` thuộc JDK đó.
Ví dụ trên Windows:

```powershell
keytool -genkey -v `
  -keystore "$env:USERPROFILE\upload-keystore.jks" `
  -storetype JKS `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias upload
```

Lưu keystore và mật khẩu trong trình quản lý mật khẩu an toàn. Mất khóa có thể
ảnh hưởng khả năng phát hành bản cập nhật ngoài cơ chế Play App Signing.

### 3. Tạo file cấu hình khóa

Với máy maintainer, vị trí được khuyến nghị là
`C:\Users\TEN_CUA_BAN\.deepwidget\key.properties`. Vị trí này nằm ngoài kho mã
nguồn. Dự án cũng chấp nhận `android/key.properties` để tương thích với quy trình
Flutter thông thường.

```properties
storePassword=MAT_KHAU_KEYSTORE
keyPassword=MAT_KHAU_KEY
keyAlias=upload
storeFile=C:\\Users\\TEN_CUA_BAN\\upload-keystore.jks
```

Trên Windows, đường dẫn trong `key.properties` dùng dấu `\\` kép.

Không commit các tệp sau lên Git:

- `android/key.properties`
- `*.jks`
- `*.keystore`
- mật khẩu hoặc token

Các pattern này đã có trong `.gitignore` của dự án, nhưng vẫn phải kiểm tra
`git status` trước khi push.

### 4. Gradle dùng khóa release

Tệp `android/app/build.gradle.kts` ưu tiên đọc `android/key.properties`, sau đó
đọc `~/.deepwidget/key.properties`, tạo `signingConfigs.release` và từ chối build
release khi thiếu khóa. Không đổi về
`signingConfigs.getByName("debug")`: khóa debug là khóa phát triển phổ biến và
không đủ an toàn để ký bản phân phối cho cộng đồng.

Sau khi đổi cấu hình ký:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

### 5. Kiểm tra trước khi công bố

- Cài bản release trên ít nhất một thiết bị thật.
- Kiểm tra chọn PNG có alpha, bo góc, ghim widget và resize.
- Kiểm tra cài đè từ bản phát hành trước để xác nhận chữ ký không đổi.
- Kiểm tra `versionCode` đã tăng.
- Lưu SHA-256 của APK/AAB và đưa checksum vào Release notes.
- Không đưa keystore, `key.properties`, mật khẩu hoặc dữ liệu người dùng vào
  release artifact.
- Với Google Play, bật Play App Signing và tải AAB bằng tài khoản maintainer.

## Cấu trúc mã nguồn

```text
lib/
├── app/
│   └── app.dart
├── core/
│   ├── theme/
│   │   ├── deep_widget_colors.dart
│   │   └── deep_widget_theme.dart
│   └── widgets/
└── features/widget_creator/
    ├── data/
    ├── domain/
    └── presentation/
```

`lib/core/theme/deep_widget_colors.dart` là nguồn màu Flutter duy nhất. Test tự
động không cho khai báo raw `Color(...)` hoặc `Colors.*` ở file Dart khác. Khi
thêm màu, hãy thêm token vào file màu chung rồi sử dụng token đó trong UI.

Widget màn hình chính nằm ở lớp Android native:

```text
android/app/src/main/
├── kotlin/com/odeepart/deepwidget/
│   └── DeepImageWidgetProvider.kt
└── res/
    ├── layout/deep_image_widget.xml
    └── xml/deep_image_widget_info.xml
```

Root và `ImageView` của widget trong suốt. Provider giới hạn kích thước bitmap
trước khi gửi qua `RemoteViews` để giảm nguy cơ lỗi bộ nhớ, sau đó tạo góc bo
với pixel alpha trong suốt.

### Luồng dữ liệu chính

```text
Chọn ảnh trong Android Photo Picker
        ↓
Flutter chuẩn hóa và lưu PNG cục bộ
        ↓
HomeWidget lưu đường dẫn và mức bo góc
        ↓
DeepImageWidgetProvider đọc dữ liệu
        ↓
RemoteViews cập nhật widget màn hình chính
```

## Đưa mã nguồn lên GitHub

Dự án đã có `.gitignore`, `.gitattributes`, MIT License, chính sách bảo mật,
hướng dẫn đóng góp, mẫu Issue/Pull Request và GitHub Actions. Không tải nguyên
thư mục bằng cách kéo thả vì cách đó có thể đưa build cache và đường dẫn máy cá
nhân lên mạng; hãy commit bằng Git để các quy tắc ignore được áp dụng.

### Tạo repository công khai lần đầu

1. Trên GitHub, tạo repository trống tên `deepwidget`. Không chọn tạo thêm
   README, `.gitignore` hoặc License vì dự án đã có sẵn.
2. Tại thư mục dự án, kiểm tra chính xác các tệp chuẩn bị commit:

```powershell
git status --short
git diff --cached --name-only
```

3. Danh sách stage không được chứa `build`, `.dart_tool`, `.idea`,
   `android/local.properties`, APK/AAB, `key.properties`, `.p12`, `.jks`, `.env`
   hoặc ảnh cá nhân.
4. Tạo commit và kết nối repository GitHub:

```powershell
git commit -m "Initial open-source release"
git remote add origin https://github.com/<GITHUB_USERNAME>/deepwidget.git
git push -u origin main
```

Thay `<GITHUB_USERNAME>` bằng tài khoản thật. Git sẽ dùng danh tính commit đang
cấu hình trên máy; hãy kiểm tra `git config user.name` và `git config user.email`
trước khi commit nếu không muốn công khai email cá nhân.

### Thiết lập khuyến nghị trên GitHub

- Bật **Settings > Security > Secret scanning** và **Push protection**.
- Tạo ruleset cho nhánh `main`, yêu cầu Pull Request và workflow **Flutter CI**
  vượt qua trước khi merge.
- Đưa APK/AAB vào **GitHub Releases**, không commit chúng vào lịch sử Git.
- Giữ khóa chính thức ở `%USERPROFILE%\.deepwidget` hoặc kho bí mật riêng; không
  tải thư mục khóa lên GitHub và không đưa khóa vào GitHub Actions.
- Tiếp nhận lỗ hổng qua hướng dẫn trong [SECURITY.md](SECURITY.md).

## Đóng góp cho dự án

Đọc [CONTRIBUTING.md](CONTRIBUTING.md) trước khi bắt đầu. Mọi đóng góp nên nhỏ,
dễ xem xét và kèm kiểm tra phù hợp.

### Quy trình đề xuất

1. Fork kho mã nguồn.
2. Clone fork về máy.
3. Tạo nhánh theo mục đích:

```powershell
git switch -c feature/ten-tinh-nang
```

4. Sửa mã và thêm/cập nhật test.
5. Chạy kiểm tra:

```powershell
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
```

6. Kiểm tra trên thiết bị Android thật nếu thay đổi liên quan widget, ảnh hoặc
   mã native.
7. Xem các file thay đổi:

```powershell
git status
git diff
```

8. Commit với mô tả rõ ràng rồi mở Pull Request.

### Quy ước quan trọng

- Không hard-code màu ngoài `deep_widget_colors.dart`.
- Không đưa secret, keystore, ảnh cá nhân hoặc đường dẫn máy cá nhân vào commit.
- Không commit thư mục `build`, `.dart_tool` hoặc file IDE cá nhân.
- Giữ PNG alpha; không chuyển ảnh widget sang JPEG.
- Thay đổi native widget phải kiểm tra trên launcher thật, không chỉ dựa vào
  widget test Flutter.
- PR sửa lỗi nên mô tả cách tái hiện lỗi, kết quả mong đợi và thiết bị/Android
  đã kiểm tra.

## Xử lý lỗi thường gặp

### `flutter` is not recognized

- Kiểm tra Flutter SDK đã được tải.
- Thêm `<FLUTTER_SDK>\bin` vào `Path`.
- Đóng toàn bộ PowerShell và VS Code rồi mở lại.
- Chạy `flutter --version` và `flutter doctor -v`.

### `cmdline-tools component is missing`

Mở Android Studio > **Tools > SDK Manager > SDK Tools**, cài **Android SDK
Command-line Tools (latest)** rồi chạy lại:

```powershell
flutter doctor --android-licenses
flutter doctor -v
```

### `flutter devices` không thấy điện thoại

- Mở khóa điện thoại.
- Bật USB debugging.
- Chọn USB File transfer/MTP.
- Chấp nhận hộp thoại RSA.
- Đổi cáp hoặc cổng USB.
- Cài USB driver của hãng điện thoại trên Windows.
- Chạy lại ADB hoặc dùng Android Studio Connection Assistant.

### Thiết bị có trạng thái `unauthorized`

Trên điện thoại, vào Developer options và chọn **Revoke USB debugging
authorizations**, sau đó rút/cắm lại cáp và chấp nhận hộp thoại RSA mới.

### Build Gradle thất bại lần đầu

Lần đầu Gradle cần tải nhiều tệp. Kiểm tra mạng rồi thử:

```powershell
flutter clean
flutter pub get
flutter run -d <DEVICE_ID> --debug
```

Nếu vẫn lỗi, dùng `flutter doctor -v` và đọc dòng lỗi đầu tiên thay vì chỉ dòng
`BUILD FAILED` cuối cùng.

### Ứng dụng cài được nhưng không thấy trong danh sách widget

- Mở ứng dụng ít nhất một lần.
- Khởi động lại launcher hoặc điện thoại.
- Xóa bản cũ và cài lại đúng APK nếu đang đổi giữa các chữ ký phát hành.
- Nhấn giữ màn hình chính > Widgets và tìm theo tên `Deep Widget`.

### Widget không cập nhật ảnh hoặc bo góc

- Mở lại Deep Widget và thay đổi giá trị một lần nữa.
- Trở về màn hình chính để launcher vẽ lại.
- Xóa widget cũ và thêm lại nếu launcher giữ cache quá lâu.
- Đảm bảo ứng dụng chưa bị công cụ tiết kiệm pin của hãng đóng băng hoàn toàn.

### PNG vẫn có nền trắng

Mở ảnh bằng trình chỉnh sửa có hiển thị lưới caro. Nếu vùng cần xuyên nền là màu
trắng cố định thay vì alpha, hãy tách nền và xuất lại PNG RGBA. Deep Widget
không tự suy đoán và xóa màu nền.

## Quyền riêng tư và giới hạn hiện tại

- Bản cài mới không chứa ảnh demo. Bản 1.0.2 cũng tự xóa ảnh mẫu do phiên bản cũ
  từng cài, nhưng giữ nguyên ảnh do người dùng tự chọn.
- Ảnh được lưu cục bộ trong vùng dữ liệu của ứng dụng.
- Ứng dụng dùng bộ chọn ảnh của hệ thống, không yêu cầu quét toàn bộ thư viện.
- Dự án hiện không có tính năng upload ảnh hay tài khoản người dùng.
- Manifest không cấp quyền Internet hoặc quyền đọc toàn bộ kho ảnh.
- Sao lưu và chuyển dữ liệu ứng dụng bị vô hiệu hóa để PNG riêng tư không đi vào
  bản sao lưu đám mây hoặc luồng chuyển thiết bị.
- Widget receiver không được export cho ứng dụng bên thứ ba và lưu lượng mạng
  HTTP không mã hóa bị chặn ở cấp Android.
- Gỡ ứng dụng sẽ xóa dữ liệu và ảnh widget đã lưu.
- Widget cần ứng dụng còn được cài để đọc dữ liệu và tiếp tục cập nhật.
- Windows desktop không được `home_widget` hỗ trợ cho loại widget màn hình chính
  này.
- iOS cần WidgetKit extension và App Group riêng; iOS cũng không cho ứng dụng tự
  ghim widget theo cách Android đang dùng.

## Giấy phép mã nguồn mở

Mã nguồn Deep Widget và các tài sản do dự án tự tạo được phát hành theo
[MIT License](LICENSE). Cộng đồng được phép sử dụng, sao chép, sửa đổi, hợp
nhất, công bố, phân phối, cấp phép lại và bán bản sao theo các điều kiện trong
file giấy phép.

Thư viện, font, nhãn hiệu và tài sản của bên thứ ba vẫn tuân theo giấy phép và
quyền sở hữu tương ứng; MIT License của Deep Widget không cấp lại quyền cho các
thành phần đó.

## Tài liệu chính thức tham khảo

- [Cài VS Code trên Windows](https://code.visualstudio.com/docs/setup/windows)
- [Cài Flutter bằng VS Code](https://docs.flutter.dev/install/with-vs-code)
- [Thiết lập Flutter cho Android](https://docs.flutter.dev/platform-integration/android/setup)
- [Flutter trong VS Code](https://docs.flutter.dev/tools/vs-code)
- [Cài Android Studio](https://developer.android.com/studio/install)
- [Chạy trên thiết bị Android thật](https://developer.android.com/studio/run/device)
- [Bật Developer options và USB debugging](https://developer.android.com/studio/debug/dev-options)
- [Build và ký ứng dụng Android](https://docs.flutter.dev/deployment/android)
- [Codex IDE extension của OpenAI](https://learn.chatgpt.com/docs/codex/ide)
