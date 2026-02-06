#include <Servo.h>

Servo myServo;

const int servoPin = 9;
const int trigPin = 10;
const int echoPin = 11;

const int stopDistance = 30; // 🛑 stop servo if object is closer than this (cm)

long duration;
int distance;
int angle = 0;
int step = 1; // direction control

void setup() {
  myServo.attach(servoPin);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
}

void loop() {

  distance = getDistance();

  // 🛑 STOP SERVO if object detected
  if (distance <= stopDistance) {
    myServo.write(angle); // hold position

    // still send data to Processing
    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);

    delay(50); // small delay to reduce jitter
    return;    // exit loop, servo does NOT move
  }

  // 🔄 MOVE SERVO if no object
  angle += step;

  if (angle >= 180) {
    angle = 180;
    step = -1;
  } 
  else if (angle <= 0) {
    angle = 0;
    step = 1;
  }

  myServo.write(angle);

  Serial.print(angle);
  Serial.print(",");
  Serial.println(distance);

  delay(60); // 🐢 slow smooth rotation
}

int getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 30000);
  int dist = duration * 0.034 / 2;

  if (dist == 0 || dist > 300) dist = 300;
  return dist;
}
