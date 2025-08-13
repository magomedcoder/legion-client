FROM debian:bookworm-slim AS linux-base

RUN apt-get update && apt-get install -y --no-install-recommends curl git unzip xz-utils zip \
    ca-certificates build-essential clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev \
    libstdc++6 openjdk-17-jdk-headless libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b stable https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter --version && dart --version
RUN flutter config --enable-linux-desktop

ENV ANDROID_HOME=/opt/android-sdk ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -fsSLo /tmp/cmdtools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip -q /tmp/cmdtools.zip -d /tmp \
    && mv /tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm -f /tmp/cmdtools.zip

RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses || true \
    && ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --update \
    && ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-35" \
        "build-tools;35.0.0" \
        "cmdline-tools;latest"

WORKDIR /opt/legion

COPY . .

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN ln -sf /opt/flutter/bin/flutter /usr/local/bin/flutter && ln -sf /opt/flutter/bin/cache/dart-sdk/bin/dart /usr/local/bin/dart && chmod +x /opt/flutter/bin/flutter

RUN flutter pub get || true

CMD bash -lc '\
    set -euo pipefail; \
    TARGETS="${TARGETS:-linux,android}"; \
    echo "TARGETS=${TARGETS}"; \
    flutter pub get; \
    if [[ ",${TARGETS}," == *",linux,"* ]]; then \
    echo "==> Building Linux desktop"; \
    flutter build linux --release; \
    fi; \
    if [[ ",${TARGETS}," == *",android,"* ]]; then \
    echo "==> Building Android APK"; \
    flutter build apk --release; \
    fi; \
    echo ""; \
    echo "Linux: build/linux/x64/release/bundle/"; \
    echo "Android APK:  build/app/outputs/flutter-apk/app-release.apk"; \
'

# Windows

FROM mcr.microsoft.com/windows:ltsc2022

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

RUN Set-ExecutionPolicy Bypass -Scope Process; iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex

RUN choco install -y git cmake ninja python3 unzip curl 7zip

RUN Invoke-WebRequest \
    -Uri "https://aka.ms/vs/17/release/vs_buildtools.exe" \
    -OutFile "C:\\vs_buildtools.exe"; \
    Start-Process "C:\\vs_buildtools.exe" \
    -ArgumentList @("--quiet","--wait","--norestart","--nocache", \
      "--installPath","C:\\BuildTools", \
      "--add","Microsoft.Component.MSBuild", \
      "--add","Microsoft.VisualStudio.Workload.VCTools", \
      "--add","Microsoft.VisualStudio.Component.VC.Tools.x86.x64", \
      "--add","Microsoft.VisualStudio.Component.VC.CMake.Project", \
      "--add","Microsoft.VisualStudio.Component.Windows10SDK.19041", \
      "--add","Microsoft.VisualStudio.Component.Windows11SDK.22000") -Wait; \
    Remove-Item "C:\\vs_buildtools.exe" -Force

RUN git clone -b stable https://github.com/flutter/flutter.git C:\flutter

ENV PATH=C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin;%PATH%

RUN flutter --version; flutter config --enable-windows-desktop; flutter doctor -v

WORKDIR C:\legion

COPY . .

RUN flutter pub get

CMD powershell -NoProfile -Command "\
  flutter pub get; \
  Write-Host '==> Building Windows desktop'; \
  flutter build windows --release; \
  Write-Host ''; \
  Write-Host 'Windows: build\\windows\\x64\\runner\\Release\\'; \
"
