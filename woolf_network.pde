// Widmung an Virginia Woolf: Freundschaftsnetzwerk – Langsamer Textwechsel

float pulse = 0;
boolean paused = false;
int numNodes = 7;               // Anzahl sichtbarer Knoten

float[] nodeX = new float[numNodes];
float[] nodeY = new float[numNodes];
float[] nodeAlpha = new float[numNodes];
String[] nodeCurrentText = new String[numNodes];  // Aktueller fester Text pro Knoten

String title = "Widmung an Virginia Woolf";     // Default
String subtitle = "Freundschaft & gemeinsame Ideen"; // Default
String[] textPool;  // Alle möglichen Knotentexte aus Datei

void setup() {
  size(800, 600);
  background(0);
  textAlign(CENTER);
  textSize(24);
  
  loadTextsFromFile();
  resetNodes();
}

void loadTextsFromFile() {
  String[] lines = loadStrings("network_texts.txt");
  
  if (lines != null && lines.length >= 2) {
    title = lines[0].trim();
    subtitle = lines[1].trim();
    
    if (lines.length > 2) {
      textPool = new String[lines.length - 2];
      for (int i = 2; i < lines.length; i++) {
        textPool[i-2] = lines[i].trim();
      }
    } else {
      textPool = new String[]{"Idee", "Freundschaft", "Zivilisation"};
    }
  } else {
    println("Datei 'network_texts.txt' nicht gefunden – Defaults verwendet.");
    textPool = new String[]{"Idee", "Freundschaft", "Zivilisation"};
  }
}

void resetNodes() {
  // Zentrale Knoten
  nodeX[0] = width/2;
  nodeY[0] = height/2 - 40;
  nodeAlpha[0] = 255;
  nodeCurrentText[0] = "Clive Bell";
  
  nodeX[1] = width/2;
  nodeY[1] = height/2 + 40;
  nodeAlpha[1] = 255;
  nodeCurrentText[1] = "Virginia Woolf";
  
  // Umgebende Knoten + initiale Texte
  for (int i = 2; i < numNodes; i++) {
    respawnNode(i);
  }
}

// Hilfsfunktion: Neuen Ort + neuen Text zuweisen
void respawnNode(int i) {
  float angle = random(TWO_PI);
  float dist = random(120, 220);
  nodeX[i] = width/2 + cos(angle) * dist;
  nodeY[i] = height/2 + sin(angle) * dist;
  nodeAlpha[i] = 255;
  
  // Zufälliger Text aus Pool (nur beim Respawn wechseln → langsam!)
  if (textPool.length > 0) {
    nodeCurrentText[i] = textPool[(int)random(textPool.length)];
  } else {
    nodeCurrentText[i] = "Idee";
  }
}

void draw() {
  if (paused) return;
  
  background(0, 12);  // Sanftes Fading
  
  pulse += 0.018;
  
  // Grüne Verbindungen
  stroke(0, 255, 100, 60 + sin(pulse)*50);
  strokeWeight(1.4);
  for (int i = 0; i < numNodes; i++) {
    for (int j = i+1; j < numNodes; j++) {
      if (dist(nodeX[i], nodeY[i], nodeX[j], nodeY[j]) < 320) {
        line(nodeX[i], nodeY[i], nodeX[j], nodeY[j]);
      }
    }
  }
  
  // Knoten & Texte
  noStroke();
  for (int i = 0; i < numNodes; i++) {
    // Glow
    fill(0, 255, 100, nodeAlpha[i] * 0.35);
    ellipse(nodeX[i], nodeY[i], 36, 36);
    
    // Haupt-Kreis klein
    fill(0, 255, 100, nodeAlpha[i]);
    ellipse(nodeX[i], nodeY[i], 22, 22);
    
    // Grüner Text – jetzt fest pro Knoten, bis Fade fast fertig
    fill(0, 255, 140, nodeAlpha[i]);
    textSize(20);
    text(nodeCurrentText[i], nodeX[i], nodeY[i] + 45);
    
    // Sehr langsames Fade-Out
    nodeAlpha[i] -= 0.28;  // Noch langsamer als vorher
    
    // Erst wenn fast unsichtbar → Respawn mit NEUEM Text
    if (nodeAlpha[i] < 20) {
      respawnNode(i);
    }
  }
  
  // Überschrift & Untertitel (aus Datei)
  fill(0, 255, 180, 220 + sin(pulse*0.8)*35);
  textSize(38);
  text(title, width/2, 80);
  
  fill(0, 255, 140, 180);
  textSize(24);
  text(subtitle, width/2, 120);
  
  // Info
  fill(100);
  textSize(14);
  text("T = Pause  |  S = Screenshot  |  R = Reset  |  Texte aus network_texts.txt", width/2, height-20);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) noLoop(); else loop();
  }
  
  if (key == 's' || key == 'S') {
    String ts = year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("woolf_network_" + ts + ".png");
    println("Screenshot gespeichert!");
  }
  
  if (key == 'r' || key == 'R') {
    resetNodes();
  }
}
