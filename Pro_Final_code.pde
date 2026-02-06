import processing.serial.*;

Serial myPort;

int angle = 0;
int distance = 0;

void setup() {
  size(800, 500);
  smooth();

  println(Serial.list()); // check COM port
  myPort = new Serial(this, "COM5", 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0);
  translate(width/2, height);

  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    String[] parts = split(data, ',');
    if (parts.length == 2) {
      angle = int(parts[0]);
      distance = int(parts[1]);
    }
  }
}

void drawRadar() {
  stroke(0, 255, 0);
  noFill();

  for (int i = 1; i <= 4; i++) {
    arc(0, 0, i*200, i*200, PI, TWO_PI);
  }

  for (int a = 0; a <= 180; a += 30) {
    float x = 200 * cos(radians(a));
    float y = -200 * sin(radians(a));
    line(0, 0, x, y);
  }
}

void drawLine() {
  stroke(255, 0, 0);
  strokeWeight(2);

  float x = 200 * cos(radians(angle));
  float y = -200 * sin(radians(angle));
  line(0, 0, x, y);
}

void drawObject() {
  if (distance > 2 && distance < 300) {

    float pixDistance = map(distance, 0, 300, 0, 200);
    float x = pixDistance * cos(radians(angle));
    float y = -pixDistance * sin(radians(angle));

    // Glow effect
    noStroke();
    fill(255, 0, 0, 80);
    ellipse(x, y, 30, 30);

    // Solid center dot
    fill(255, 0, 0);
    ellipse(x, y, 10, 10);

    // Distance text near object
    fill(255, 255, 255);
    textSize(12);
    text(distance + " cm", x + 10, y - 10);
  }
}


void drawText() {
  resetMatrix();
  fill(0, 255, 0);
  textSize(14);

  text("Angle: " + angle + "°", 20, height - 40);
  text("Distance: " + distance + " cm", 20, height - 20);
}
