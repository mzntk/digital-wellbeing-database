CREATE DATABASE digital_wellbeing;

-------

CREATE TABLE uczestnicy (id_uczestnika INT, nazwisko VARCHAR, imie VARCHAR, username VARCHAR, wiek INT, plec VARCHAR);
ALTER TABLE uczestnicy ADD PRIMARY KEY (id_uczestnika);
ALTER TABLE uczestnicy ADD CONSTRAINT unikalny_username UNIQUE (username);
ALTER TABLE uczestnicy ADD CONSTRAINT sprawdz_plec CHECK (plec in ('K','M'));
ALTER TABLE uczestnicy ADD CONSTRAINT sprawdz_wiek CHECK (wiek >= 0);


INSERT INTO uczestnicy VALUES 
(1, 'Zontek', 'Maja', 'mzntk', 22, 'K'), 
(2, 'Estkowska', 'Julia', 'juliaest', 19, 'K'), 
(3, 'Jastrząb', 'Paweł', 'jastrzoumb', 20, 'M'), 
(4, 'Wyżynna', 'Anna', 'aniagora67', 18, 'K'), 
(5, 'Listek', 'Hubert', 'leaf123', 20, 'M'), 
(6, 'Filipowski', 'Krzysztof', 'krzysfilip', 21, 'M'),
(7, 'Wenusowska', 'Martyna', 'dzikakocica123', 20, 'K'),
(8, 'Murarz', 'Dawid', 'murarztynkarzakrobata', 21, 'M'),
(9, 'Pieczarka', 'Martyna', 'niravpavan', 19, 'K'),
(10, 'Katapulta', 'Mikołaj', 'katapultaa', 22, 'M');

-------

CREATE TABLE platformy (id_platformy INT, nazwa_platformy VARCHAR);
ALTER TABLE platformy ADD PRIMARY KEY (id_platformy);

INSERT INTO platformy VALUES 
(1, 'TikTok'),
(2, 'Instagram'),
(3, 'Facebook'),
(4, 'Youtube'),
(5, 'X'),
(6, 'Pinterest'),
(7, 'Tinder'),
(8, 'Snapchat'),
(9, 'LinkedIn');

-------

CREATE TABLE slownik_poziomow (id_poziomu INT, poziom VARCHAR);
ALTER TABLE slownik_poziomow ADD PRIMARY KEY (id_poziomu);
ALTER TABLE slownik_poziomow ADD CONSTRAINT rozne_poziomy UNIQUE (poziom);

INSERT INTO slownik_poziomow VALUES
(1, 'niski'),
(2, 'średni'),
(3, 'wysoki');

-------

CREATE TABLE pomiary_cyfrowe (id_pomiaru INT, id_uczestnika INT, id_platformy INT, data_pomiaru DATE, czas_przed_ekranem DECIMAL(4,2), czas_przed_snem DECIMAL(4,2));
ALTER TABLE pomiary_cyfrowe ADD PRIMARY KEY (id_pomiaru);
ALTER TABLE pomiary_cyfrowe ADD FOREIGN KEY (id_uczestnika) REFERENCES uczestnicy(id_uczestnika);
ALTER TABLE pomiary_cyfrowe ADD FOREIGN KEY (id_platformy) REFERENCES platformy(id_platformy); 
ALTER TABLE pomiary_cyfrowe ADD CONSTRAINT unikalny_pomiar_dzienny UNIQUE (id_uczestnika, id_platformy, data_pomiaru);
ALTER TABLE pomiary_cyfrowe ADD CONSTRAINT logiczne_czasy CHECK (czas_przed_snem <= czas_przed_ekranem);

INSERT INTO pomiary_cyfrowe VALUES 
(1, 1, 1, '2026-05-10', 3.50, 1.20),
(2, 1, 2, '2026-05-10', 2.00, 0.50),
(3, 2, 2, '2026-05-10', 4.15, 2.00),
(4, 3, 4, '2026-05-10', 1.50, 0.00),
(5, 4, 1, '2026-05-10', 5.20, 1.80),

(6, 1, 1, '2026-05-11', 4.00, 1.50),
(7, 5, 5, '2026-05-11', 1.00, 0.30),
(8, 6, 9, '2026-05-11', 0.50, 0.00),
(9, 7, 6, '2026-05-11', 2.25, 0.45),
(10, 10, 4, '2026-05-11', 3.10, 1.00),

(11, 8, 3, '2026-05-12', 3.00, 1.00),
(12, 9, 1, '2026-05-12', 6.50, 2.50),
(13, 10, 4, '2026-05-12', 2.75, 1.15),
(14, 3, 5, '2026-05-12', 1.20, 0.20),
(15, 2, 1, '2026-05-12', 3.30, 1.50);


CREATE VIEW dzienne_podsumowanie_ekranu AS SELECT 
id_uczestnika, data_pomiaru, 
SUM(czas_przed_ekranem) AS suma_czasu_ekranowego,
SUM(czas_przed_snem) AS suma_czasu_przed_snem

FROM pomiary_cyfrowe

GROUP BY id_uczestnika, data_pomiaru;

-------

CREATE TABLE styl_zycia (id_pomiaru_stylu INT, id_uczestnika INT, data_pomiaru_stylu DATE, godziny_snu DECIMAL(4,2), aktywnosc_fizyczna DECIMAL(4,2), id_interakcji_spolecznych INT);
ALTER TABLE styl_zycia ADD PRIMARY KEY (id_pomiaru_stylu);
ALTER TABLE styl_zycia ADD FOREIGN KEY (id_uczestnika) REFERENCES uczestnicy(id_uczestnika);
ALTER TABLE styl_zycia ADD FOREIGN KEY (id_interakcji_spolecznych) REFERENCES slownik_poziomow(id_poziomu);
ALTER TABLE styl_zycia ADD CONSTRAINT unikalny_styl_dzienny UNIQUE (id_uczestnika, data_pomiaru_stylu);
ALTER TABLE styl_zycia ADD CONSTRAINT max_24h_doba CHECK (godziny_snu + aktywnosc_fizyczna <=24);

INSERT INTO styl_zycia (id_pomiaru_stylu, id_uczestnika, data_pomiaru_stylu, godziny_snu, aktywnosc_fizyczna, id_interakcji_spolecznych) VALUES 
(1, 1, '2026-05-10', 6.50, 1.20, 1),
(2, 2, '2026-05-10', 7.50, 0.80, 2),
(3, 3, '2026-05-10', 5.50, 1.50, 3),
(4, 4, '2026-05-10', 8.00, 2.00, 2),

(5, 1, '2026-05-11', 6.00, 1.00, 1),
(6, 5, '2026-05-11', 7.20, 0.50, 1),
(7, 6, '2026-05-11', 6.80, 1.10, 2),
(8, 7, '2026-05-11', 7.00, 0.00, 3),
(9, 10, '2026-05-11', 5.00, 2.50, 3),

(10, 8, '2026-05-12', 6.50, 1.80, 2),
(11, 9, '2026-05-12', 4.50, 0.20, 1),
(12, 10, '2026-05-12', 5.50, 2.00, 3),
(13, 3, '2026-05-12', 7.00, 1.00, 2),
(14, 2, '2026-05-12', 6.20, 1.50, 3);

-------

CREATE TABLE zdrowie_psychiczne (id_oceny INT, id_uczestnika INT, data_pomiaru DATE, poziom_stresu INT, poziom_leku INT, id_ryzyka_depresji INT);
ALTER TABLE zdrowie_psychiczne ADD PRIMARY KEY (id_oceny);
ALTER TABLE zdrowie_psychiczne ADD FOREIGN KEY (id_uczestnika) REFERENCES uczestnicy(id_uczestnika);
ALTER TABLE zdrowie_psychiczne ADD CONSTRAINT unikalny_pomiar_zdrowia UNIQUE (id_uczestnika, data_pomiaru);
ALTER TABLE zdrowie_psychiczne ADD CONSTRAINT stres_skala CHECK (poziom_stresu BETWEEN 0 AND 10);
ALTER TABLE zdrowie_psychiczne ADD CONSTRAINT lek_skala CHECK (poziom_leku BETWEEN 0 AND 10);
ALTER TABLE zdrowie_psychiczne ADD FOREIGN KEY (id_ryzyka_depresji) REFERENCES slownik_poziomow(id_poziomu);



INSERT INTO zdrowie_psychiczne VALUES 
(1, 1, '2026-05-10', 6, 6, 2),
(2, 2, '2026-05-10', 4, 3, 1),
(3, 3, '2026-05-10', 8, 7, 3),
(4, 4, '2026-05-10', 3, 2, 1),

(5, 1, '2026-05-11', 5, 6, 2),
(6, 5, '2026-05-11', 7, 5, 2),
(7, 6, '2026-05-11', 4, 4, 1),
(8, 7, '2026-05-11', 9, 8, 3),
(9, 10, '2026-05-11', 6, 6, 2),

(10, 8, '2026-05-12', 3, 3, 1),
(11, 9, '2026-05-12', 10, 9, 3),
(12, 10, '2026-05-12', 5, 5, 2),
(13, 3, '2026-05-12', 7, 8, 3),
(14, 2, '2026-05-12', 4, 4, 1);



CREATE VIEW wplyw_braku_snu_globalnie AS
SELECT 
    COUNT(sz.id_pomiaru_stylu) AS liczba_zarwanych_nocy,
    ROUND(AVG(sz.godziny_snu), 2) AS srednia_godzin_snu,
    ROUND(AVG(zp.poziom_stresu), 2) AS sredni_poziom_stresu,
    ROUND(AVG(zp.poziom_leku), 2) AS sredni_poziom_leku
FROM 
    styl_zycia sz
JOIN 
    zdrowie_psychiczne zp 
    ON sz.id_uczestnika = zp.id_uczestnika AND sz.data_pomiaru_stylu = zp.data_pomiaru
WHERE 
    sz.godziny_snu < 6.00;



CREATE VIEW stres_niedobor_snu_uczestnicy AS
SELECT 
    u.imie,
    u.nazwisko,
    u.username,
    COUNT(sz.id_pomiaru_stylu) AS ilosc_dni_ponizej_6h,
    ROUND(AVG(zp.poziom_stresu), 2) AS sredni_stres_w_te_dni
FROM 
    uczestnicy u
JOIN 
    styl_zycia sz ON u.id_uczestnika = sz.id_uczestnika
JOIN 
    zdrowie_psychiczne zp ON sz.id_uczestnika = zp.id_uczestnika AND sz.data_pomiaru_stylu = zp.data_pomiaru
WHERE 
    sz.godziny_snu < 6.00
GROUP BY 
    u.id_uczestnika, u.imie, u.nazwisko, u.username
ORDER BY 
    sredni_stres_w_te_dni DESC;

-------

CREATE TABLE eksperymenty (id_eksperymentu INT, nazwa_eksperymentu VARCHAR, data_start DATE, data_koniec DATE);
ALTER TABLE eksperymenty ADD PRIMARY KEY (id_eksperymentu);
ALTER TABLE eksperymenty ADD CONSTRAINT chronologia CHECK (data_koniec >= data_start);

INSERT INTO eksperymenty VALUES 
(1, 'Wpływ TikToka na jakość snu studentów', '2026-05-01', '2026-05-31'),
(2, 'Porównanie stresu: Instagram vs X', '2026-04-15', '2026-06-15'),
(3, 'Detoks cyfrowy przed i w trakcie sesji', '2026-06-01', '2026-06-30'),
(4, 'Wpływ algorytmów marketingowych na poziom lęku', '2026-03-01', '2026-04-30'),
(5, 'Stres cyfrowy podczas sesji na kierunkach ścisłych', '2026-01-15', '2026-02-15');

-------

CREATE TABLE eksperymenty_uczestnicy (id_uczestnika INT, id_eksperymentu INT);
ALTER TABLE eksperymenty_uczestnicy ADD PRIMARY KEY (id_uczestnika, id_eksperymentu);
ALTER TABLE eksperymenty_uczestnicy ADD FOREIGN KEY (id_uczestnika) REFERENCES uczestnicy(id_uczestnika);
ALTER TABLE eksperymenty_uczestnicy ADD FOREIGN KEY (id_eksperymentu) REFERENCES eksperymenty(id_eksperymentu);

INSERT INTO eksperymenty_uczestnicy VALUES 
(1, 1),
(1, 4),
(2, 1),
(3, 5),
(4, 1),
(4, 3),
(5, 2),
(6, 5),
(7, 4),
(8, 2),
(9, 1),
(10, 5);


--- FUNKCJA ---

CREATE OR REPLACE FUNCTION ocena_czasu_ekranowego(p_id INT)
RETURNS VARCHAR AS $$
DECLARE
    sredni_czas DECIMAL(4,2);
BEGIN
    SELECT AVG(czas_przed_ekranem) INTO sredni_czas
    FROM pomiary_cyfrowe
    WHERE id_uczestnika = p_id;

    IF sredni_czas IS NULL THEN
        RETURN 'Brak danych';
    END IF;

    IF sredni_czas > 4.00 THEN
        RETURN 'Wysokie ryzyko';
    ELSE
        RETURN 'W normie';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT 
    imie, 
    nazwisko, 
    ocena_czasu_ekranowego(id_uczestnika) AS status_uzytkownika
FROM 
    uczestnicy;