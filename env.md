# RecallDeck

Scaffold Flutter untuk Android dan Web. Tahap awal memakai aplikasi counter bawaan
Flutter dengan nama RecallDeck; fitur produk belum dibuat.

## Prasyarat

- Linux `x86_64` dengan Nix, fitur `nix-command` dan `flakes` aktif.
- Git, direnv, dan nix-direnv **3.2.0 atau lebih baru** untuk aktivasi otomatis.
- Browser untuk menjalankan versi Web. Brave dapat dipakai melalui `web-server`.

Android Studio, Android SDK, dan Java **belum diperlukan** untuk alur Web.
Flutter dan Dart disediakan oleh Nix; jangan memasang Dart terpisah atau memakai
`flutter upgrade`. Versi toolchain mengikuti `flake.lock`.

## Mulai

```sh
nix develop
flutter pub get
web
```

Buka alamat localhost yang dicetak Flutter di browser. Gunakan tombol **+** untuk
menguji counter, lalu tekan `q` di terminal untuk menghentikan server. Server hanya
mendengarkan `127.0.0.1`. Argumen tambahan diteruskan, misalnya
`web --web-port 8080`. Mode `web-server` memerlukan membuka browser sendiri dan
memiliki dukungan debugging yang lebih terbatas dibanding perangkat Chrome.

Untuk tetap menggunakan Fish secara interaktif:

```fish
nix develop --command fish
```

### Aktivasi otomatis dengan direnv

Jika direnv dan nix-direnv sudah terpasang dan hook Fish sudah aktif, cukup:

```fish
direnv allow
flutter pub get
web
```

Jika belum, pasang direnv melalui pengelola paket host dan nix-direnv melalui Nix:

```sh
nix profile install nixpkgs#nix-direnv
```

Tambahkan baris berikut ke `~/.config/direnv/direnvrc`:

```sh
source "$HOME/.nix-profile/share/nix-direnv/direnvrc"
```

Untuk Fish, tambahkan ke `~/.config/fish/config.fish`:

```fish
direnv hook fish | source
```

Jangan menggandakan konfigurasi yang sudah ada. `.envrc` memeriksa nix-direnv,
memantau modul dalam `nix/`, lalu memuat `use flake`. nix-direnv menyimpan cache
environment; keluar dari direktori mengembalikan environment shell sebelumnya.
Setelah mengubah `.envrc`, jalankan `direnv allow` kembali. `nix develop` tetap bisa
dipakai tanpa direnv.

## Perintah harian

| Perintah                    | Fungsi                                               |
| --------------------------- | ---------------------------------------------------- |
| `menu`                      | Menampilkan perintah devshell                        |
| `fmt` / `nix fmt`           | Memformat file sumber dengan treefmt                 |
| `check` / `nix flake check` | Memeriksa format dan Git hooks di sandbox Nix        |
| `doctor`                    | Menampilkan versi Flutter/Dart dan diagnosis Flutter |
| `web`                       | Menjalankan Flutter Web melalui localhost            |
| `flutter analyze`           | Analisis statis aplikasi                             |
| `flutter test`              | Menjalankan widget test counter                      |
| `flutter build web`         | Menghasilkan aplikasi Web di `build/web/`            |

`doctor` bersifat informasional untuk diagnosis platform yang belum disiapkan.
Peringatan Android Studio, Android SDK, Chrome, atau Linux desktop tidak berarti
alur Web melalui `web-server` gagal. Jangan menjadikan seluruh hasil
`flutter doctor` sebagai syarat lulus tahap awal.

## Formatter dan Git hooks

`nix/treefmt.nix` menjadi sumber konfigurasi format tunggal: nixfmt untuk Nix,
Dart bawaan Flutter untuk Dart, Prettier untuk Markdown/YAML/JSON, dan shfmt untuk
skrip Bash termasuk `.envrc`. Cache, build, lockfile, serta kode hasil generator
dikecualikan.

`nix/hooks.nix` mengaktifkan treefmt dan pemeriksaan konflik merge. Hooks dipasang
saat environment dimuat di repo Git melalui `nix develop` atau direnv. Konfigurasi
`.pre-commit-config.yaml` dihasilkan otomatis dan tidak disimpan di Git.

```sh
pre-commit run --all-files
```

Jika formatter memperbaiki file ketika commit, tinjau hasilnya, stage ulang, lalu
ulangi commit. Analyze dan test tidak berjalan otomatis saat commit. Untuk
pemeriksaan format tanpa mengubah file:

```sh
treefmt --fail-on-change
```

`nix flake check` hanya menjalankan pemeriksaan yang dapat bekerja dalam sandbox.
Pengambilan dependensi Pub, analyze, test, dan build Web dijalankan terpisah dalam
devshell, dengan cache yang dapat ditulis dan akses jaringan bila diperlukan.

Flakes dalam repo Git hanya melihat file yang dikenali Git. Setelah menambahkan
file konfigurasi atau sumber baru, stage file tersebut sebelum pemeriksaan Nix:

```sh
git add .
nix flake check
```

## Pembaruan dependensi

```sh
nix flake update
nix develop
flutter pub get
nix fmt
nix flake check
flutter analyze
flutter test
flutter build web
```

Tinjau perubahan `flake.lock` dan uji kembali aplikasi di browser. Flutter dan Dart
selalu diperbarui bersama melalui nixpkgs. Untuk memperbarui paket aplikasi,
jalankan `flutter pub upgrade`, tinjau perubahan, dan simpan `pubspec.lock`.

## Android: tahap berikutnya

Scaffold Android menggunakan Kotlin dengan application ID sementara
`com.example.recalldeck` dan nama tampilan **RecallDeck**. Instalasi Android Studio,
SDK, Java/JBR, serta emulator dikelola sendiri di host. Environment Nix tidak
memasang atau mengatur komponen tersebut dan tidak mengubah konfigurasi global
Flutter, Fish, maupun Android Studio.

Setelah Android Studio disiapkan, tentukan lokasi SDK dan JBR serta samakan Java
yang digunakan terminal dan Gradle di IDE. Pemilihan SDK/NDK/CMake dan emulator,
`flutter doctor` untuk Android, serta build APK akan diverifikasi pada tahap itu.

## Referensi

- [devshell](https://github.com/numtide/devshell)
- [nix-direnv](https://github.com/nix-community/nix-direnv)
- [treefmt-nix](https://github.com/numtide/treefmt-nix)
- [git-hooks.nix](https://github.com/cachix/git-hooks.nix)
- [Flutter Web](https://docs.flutter.dev/platform-integration/web/building)
