// Dramatisches Verbrennen des Manuskripts – Starke Effekte, Glow, Rauch, Text aus Datei

float fireY = 620;              // Start ganz unten
float burnSpeed = 0.35;         // Noch langsamer für Drama
float textFade = 255;
boolean paused = false;
boolean climax = false;
boolean burned = false;

String[] lines;
float lineHeight;
float baseTextSize;

ArrayList<Particle> ashes = new ArrayList<Particle>();  // Asche-Partikel

class Particle {
  float x, y, vx, vy, alpha;
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    vx = random(-1.5, 1.5);
    vy = random(-2, -0.5);
    alpha = 255;
  }
  void update() {
    x += vx;
    y += vy;
    alpha -= 1.5;
  }
  void display() {
    if (alpha > 0) {
      fill(80, 60, 40, alpha);
      noStroke();
      ellipse(x, y, random(3, 8), random(3, 8));
    }
  }
}

void setup() {
  size(800, 600);
  background(8);
  textAlign(CENTER);
  frameRate(60);
  
  lines = loadStrings("manuscript.txt");
  if (lines == null || lines.length == 0) {
    lines = new String[]{"Fehler: manuscript.txt fehlt", "Verwende Defaults"};
  }
  
  // Automatische Skalierung
  int n = lines.length;
  baseTextSize = constrain(map(n, 5, 80, 48, 16), 16, 48);
  lineHeight = baseTextSize * 1.45;
  
  resetAnimation();
}

void resetAnimation() {
  fireY = 620;
  textFade = 255;
  climax = false;
  burned = false;
  ashes.clear();
}

void draw() {
  if (paused) return;
  
  background(8, 6);
  
  // Feuer hochkriechen + Drama-Boost
  fireY -= burnSpeed + (climax ? 2.5 : 0);  // Plötzlich schneller im Höhepunkt
  if (fireY < 60) fireY = 60;
  
  // Rauch – dichter und wirbelnd
  for (int i = 0; i < 6; i++) {
    float rx = random(width*0.15, width*0.85);
    float ry = fireY - random(80, 400);
    float rsize = random(80, 220);
    fill(50 + sin(frameCount*0.02 + i)*30, 50, 50, random(40, 110));
    ellipse(rx + sin(frameCount*0.015 + i)*30, ry, rsize, rsize*2.5);
  }
  
  // Dramatische Flammen – unregelmäßig, mit Farbwechsel
  noStroke();
  for (int i = 0; i < 12; i++) {
    float fx = random(80, 720);
    float fsize = random(60, 180);
    float hue = random(10, 50);  // Orange-Rot-Violett
    fill(hue, 255, 255 - hue*2, random(90, 180));
    triangle(fx, fireY, fx - fsize*0.7, fireY - fsize*1.4, fx + fsize*0.7, fireY - fsize*1.4);
    
    // Flammen-Glow
    fill(255, 220, 80, 80);
    ellipse(fx, fireY - fsize*0.7, fsize*2.2, fsize*3.5);
  }
  
  // Asche-Regen nach Höhepunkt
  if (climax && random(1) < 0.4) {
    ashes.add(new Particle(random(width*0.3, width*0.7), fireY - 100));
  }
  for (int i = ashes.size()-1; i >= 0; i--) {
    Particle p = ashes.get(i);
    p.update();
    p.display();
    if (p.alpha <= 0) ashes.remove(i);
  }
  
  // Text mit starkem Glow
  float startY = (height - lines.length * lineHeight) / 2 + lineHeight/2;
  
  for (int i = 0; i < lines.length; i++) {
    float yPos = startY + i * lineHeight;
    
    // Glow – extrem stark, wenn Zeile brennt
    float glowStrength = 0;
    if (yPos > fireY - 60 && yPos < fireY + 80) {
      glowStrength = 255 + sin(frameCount * 0.25) * 80;  // Intensives Pulsieren
    }
    fill(255, 240, 180, glowStrength);
    textSize(baseTextSize * 1.15);
    text(lines[i], width/2 + random(-1,1), yPos + random(-1,1));  // Leichtes Zittern
    
    // Haupttext
    if (yPos > fireY + 50) {
      fill(70, 50, 30, textFade * 0.7);  // Verkohlt
    } else {
      fill(250, 240, 220, textFade);
    }
    textSize(baseTextSize);
    text(lines[i], width/2, yPos);
  }
  
  // Höhepunkt-Trigger (wenn Feuer Mitte erreicht)
  if (fireY < height/2 + 50 && !climax) {
    climax = true;
    // Screen-Shake für 60 Frames
    if (frameCount % 4 == 0) {
      translate(random(-4,4), random(-4,4));
    }
  }
  
  // Finale Verblassen
  if (fireY < 120) {
    textFade -= 0.4;
    if (textFade < 0) textFade = 0;
  }
  
  if (textFade <= 0 && !burned) {
    burned = true;
    fill(255, 220, 100, 240 + sin(frameCount*0.12)*40);
    textSize(64);
    text("CIVILIZATION", width/2, height/2 - 60);
    textSize(42);
    text("Das Wesentliche bleibt", width/2, height/2 + 40);
  }
  
  // Info
  resetMatrix();
  fill(140);
  textSize(14);
  text("T = Pause  |  S = Screenshot  |  R = Neustart  |  Text aus manuscript.txt", width/2, height-20);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) noLoop(); else loop();
  }
  
  if (key == 's' || key == 'S') {
    String ts = year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("dramatic_burn_" + ts + ".png");
    println("Screenshot gespeichert!");
  }
  
  if (key == 'r' || key == 'R') {
    resetAnimation();
  }
}
