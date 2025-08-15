# Legion

```bash
mkdir build-docker

docker build --target linux-build -t flutter-linux .
docker run --rm -e TARGETS=linux,android -v "$PWD/build-docker":/opt/legion/build flutter-linux

# Нужен Windows
docker build --target windows-build -t flutter-windows Dockerfile-windows
docker run --rm -v ./build-docker:C:\legion\build flutter-windows
```