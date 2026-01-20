# Clive Bell – Civilization: Processing Visualisierungen

Eine Sammlung von 7 interaktiven Processing-Skripten, inspiriert von Clive Bells Essay *Civilization* (1928, Pelican Books).  
Das Projekt visualisiert zentrale Themen und Motive aus Bells Widmung an Virginia Woolf und dem Buch selbst – von der jugendlichen Idee des „New Renaissance“ über den Krieg als Bruch bis hin zur entstehenden neuen Zivilisation.

## Hintergrund

Clive Bell widmet das Buch Virginia Woolf und reflektiert darin über die Entstehung seiner Ideen:  
- Jugendliche Sozialisten-Träume und die „New Renaissance“  
- Der Erste Weltkrieg als Wendepunkt, der alles verändert  
- Die schrittweise Extraktion und Umformung des Materials zu *Art*, *On British Freedom* und schließlich *Civilization*  
- Das Verbrennen des Restmanuskripts – „fed the central heater“  

Die Skripte übersetzen diese Gedankenwelt in abstrakte, dynamische Kunst – teils mit starkem Kandinsky-Einfluss (Punkt → Linie → Fläche, Farbklang, Rhythmus).

## Installation & Start

1. **Processing installieren**  
   → https://processing.org/download (aktuellste Version empfohlen, z. B. 4.3)

2. **Projektordner erstellen**  
   - Erstelle einen Ordner (z. B. `CliveBell_Visualizations`)  
   - Speichere darin jedes Skript als eigene `.pde`-Datei (z. B. `idea1_tree.pde`, `idea2_war.pde` usw.)

3. **Benötigte Dateien** (falls verwendet)  
   - `timeline.txt` → für Idee 5  
   - `network_texts.txt` → für Idee 3  
   - `manuscript.txt` → für Idee 4  
   - Bilddateien (z. B. `page4.png` bis `page11.png`) → für Idee 5 (aus deinem PDF extrahiert)

4. **Starten**  
   - Öffne eine `.pde`-Datei in Processing  
   - Drücke **Play** (Dreieck-Button) oder Strg+R

## Steuerung (für alle Skripte gleich)

| Taste | Funktion                          |
|-------|------------------------------------|
| **T** | Pause / Play (Toggle)             |
| **S** | Screenshot speichern (mit Timestamp) |
| **R** | Reset / Neustart der Animation    |

Manche Skripte haben zusätzliche Steuerung (z. B. MouseX/Y, U/D für Tiefe).

## Die 7 Visualisierungen – Kurzübersicht

1. **Evolution der Ideen – Rekursiver Baum**  
   - Der Baum wächst aus Bells Jugendidee zur finalen *Civilization*  
   - Features: Rekursion, Nachtmodus, Glow, Maus-Interaktion

2. **Der Einfluss des Krieges – Vorher-Nachher**  
   - Harmonie (Punkte) → Disruption (Linien) → Abstrakte Ordnung (Flächen)  
   - Kandinsky-inspiriert, zyklisch, Crossfade

3. **Widmung an Virginia Woolf – Freundschaftsnetzwerk**  
   - Grüne Knoten & Texte aus `network_texts.txt`  
   - Langsames Fade-Out, dynamische Texte

4. **Das Verbrennen des Manuskripts – Feuer & Rauch**  
   - Langsames Verbrennen des Textes aus `manuscript.txt`  
   - Starkes Glow, Rauch, dramatische Asche-Partikel

5. **Historische Zeitlinie – Interaktive Entwicklung**  
   - Daten aus `timeline.txt` (Beschreibung / Jahr / Bild)  
   - Wandender Pointer, Crossfade-Bilder, MouseY-Speed, MouseX im Pause

6. **Sozialismus & Menschheit – Kollektive Figuren**  
   - Figuren ziehen sich zusammen → Chaos → Neue Ordnung  
   - Nachtmodus, starker Neon-Glow, zyklisch

7. **Post-Impressionistische Inspiration – Abstrakte Explosion**  
   - Figurativ → Punkte → Linien → Flächen  
   - Kandinsky pur: Farbklang, Rhythmus, Rotation, Transparenz

## Tipps & Erweiterungen

- **Nachtmodus/Glow** – fast überall integriert (besonders stark in 6 & 7)  
- **Bilder für Zeitlinie** – speichere deine PDF-Seiten als `pageX.png` in den `data`-Ordner  
- **Mehr Texte** – bearbeite einfach die `.txt`-Dateien  
- **Alle Skripte vereinen** – kopiere sie als Tabs in ein Projekt oder baue ein Hauptmenü (mit `switch` oder Buttons)

Viel Spaß beim Erkunden und Weiterentwickeln – das Projekt ist eine schöne Hommage an Bells Essay und Woolfs Freundschaft!

Thomas, Essen – Januar 2026
