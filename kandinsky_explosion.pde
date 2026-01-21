// Post-Impressionistische Inspiration: Abstrakte Kunst-Explosion – Kandinsky Style

float pulse = 0;
int phase = 0;                  // 0: Figurativ → 1: Punkte → 2: Linien → 3: Flächen
float timer = 0;
boolean paused = false;

void setup() {
  size(800, 600);
  background(15, 12, 30);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  if (paused) return;
  
  background(15, 12, 30, 15);   // Sanftes Nachleuchten
  pulse += 0.025;
  timer += 1;
  
  translate(width/2, height/2);
  rotate(pulse * 0.005);        // Kandinsky: langsame innere Rotation
  
  // Phase 0: Figurative Formen (Post-Impressionismus)
  if (phase == 0) {
    fill(200, 40, 90, 80);
    noStroke();
    rect(-120, -80, 240, 160, 12);  // Haus
    ellipse(0, -100, 80, 120);      // Figur
    
    fill(60, 80, 100);
    textSize(28);
    text("Figurative Welt", 0, 180);
    
    if (timer > 180) { phase = 1; timer = 0; }
  }
  
  // Phase 1: Explosion in Punkte (Kandinsky: Urform)
  else if (phase == 1) {
    for (int i = 0; i < 120; i++) {
      float a = i * 0.08 + pulse * 3;
      float r = 80 + sin(pulse + i*0.5) * 60;
      float x = cos(a) * r;
      float y = sin(a) * r;
      
      // Punkt-Glow
      noStroke();
      fill(50 + sin(pulse*2 + i)*30, 90, 100, 70);
      ellipse(x, y, 18 + sin(pulse*1.5 + i)*8, 18 + sin(pulse*1.5 + i)*8);
      
      fill(0, 0, 100);
      ellipse(x, y, 6, 6);
    }
    
    fill(180, 80, 100, 220);
    textSize(28);
    text("Punkte – Ur-Energie", 0, 180);
    
    if (timer > 220) { phase = 2; timer = 0; }
  }
  
  // Phase 2: Linien-Chaos (Kandinsky: Dynamik & Konflikt)
  else if (phase == 2) {
    strokeWeight(3 + sin(pulse*3)*2);
    for (int i = 0; i < 18; i++) {
      float a1 = pulse * 2 + i * 0.4;
      float a2 = a1 + PI + sin(pulse + i)*0.6;
      float len = 200 + sin(pulse*1.5 + i)*80;
      
      // Linien-Glow
      stroke(200 + sin(pulse*2 + i)*80, 90, 100, 140);
      line(cos(a1)*len, sin(a1)*len, cos(a2)*len, sin(a2)*len);
    }
    
    fill(320, 80, 100, 240);
    textSize(28);
    text("Linien – Dynamik & Konflikt", 0, 180);
    
    if (timer > 260) { phase = 3; timer = 0; }
  }
  
  // Phase 3: Flächen-Komposition (Kandinsky: geistige Harmonie)
  else if (phase == 3) {
    noStroke();
    for (int i = 0; i < 12; i++) {
      float a = i * TWO_PI/12 + pulse*0.3;
      float r = 220 + sin(pulse + i*2)*100;
      float hue = (pulse*20 + i*30) % 360;
      
      fill(hue, 70, 90, 60 + sin(pulse + i)*30);
      ellipse(cos(a)*r, sin(a)*r, 180 + sin(pulse*1.2 + i)*60, 180 + sin(pulse*1.2 + i)*60);
    }
    
    fill(200, 40, 100, 240);
    textSize(28);
    text("Flächen – Abstrakte Harmonie", 0, 180);
    
    if (timer > 400) { timer = 0; phase = (int)random(0, 3); }  // Zufälliger Loop
  }
  
  // Info
  fill(200, 220);
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
    saveFrame("kandinsky_explosion_" + ts + ".png");
  }
  
  if (key == 'r' || key == 'R') {
    phase = 0;
    timer = 0;
    pulse = 0;
  }
}
