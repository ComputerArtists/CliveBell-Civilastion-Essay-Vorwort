// Kombiniertes Projekt: Baum wächst aus Kandinsky-Fläche (Nachkriegs-Zivilisation)

boolean paused = false;
int phase = 0;                  // 0: Fläche stabil, 1: Linien-Disruption, 2: Baum-Wachstum
float timer = 0;
float pulse = 0;
float noiseOffset = 0;
float growthFactor = 0.0;       // 0..1 für Baum-Wachstum
int maxRecursion = 4;           // Start-Rekursionstiefe
String[] pdfQuotes;

void setup() {
  size(800, 600);
  background(220);
  frameRate(60);
  textAlign(CENTER);
  textSize(20);
  
  pdfQuotes = loadStrings("pdf_quotes.txt");
  if (pdfQuotes == null || pdfQuotes.length == 0) {
    pdfQuotes = new String[]{"childish phantasy", "modified my ideas"};
  }
}

void draw() {
  if (paused) return;
  
  background(220, 40);          // Leichtes Fading
  translate(width/2, height/2);
  rotate(pulse * 0.005);        // Sanfte Rhythmus-Rotation
  pulse += 0.03;
  noiseOffset += 0.008;
  timer += 1;
  
  // === Phase 0: Blaue Fläche – Neue Ordnung (Nachkrieg)
  if (phase == 0) {
    fill(0, 0, 180 + sin(pulse)*60, 160);
    noStroke();
    beginShape();
    for (int i = 0; i < 10; i++) {
      float a = i * TWO_PI/10 + pulse*0.5;
      float r = 220 + sin(pulse + i)*80;
      vertex(cos(a)*r, sin(a)*r);
    }
    endShape(CLOSE);
    
    // Zufällige PDF-Zitate auf der Fläche
    fill(255, 220);
    textSize(18 + sin(pulse)*3);
    for (int i = 0; i < 6; i++) {
      String q = pdfQuotes[(int)random(pdfQuotes.length)];
      text(q, random(-180, 180), random(-120, 120));
    }
    
    textSize(28);
    fill(255);
    text("Neue Zivilisation", 0, 0);
    
    if (timer > 220) { phase = 1; timer = 0; growthFactor = 0.0; }
  }
  
  // === Phase 1: Kurze Linien-Disruption (Krieg-Echo)
  else if (phase == 1) {
    stroke(220, 40, 0, map(timer, 0, 120, 255, 0)); // Fade out
    strokeWeight(5 + sin(pulse)*3);
    for (int i = 0; i < 15; i++) {
      line(random(-250, 250), random(-180, 180), random(-250, 250), random(-180, 180));
    }
    
    if (timer > 120) { phase = 2; timer = 0; }
  }
  
  // === Phase 2: Baum wächst aus der Fläche heraus
  else if (phase == 2) {
    // Fläche bleibt als Basis sichtbar, aber schwächer
    fill(0, 0, 180, 80 + sin(pulse)*40);
    noStroke();
    beginShape();
    for (int i = 0; i < 10; i++) {
      float a = i * TWO_PI/10 + pulse*0.3;
      float r = 180 + sin(pulse + i)*40;
      vertex(cos(a)*r, sin(a)*r);
    }
    endShape(CLOSE);
    
    // Rekursiver Baum – Wurzel unten in der Fläche
    pushMatrix();
    translate(0, 100);  // Wurzel etwas nach unten verschieben
    drawTree(0, 0, 160, -HALF_PI, 0, growthFactor);
    popMatrix();
    
    growthFactor = min(growthFactor + 0.0018, 1.0); // Sehr langsames Wachstum
    
    if (growthFactor >= 1.0 && timer > 300) {
      phase = 0; timer = 0; growthFactor = 0.0; // Zyklus zurück zur Fläche
    }
  }
  
  // Globale Steuerung-Info
  resetMatrix();
  fill(60);
  textSize(14);
  text("Phase: " + phase + "  |  T = Pause/Play  |  S = Screenshot  |  U/D = Tiefe  |  R = Reset Wachstum", width/2, height-20);
}

// Rekursive Baum-Funktion (angepasst aus Skript 1)
void drawTree(float x, float y, float len, float angle, int depth, float growth) {
  if (depth > maxRecursion) return;
  
  float currentLen = len * growth * pow(0.72, depth);
  float endX = x + currentLen * cos(angle);
  float endY = y + currentLen * sin(angle);
  
  strokeWeight(10 - depth*1.2 + sin(pulse + depth)*1.5);
  stroke(lerpColor(color(40, 180, 40), color(100, 220, 40), (float)depth / maxRecursion));
  line(x + noise(noiseOffset + depth)*10, y + noise(noiseOffset + depth)*10,
       endX + noise(noiseOffset + depth*2)*8, endY + noise(noiseOffset + depth*2)*8);
  
  // Label ab depth 1 (PDF-Zitate oder generisch)
  if (depth >= 1 && currentLen > 25) {
    pushMatrix();
    translate(endX, endY);
    rotate(angle + HALF_PI);
    fill(0, 180);
    textSize(16 - depth*1.2);
    String label = pdfQuotes[(int)random(pdfQuotes.length)];
    text(label, 0, -8);
    popMatrix();
  }
  
  // Sub-Branches
  int branches = (int)random(2, 4);
  for (int i = 0; i < branches; i++) {
    float newAngle = angle + random(-0.8, 0.8);
    drawTree(endX, endY, len * 0.65, newAngle, depth + 1, growth);
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    String ts = year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("tree_from_flache_" + ts + ".png");
    println("Gespeichert: tree_from_flache_" + ts + ".png");
  }
  
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) noLoop(); else loop();
    println(paused ? "Pausiert" : "Fortgesetzt");
  }
  
  if (key == 'u' || key == 'U') maxRecursion = min(maxRecursion + 1, 7);
  if (key == 'd' || key == 'D') maxRecursion = max(maxRecursion - 1, 2);
  if (key == 'r' || key == 'R') { growthFactor = 0.0; timer = 0; }
}
