# Digital wellbeing database - projekt semestralny na Bazy danych autorstwa Mai Zontek i Julii Estkowskiej

Projekt semestralny z przedmiotu Bazy Danych. Przedmiotem projektu jest w pełni funkcjonalna, relacyjna baza danych zaprojektowana dla aplikacji badawczej, która analizuje wpływ korzystania z mediów społecznościowych na zdrowie psychiczne, jakość snu oraz styl życia użytkowników.

## Autorzy
* **Maja Zontek**
* **Julia Estkowska** *(Modelowanie Matematyczne i Analiza Danych, MFI UG)*

---

## Założenia Projektowe
Projekt ściśle realizuje wymagania akademickie dla zaawansowanych systemów bazodanowych:
* **8 tabel** z relacjami (Klucze Główne i Obce).
* Pełna zgodność z **3. Postacią Normalną (3NF)** – brak redundancji danych (m.in. poprzez wykorzystanie tabel słownikowych oraz widoków do wyliczania sum).
* Zaawansowane więzy integralności zapobiegające wprowadzaniu niespójnych i "bezsensownych" danych.

---

## Struktura Bazy Danych (Tabele)

### Słowniki i Tabele Bazowe:
1. `uczestnicy` - dane personalne badanych osób.
2. `platformy` - słownik zdefiniowanych aplikacji (np. Instagram, TikTok).
3. `slownik_poziomow` - słownik ujednolicający skale ocen (niski, średni, wysoki).
4. `eksperymenty` - definicje projektów badawczych z określonymi ramami czasowymi.
5. `eksperymenty_uczestnicy` - tabela łącznikowa dla relacji wiele-do-wielu (N:M).

### Logi Transakcyjne (Pomiary):
6. `pomiary_cyfrowe` - logi dotyczące dziennego użycia konkretnych aplikacji ze szczególnym uwzględnieniem czasu bezpośrednio przed snem.
7. `styl_zycia` - codzienne raporty o długości snu oraz aktywności fizycznej.
8. `zdrowie_psychiczne` - dzienne wyniki testów na poziom stresu, lęku i ryzyka depresji.

---

## Zabezpieczenia Danych (Constraints)
Aby zapewnić najwyższą spójność, baza wykorzystuje między innymi następujące reguły logiczne:
* **Blokada powieleń pomiarów (`UNIQUE`)**: Niemożliwe jest wprowadzenie dwóch pomiarów stylu życia lub ocen zdrowia dla tego samego użytkownika w tym samym dniu.
* **Logika dób (`CHECK`)**: Baza blokuje wpisy, w których zadeklarowana ilość snu i treningu przekracza fizyczne ramy 24 godzin (`godziny_snu + aktywnosc_fizyczna <= 24`).
* **Walidacja chronologii (`CHECK`)**: Eksperyment badawczy nie może zakończyć się przed swoim startem (`data_koniec >= data_start`).
* **Walidacja cyfrowa (`CHECK`)**: Zgłoszony czas przed snem dla danej aplikacji nie może przekraczać całkowitego czasu korzystania z niej w ciągu dnia (`czas_przed_snem <= czas_przed_ekranem`).
* **Sztywne skale ocen (`CHECK`)**: Wymuszono oceny stresu i lęku wyłącznie w przedziale matematycznym 0-10.

---

## Perspektywy (Views) i Funkcje
* `dzienne_podsumowanie_ekranu` **(VIEW)** – dynamicznie agreguje (przy użyciu `SUM()` i `GROUP BY`) sumaryczny czas spędzony przed ekranem przez daną osobę określonego dnia. Chroni to bazę przed trzymaniem wyliczanych wartości pochodnych (złamaniem 3NF).
* `ocena_czasu_ekranowego()` **(FUNCTION)** – funkcja w języku PL/pgSQL, która dla podanego ID uczestnika oblicza jego średni czas spędzany online i przypisuje tag tekstowy `W normie` lub `Wysokie ryzyko`.

---

## Jak uruchomić projekt?
1. Pobierz plik `digital_wellbeing.sql` z tego repozytorium.
2. Uruchom środowisko bazy danych obsługujące dialekt PostgreSQL (np. pgAdmin lub DBeaver).
3. Otwórz pobrany skrypt i wykonaj go. Skrypt zautomatyzuje proces:
   * Tworzenia struktury bazy.
   * Zakładania wszystkich tabel z relacjami.
   * Wypełniania ich gotowymi, spójnymi danymi testowymi (`INSERT INTO`).
   * Tworzenia widoków oraz funkcji analitycznych.