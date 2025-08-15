FROM debian:bookworm-slim AS linux-base

ARG ANDROID_SDK_VER=11076708
ARG ANDROID_PLATFORM=android-35
ARG ANDROID_BUILD_TOOLS=35.0.0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends curl git unzip xz-utils zip \
    ca-certificates build-essential clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev \
    libstdc++6 openjdk-17-jdk-headless libglu1-mesa \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 -b stable https://github.com/flutter/flutter.git /opt/flutter

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN flutter config --enable-linux-desktop --no-analytics \
  && flutter precache --linux

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -fsSLo /tmp/cmdtools.zip "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VER}_latest.zip" \
    && unzip -q /tmp/cmdtools.zip -d /tmp \
    && mv /tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm -f /tmp/cmdtools.zip

RUN yes | sdkmanager --licenses || true \
    && sdkmanager --update \
    && sdkmanager \
        "platform-tools" \
        "platforms;${ANDROID_PLATFORM}" \
        "build-tools;${ANDROID_BUILD_TOOLS}" \
        "cmdline-tools;latest"; \
    yes | sdkmanager --licenses || true

FROM linux-base AS linux-build

WORKDIR /opt/legion

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV PUB_CACHE=/root/.pub-cache GRADLE_USER_HOME=/root/.gradle

RUN ln -sf /opt/flutter/bin/flutter /usr/local/bin/flutter && ln -sf /opt/flutter/bin/cache/dart-sdk/bin/dart /usr/local/bin/dart

COPY . .

RUN flutter pub get || true

CMD bash -lc '\
    set -euo pipefail; \
    TARGETS="${TARGETS:-linux,android}"; \

    if [[ ",${TARGETS}," == *",linux,"* ]]; then \
        echo "==> Building Linux desktop"; \
        flutter build linux --release; \
    fi; \

    if [[ ",${TARGETS}," == *",android,"* ]]; then \
        echo "==> Building Android APK"; \
        flutter build apk --release; \
    fi; \

    echo "Linux: build/linux/x64/release/bundle/"; \
    echo "Android APK:  build/app/outputs/flutter-apk/app-release.apk"; \
'