#!/bin/sh
# app.sh - prosta  aplikacja pogodowa
# Autor: Jan Kwapinski

PORT="${PORT:-8080}"
AUTHOR="Jan Kwapinski"

log_start() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") START - Autor: ${AUTHOR} - Port: ${PORT}"
}


list_cities() {
  if [ ! -f "./cities.txt" ]; then
    echo "Poland,Warsaw" > ./cities.txt
    echo "Poland,Krakow" >> ./cities.txt
    echo "USA,New York" >> ./cities.txt
    echo "UK,London" >> ./cities.txt
  fi
  nl -w2 -s". " ./cities.txt
}

choose_city() {
  echo
  echo "Wybierz numer miasta z listy:"
  read -r SELECTION
  CHOICE=$(sed -n "${SELECTION}p" ./cities.txt 2>/dev/null)
  if [ -z "$CHOICE" ]; then
    echo "Niepoprawny numer."
    return 1
  fi
  COUNTRY=$(echo "$CHOICE" | cut -d',' -f1 | sed 's/^ *//;s/ *$//')
  CITY=$(echo "$CHOICE" | cut -d',' -f2- | sed 's/^ *//;s/ *$//')
  echo "Wybrano: ${COUNTRY}, ${CITY}"
  return 0
}

fetch_weather() {
  #  wttr.in (nie wymaga klucza API)
  LOCATION=$(printf "%s" "$CITY" | sed 's/ /%20/g')
  RESPONSE=$(curl -s "https://wttr.in/${LOCATION}?format=3")
  if [ -z "$RESPONSE" ]; then
    echo "Błąd pobierania pogody."
    return 1
  fi
  echo
  echo "Aktualna pogoda dla ${CITY}:"
  echo "$RESPONSE"
  return 0
}

main_loop() {
  log_start
  while true; do
    echo
    echo "============ aplikacja pogodowa ==============="
    echo "1) Pokaż listę miast"
    echo "2) Wybierz miasto i pobierz pogodę"
    echo "3) Wyjdź"
    echo "==============================================="

    printf "Wybór: "
    read -r CH
    case "$CH" in
      1) list_cities;;
      2)
         list_cities
         choose_city || continue
         fetch_weather
         ;;
      3) echo "Koniec."; exit 0;;
      *) echo "Nieznana opcja.";;
    esac
  done
}

main_loop
