# Legion

```bash
docker build -f Dockerfile --target linux-build -t flutter-linux .
docker run --rm -e TARGETS=linux,android -v ./out:/opt/legion/out flutter-linux

# Нужен Windows
docker build -f Dockerfile-windows --target windows-build -t flutter-windows .
docker run --rm -v .\out:C:\legion\out flutter-windows
```