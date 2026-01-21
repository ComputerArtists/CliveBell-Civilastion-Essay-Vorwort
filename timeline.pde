// Interaktive Zeitlinie – draw() bei mouseMoved im Pause-Modus manuell aufrufen

ArrayList<Event> events = new ArrayList<Event>();
float pointerX = 60;
float fadeAlpha = 0;
PImage prevImage, nextImage;
int currentIndex = -1;
boolean paused = false;
float zoomFactor = 1.0;
boolean manualDrawCall = false;  // Flag für manuelle Aufrufe

class Event {
  String desc;
  int year;
  String imgName;
  float xPos;
  PImage img;
  
  Event(String d, int y, String imgName) {
    desc = d;
    year = y;
    this.imgName = imgName;
    img = loadImage(imgName);
  }
}

void setup() {
  size(800, 600);
  background(245, 245, 250);
  textAlign(CENTER);
  textFont(createFont("Arial", 16));
  
  loadTimelineData();
  
  if (events.size() > 0) {
    events.sort((e1, e2) -> Integer.compare(e1.year, e2.year));
    
    int minY = events.get(0).year;
    int maxY = events.get(events.size()-1).year;
    for (Event e : events) {
      e.xPos = map(e.year, minY, maxY, 60, 740);
    }
    
    currentIndex = 0;
    nextImage = events.get(0).img;
    fadeAlpha = 255;
  }
}

void loadTimelineData() {
  String[] lines = loadStrings("timeline.txt");
  if (lines != null) {
    for (String line : lines) {
      if (line.trim().isEmpty()) continue;
      String[] parts = line.split(" / ");
      if (parts.length == 3) {
        events.add(new Event(parts[0].trim(), int(parts[1].trim()), parts[2].trim()));
      }
    }
  }
}

void draw() {
  background(245, 245, 250);
  
  float timelineY = height * 0.82;
  stroke(100, 120, 180, 220);
  strokeWeight(5);
  line(60, timelineY, 740, timelineY);
  
  fill(80, 100, 140);
  textSize(14);
  for (Event e : events) {
    stroke(80, 100, 140, 180);
    strokeWeight(2);
    ellipse(e.xPos, timelineY, 16, 16);
    fill(80, 100, 140);
    text(e.year, e.xPos, timelineY + 32);
    
    if (abs(mouseX - e.xPos) < 20 && abs(mouseY - timelineY) < 50) {
      fill(60, 80, 120);
      textSize(22);
      text(e.desc, width/2, 100);
    }
  }
  
  fill(200, 40, 60);
  noStroke();
  triangle(pointerX - 12, timelineY - 18, pointerX + 12, timelineY - 18, pointerX, timelineY - 40);
  
  // Automatische Bewegung nur im Play-Modus
  if (!paused) {
    float speed = map(mouseY, 0, height, 2.2, 0.2);
    pointerX += speed;
    if (pointerX > 740) pointerX = 60;
  }
  
  // Crossfade & Zoom aktualisieren
  updateFromPointer();
  
  // Bild + Rahmen
  if (nextImage != null) {
    float imgW = nextImage.width;
    float imgH = nextImage.height;
    float scale = min(620.0 / imgW, 320.0 / imgH) * zoomFactor;
    float drawW = imgW * scale;
    float drawH = imgH * scale;
    
    pushMatrix();
    translate(width/2, height*0.35);
    
    noStroke();
    fill(0, 0, 0, 60);
    rect(-drawW/2 - 16, -drawH/2 - 16, drawW + 32, drawH + 32, 18);
    
    fill(255);
    rect(-drawW/2 - 10, -drawH/2 - 10, drawW + 20, drawH + 20, 12);
    
    if (currentIndex > 0 && prevImage != null) {
      tint(255, 255 - fadeAlpha);
      image(prevImage, -drawW/2 - 10, -drawH/2 - 10, drawW + 20, drawH + 20);
    }
    
    tint(255, fadeAlpha);
    image(nextImage, -drawW/2 - 10, -drawH/2 - 10, drawW + 20, drawH + 20);
    noTint();
    popMatrix();
  }
  
  fill(60, 80, 120);
  textSize(26);
  if (currentIndex >= 0) {
    text(events.get(currentIndex).desc, width/2, height - 80);
  }
  
  fill(140);
  textSize(14);
  text(paused ? "PAUSE – MausX steuert Pointer & Bild sofort – T zum Weiter" : "Play – MausY = Speed – T zum Pausieren", width/2, height-20);
}

// Zentrale Update-Funktion (wird von draw() und mouseMoved() aufgerufen)
void updateFromPointer() {
  for (int i = 0; i < events.size(); i++) {
    Event e = events.get(i);
    float nextX = (i < events.size()-1) ? events.get(i+1).xPos : 800;
    float seg = (nextX - e.xPos) / 6;
    
    if (pointerX >= e.xPos - seg && pointerX <= e.xPos + seg) {
      fadeAlpha = map(pointerX, e.xPos - seg, e.xPos + seg, 0, 255);
      if (currentIndex != i) {
        prevImage = nextImage;
        nextImage = e.img;
        currentIndex = i;
        zoomFactor = 1.18;
      }
    }
    
    if (i < events.size()-1) {
      Event next = events.get(i+1);
      float outStart = next.xPos - (next.xPos - e.xPos)/6;
      float outEnd   = next.xPos + (next.xPos - e.xPos)/6;
      if (pointerX >= outStart && pointerX <= outEnd) {
        fadeAlpha = map(pointerX, outStart, outEnd, 255, 0);
      }
    }
  }
  
  if (zoomFactor > 1.0) {
    zoomFactor = lerp(zoomFactor, 1.0, 0.08);
  }
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    paused = !paused;
    if (paused) {
      noLoop();
      // Sofort einmal draw() aufrufen, damit der Pause-Zustand sichtbar ist
      draw();
    } else {
      loop();
    }
    println(paused ? "Pause aktiviert" : "Play aktiviert");
  }
  
  if (key == 's' || key == 'S') {
    String ts = year() + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    saveFrame("timeline_" + ts + ".png");
  }
  
  if (key == 'r' || key == 'R') {
    pointerX = 60;
  }
}

// Bei jeder Mausbewegung im Pause-Modus: Pointer setzen + kompletten Draw aufrufen
void mouseMoved() {
  if (paused) {
    pointerX = constrain(mouseX, 60, 740);
    updateFromPointer();      // Sofort Crossfade & Zoom berechnen
    draw();                   // Kompletten Frame neu rendern (Bild, Rahmen, alles)
  }
}

void mousePressed() {
  if (paused) {
    pointerX = constrain(mouseX, 60, 740);
    updateFromPointer();
    draw();
  }
}
