Instrukcja Uruchomienia github actions
git add .github/workflows/ci-docker.yml
git commit -m "update1?"
git push origin main

Odp.
Wybór wersjonowanego cache'u dedykowanego dla konkretnej gałęzi (per-branch cache) wynika z oficjalnych dobrych praktyk optymalizacji Docker Buildx oraz GitHub Actions.
Izolacja pamięci podręcznej per-branch zapobiega problemowi nadpisywania (cache cache-pollution) oraz tzw. "mieszaniu się" warstw między niezależnymi funkcjonalnościami (feature branchami). Zastosowanie trybu mode=max gwarantuje, że eksportowane są metadane wszystkich warstw. Pozwala to  skrócić czas wykonywania procesu w gałęzi.

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
