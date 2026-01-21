// Kandinsky-inspirierte Vorher-Nachher-Transformation mit Zyklus & PDF-Integration

int phase = 0;                  // 0: Punkte (Neubeginn/Vorkrieg), 1: Linien (Krieg), 2: Flächen (Nachkrieg)
float timer = 0;
float pulse = 0;
float angle = 0;
String[] pdfQuotes;             // Für PDF-Texte aus .txt
boolean paused = false;

void setup() {
  size(800, 600);
  background(220);
  frameRate(60);
  textAlign(CENTER);
  textSize(20);
  
  // Lade PDF-Zitate aus Datei
  pdfQuotes = loadStrings("pdf_quotes.txt");
  if (pdfQuotes == null || pdfQuotes.length == 0) {
    pdfQuotes = new String[]{"childish phantasy", "war changed everything"};
  }
}

void draw() {
  if (paused) return;           // Pause-Funktion
  
  background(220, 40);          // Leichtes Fading für Smooth-Übergänge (Variante 1)
  translate(width/2, height/2);
  rotate(angle += 0.005);       // Rhythmische Rotation (Kandinsky-Spannung)
  pulse += 0.03;
  
  timer += 1;
  
  // === Phase 0: Punkte – Harmonie / Neubeginn (Kandinsky: statische Punkte mit Resonanz)
  if (phase == 0) {
    fill(0, 180 + sin(pulse)*80, 0, 200);  // Pulsierendes Grün (Variante 3)
    noStroke();
    for (int i = 0; i < 8; i++) {          // Organische Verteilung (Variante 4)
      float r = 120 + sin(pulse + i)*30;
      float a = i * TWO_PI/8 + pulse*0.2;
      ellipse(cos(a)*r, sin(a)*r, 60 + random(-10,10), 60 + random(-10,10));
      if (i % 2 == 0) text("Ideale", cos(a)*r, sin(a)*r + 10);
    }
    if (timer > 180) { phase = 1; timer = 0; }
  }
  
  // === Phase 1: Linien – Disruption (Krieg) (Kandinsky: dynamische Kraft)
  else if (phase == 1) {
    stroke(220 + sin(pulse)*35, 0, 0, map(timer, 0, 180, 0, 255));  // Fade-in Rot (Variante 1)
    strokeWeight(4 + sin(pulse)*3);
    for (int i = 0; i < 12; i++) {
      float x1 = random(-300, 300);
      float y1 = random(-200, 200);
      float x2 = x1 + random(-150, 150);
      float y2 = y1 + random(-150, 150);
      line(x1, y1, x2, y2);
    }
    if (mousePressed) { timer += 3; }      // Interaktive Beschleunigung (Variante 2)
    if (timer > 180) { phase = 2; timer = 0; }
  }
  
  // === Phase 2: Flächen – Neue Abstraktion (Nachkrieg) (Kandinsky: Komposition)
  else if (phase == 2) {
    fill(0, 0, 200 + sin(pulse)*55, 140);
    noStroke();
    beginShape();
    for (int i = 0; i < 8; i++) {
      float a = i * TWO_PI/8 + pulse;
      float r = 180 + sin(pulse + i*2)*60;
      vertex(cos(a)*r, sin(a)*r);
    }
    endShape(CLOSE);
    
    // PDF-Texte zufällig platzieren (Variante 5)
    fill(255, 220);
    textSize(16 + sin(pulse)*4);
    for (int i = 0; i < 5; i++) {
      String quote = pdfQuotes[(int)random(pdfQuotes.length)];
      float tx = random(-180, 180);
      float ty = random(-120, 120);
      text(quote, tx, ty);
    }
    
    textSize(24);
    text("Neue Zivilisation", 0, 0);
    
    if (timer > 220) { phase = 0; timer = 0; }  // Zyklus zurück zum Neubeginn
  }
  
  // Globale Info
  resetMatrix();
  fill(60);
  textSize(14);
  text("Phase: " + phase + "  |  Maus drücken = schneller Krieg  |  T = Pause  |  S = Screenshot", width/2, height-20);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    String ts = year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("kandinsky_war_" + ts + ".png");
    println("Gespeichert: kandinsky_war_" + ts + ".png");
  }
  
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) noLoop(); else loop();
    println(paused ? "Pausiert" : "Fortgesetzt");
  }
}
