// Generative Grammar Parser (unverändert, nur für Referenz)
HashMap<String, String[]> grammar = new HashMap<String, String[]>();
boolean loaded = false;

// Parameter
int maxRecursion = 4;           // Startwert – mit 'u'/'d' änderbar
float growthFactor = 0.0;       // 0..1 = wie weit der Baum gerade gewachsen ist
float pulse = 0;
float noiseOffset = 0;

boolean paused = false;  // Globale Variable für Pause-Zustand (füge das oben im Skript hinzu, z. B. nach den anderen Variablen)

void keyPressed() {
  // Bestehende Tasten (u/d/r) bleiben erhalten
  if (key == 'u' || key == 'U') {
    maxRecursion = min(maxRecursion + 1, 7);
  }
  if (key == 'd' || key == 'D') {
    maxRecursion = max(maxRecursion - 1, 2);
  }
  if (key == 'r' || key == 'R') {
    growthFactor = 0.0;  // Reset Wachstum
  }
  
  // Neu: S = Screenshot speichern
  if (key == 's' || key == 'S') {
    String timestamp = year() + "-" + nf(month(),2) + "-" + nf(day(),2) + "_" 
                     + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("tree_" + timestamp + ".png");
    println("Screenshot gespeichert: tree_" + timestamp + ".png");
  }
  
  // Neu: T = Pause / Play der Animation
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) {
      noLoop();           // Stoppt draw() komplett → Animation pausiert
      println("Animation pausiert");
    } else {
      loop();             // Startet draw() wieder
      println("Animation fortgesetzt");
    }
  }
}

void setup() {
  size(800, 600);
  background(255);
  frameRate(60);                // Flüssiger
  textSize(24);
  textAlign(CENTER);
  loadGrammar();
  
  // Sofort starten
  growthFactor = 0.3;           // Kleiner Start-Baum sofort sichtbar
}

void draw() {
  background(255);
  pulse += 0.03;
  noiseOffset += 0.008;
  
  // Smooth Wachstum (ca. 5–8 Sekunden bis voll)
  growthFactor = min(growthFactor + 0.002, 1.0);
  
  pushMatrix();
  translate(400, 550);          // Wurzel etwas höher → mehr Platz unten
  drawTree(0, 0, 180, -HALF_PI, 0, growthFactor);
  popMatrix();
  
  // Info-Text unten
  fill(80);
  textSize(16);
  text("Rekursionstiefe: " + maxRecursion + "   |   u / d zum Ändern   |   Klick zum Neugenerieren", width/2, height-20);
}

void drawTree(float x, float y, float len, float angle, int depth, float growth) {
  if (depth > maxRecursion) return;
  
  // Aktuelle Länge = Basislänge * Wachstumsfaktor * (Abnahme pro Tiefe)
  float currentLen = len * growth * pow(0.75, depth);
  
  float endX = x + currentLen * cos(angle);
  float endY = y + currentLen * sin(angle);  // +sin → nach oben
  
  // Linie zeichnen
  strokeWeight(12 - depth*1.5 + sin(pulse + depth)*1.5);
  stroke(lerpColor(color(40, 180, 40), color(180, 40, 40), (float)depth / maxRecursion));
  line(x + noise(noiseOffset + depth)*8, y + noise(noiseOffset + depth+10)*8,
       endX + noise(noiseOffset + depth*2)*6, endY + noise(noiseOffset + depth*2 + 5)*6);
  
  // Label nur ab Tiefe 1 (vermeidet Flackern an Wurzel)
  if (depth >= 1 && currentLen > 20) {
    pushMatrix();
    translate(endX, endY);
    rotate(angle + HALF_PI);               // Text horizontal am Branch
    fill(0, 180);
    textSize(18 - depth*1.5);              // Kleiner bei tieferen Branches
    String label = expand("<S>", maxRecursion - depth + 1);
    text(label, 0, -8);
    popMatrix();
  }
  
  // 2–4 Sub-Branches
  int branches = (int)random(2, 4);
  for (int i = 0; i < branches; i++) {
    float newAngle = angle + random(-0.7, 0.7);
    drawTree(endX, endY, len * 0.68, newAngle, depth + 1, growth);
  }
}

void mouseClicked() {
  // Neu generieren der Grammatik-Sätze
  background(255);
  // Optional: growthFactor = 0; für Reset-Effekt (auskommentiert)
}


void loadGrammar() {
  String[] lines = loadStrings("grammar.txt");
  for (String line : lines) {
    if (line.trim().isEmpty()) continue;
    String[] parts = line.split(" = ");
    String key = parts[0].trim();
    String[] options = parts[1].split("\\|"); // Gefixt: Kein Leerzeichen-Split, direkt |
    for (int i = 0; i < options.length; i++) {
      options[i] = options[i].trim(); // Trim für Robustheit
    }
    grammar.put(key, options);
  }
  loaded = true;
}

String expand(String symbol, int maxDepth) {
  if (maxDepth <= 0 || !grammar.containsKey(symbol)) return symbol;
  String[] options = grammar.get(symbol);
  String choice = options[(int)random(options.length)];
  String[] parts = choice.split(" ");
  String result = "";
  for (String part : parts) {
    if (part.startsWith("<") && part.endsWith(">")) {
      result += expand(part, maxDepth - 1) + " ";
    } else {
      result += part + " ";
    }
  }
  return result.trim();
}
