// Sozialismus und Menschheit: Kollektive Figuren – Nachtmodus mit starkem Glow

int numFigures = 80;
float[] figX = new float[numFigures];
float[] figY = new float[numFigures];
float[] figVX = new float[numFigures];
float[] figVY = new float[numFigures];

int phase = 0;
float timer = 0;
boolean paused = false;
float pulse = 0;

void setup() {
  size(800, 600);
  background(10, 8, 25);
  frameRate(30);
  
  resetFigures();
}

void resetFigures() {
  for (int i = 0; i < numFigures; i++) {
    figX[i] = random(100, 700);
    figY[i] = random(100, 500);
    figVX[i] = random(-1, 1);
    figVY[i] = random(-1, 1);
  }
  phase = 0;
  timer = 0;
}

void draw() {
  if (paused) return;
  
  background(10, 8, 25, 20);  // Dunkler Nacht-Hintergrund mit sanftem Fade
  pulse += 0.04;
  
  timer += 1;
  
  // Phase 0: Anziehung (Harmonie – grüner Glow)
  if (phase == 0) {
    for (int i = 0; i < numFigures; i++) {
      float dx = width/2 - figX[i];
      float dy = height/2 - figY[i];
      float dist = sqrt(dx*dx + dy*dy);
      if (dist > 20) {
        figX[i] += dx * 0.004;
        figY[i] += dy * 0.004;
      }
      
      // Starkes Glow
      noStroke();
      for (int g = 0; g < 5; g++) {
        fill(0, 255, 120, 80 - g*15 + sin(pulse + i)*20);
        ellipse(figX[i], figY[i], 30 + g*8, 30 + g*8);
      }
      
      fill(0, 255, 140, 255);
      ellipse(figX[i], figY[i], 12, 12);
    }
    
    fill(0, 255, 180, 240);
    textSize(32);
    text("Sozialismus & Menschheit", width/2, 80);
    
    if (timer > 320) { phase = 1; timer = 0; }
  }
  
  // Phase 1: Chaos durch Krieg (roter, aggressiver Glow)
  else if (phase == 1) {
    for (int i = 0; i < numFigures; i++) {
      figX[i] += random(-4, 4);
      figY[i] += random(-4, 4);
      
      // Rote Störungen + intensiver Glow
      for (int g = 0; g < 6; g++) {
        fill(255, 60 + sin(pulse*2 + i)*40, 0, 90 - g*15);
        ellipse(figX[i] + random(-25,25), figY[i] + random(-25,25), 40 + g*10, 40 + g*10);
      }
      
      fill(255, 80, 40, 220);
      ellipse(figX[i], figY[i], 10, 10);
    }
    
    fill(255, 80, 40, 240);
    textSize(32);
    text("Krieg & Zerstreuung", width/2, 80);
    
    if (timer > 280) { phase = 2; timer = 0; }
  }
  
  // Phase 2: Neue Ordnung (blauer, harmonischer Glow)
  else if (phase == 2) {
    for (int i = 0; i < numFigures; i++) {
      float dx = width/2 - figX[i];
      float dy = height/2 - figY[i];
      float dist = sqrt(dx*dx + dy*dy);
      if (dist > 40) {
        figX[i] += dx * 0.003;
        figY[i] += dy * 0.003;
      }
      
      // Intensiver blauer Glow
      noStroke();
      for (int g = 0; g < 5; g++) {
        fill(40, 100 + sin(pulse + i)*80, 255, 80 - g*15);
        ellipse(figX[i], figY[i], 35 + g*9, 35 + g*9);
      }
      
      fill(80, 160, 255, 255);
      ellipse(figX[i], figY[i], 14, 14);
    }
    
    // Blaue harmonische Fläche
    fill(40, 80, 220, 60);
    noStroke();
    beginShape();
    for (int i = 0; i < numFigures; i += 4) {
      curveVertex(figX[i], figY[i]);
    }
    endShape(CLOSE);
    
    fill(80, 160, 255, 240);
    textSize(32);
    text("Neue Zivilisation", width/2, 80);
    
    if (timer > 450) { resetFigures(); }  // Zyklus zurück
  }
  
  // Info
  fill(140, 160, 200);
  textSize(14);
  text("T = Pause/Play  |  S = Screenshot  |  R = Reset", width/2, height-20);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) noLoop(); else loop();
  }
  
  if (key == 's' || key == 'S') {
    String ts = year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("kollektive_glow_nacht_" + ts + ".png");
  }
  
  if (key == 'r' || key == 'R') {
    resetFigures();
  }
}
