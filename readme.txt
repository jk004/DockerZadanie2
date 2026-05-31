Budowanie obrazu
docker build -f Dockerfile1 -t myweather:latest .

Uruchomienie kontenera

Interaktywnie (terminal):
docker run --rm -it -e PORT=8080 --name myweather_run myweather:latest




W tle (detached) i możliwość podłączenia:
docker run -d -e PORT=8080 --name myweather_bg myweather:latest
docker attach myweather_bg

Odczyt logów wygenerowanych przy starcie

docker logs myweather_run
Dla kontenera w tle:
docker logs myweather_bg



Liczba warstw (RootFS):
docker image inspect --format='{{len .RootFS.Layers}}' myweather:latest




docker images --format '{{.Repository}}:{{.Tag}}\t{{.Size}}' | grep '^myweather:'

Rozmiar obrazu w bajtach (dokładny):
docker image inspect --format='{{.Size}}' myweather:latest
