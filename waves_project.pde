// This project is inspired by the GeoGebra files made by Ben Sparks
// The files were showcased in this YouTube video: https://youtu.be/To7Ll5AGboI?si=t90DP0Sp8_WSOY_n
// The video itself inspired me to make this project
// The project uses ControlP5 2.2.6 library for GUI objects

import controlP5.*;

int pointA_x = 420;
int pointA_y = 270;
int pointB_x = 270;
int pointB_y = 120;
ControlP5 cp5;
CheckBox checkBox;
PFont tempFont;
ControlFont myFont;
boolean stateBPSK = false;
boolean stateQPSK = false;
boolean state16QAM = false;
boolean stateVectorB = false;
boolean stateVectorSum = false;
boolean dragA = false;
boolean dragB = false;

void setup() {
  size(1080, 620);
  background(200);
  tempFont = createFont("ArialMT", 12);
  myFont = new ControlFont(tempFont);
  cp5 = new ControlP5(this);
  checkBox = cp5.addCheckBox("checkBox")
    .setPosition(20, 535)
    .setSize(30,30)
    .setItemsPerRow(3)
    .setColorBackground(color(80, 120, 200))
    .setColorForeground(color(0, 120, 255))
    .setColorActive(color(150, 100, 230))
    .setColorLabel(color(0))
    .setSpacingColumn(150)
    .setSpacingRow(10)
    .addItem("Show BPSK", 1)
    .addItem("Show QPSK", 2)
    .addItem("Show 16QAM", 3)
    .addItem("Show Vector B", 4)
    .addItem("Show Sum Vector", 5);
    
    for (Toggle t: checkBox.getItems()) {
      t.getCaptionLabel().setFont(myFont);
    }
}

void draw() {
  drawCoordinatePlane();
  float ampA = 0;
  float shiftA = 0;
  float ampB = 0;
  float shiftB = 0;
  drawVector(pointA_x, pointA_y, color(255, 0, 0));
  ampA = distanceBetweenTwoPoints(270, 270, pointA_x, pointA_y) / 250;
  if (pointA_y != 270) shiftA = asin((270 - pointA_y)/(distanceBetweenTwoPoints(270, 270, pointA_x, pointA_y)));
  if (pointA_x < 270 && shiftA > 0) shiftA = PI - shiftA;
  if (pointA_x < 270 && shiftA <= 0) shiftA = -PI - shiftA;
  drawWave(ampA, shiftA, 0, 0, color(255, 0, 0));
  if (stateVectorB) {
    ampB = distanceBetweenTwoPoints(270, 270, pointB_x, pointB_y) / 250;
    if (pointB_y != 270) shiftB = asin((270 - pointB_y)/(distanceBetweenTwoPoints(270, 270, pointB_x, pointB_y)));
    if (pointB_x < 270 && shiftB > 0) shiftB = PI - shiftB;
    if (pointB_x < 270 && shiftB <= 0) shiftB = -PI - shiftB;
    drawVector(pointB_x, pointB_y, color(0, 0, 255));
    drawWave(ampB, shiftB, 0, 0, color(0, 0, 255));
  }
  if (stateVectorSum) {
    drawWave(ampA, shiftA, ampB, shiftB, color(0, 255, 0));
  }
  fill(0);
  textSize(30);
  text("Amplitude A: " + Math.round(ampA * 1000.0) / 1000.0, 560, 560);
  text("Shift A: " + Math.round(shiftA * 1000.0) / 1000.0 + " radians", 800, 560);
  if (stateVectorB) {
    text("Amplitude B: " + Math.round(ampB * 1000.0) / 1000.0, 560, 600);
    text("Shift B: " + Math.round(shiftB * 1000.0) / 1000.0 + " radians", 800, 600);  
  }
}

void mouseDragged() {
  if (!dragB && distanceBetweenTwoPoints(pointA_x, pointA_y, mouseX, mouseY) <= 15 && withinCoordinatePlane(mouseX, mouseY, 0)) {
    pointA_x = mouseX;
    pointA_y = mouseY;
    dragA = true;
  }
  if (!dragA && distanceBetweenTwoPoints(pointB_x, pointB_y, mouseX, mouseY) <= 15 && withinCoordinatePlane(mouseX, mouseY, 0)) {
    pointB_x = mouseX;
    pointB_y = mouseY;
    dragB = true;
  }
}

void mousePressed() {
  stateBPSK = checkBox.getState("Show BPSK");
  stateQPSK = checkBox.getState("Show QPSK");
  state16QAM = checkBox.getState("Show 16QAM");
  stateVectorB = checkBox.getState("Show Vector B");
  stateVectorSum = checkBox.getState("Show Sum Vector");
}

void mouseReleased() {
  dragA = false;
  dragB = false;
}

void drawWave(float amp1, float shift1, float amp2, float shift2, color c) {
  strokeWeight(0);
  fill(c);
  for (float x = 0; x < 2.0 * PI; x += 2.0 * PI / 360.0) {
    float y = amp1 * sin(x + shift1) + amp2 * sin(x + shift2);
    float i = 560 + (x / (2 * PI)) * 500;
    float j = 20 + (1 - y) * 250;
    if (withinCoordinatePlane((int)i, (int)j, 1)) circle(i, j, 5);
  }
}

void drawVector(int x, int y, color c) {
  strokeWeight(1.5);
  stroke(c);
  line(270, 270, x, y);
  drawPoint(x, y, c);
}

void drawPoint(int x, int y, color c) {
  stroke(0);
  strokeWeight(1);
  fill(c);
  circle(x, y, 10);
}

void drawCoordinatePlane() {
  background(200);
  stroke(0);
  fill(255);
  strokeWeight(2);
  rect(20, 20, 500, 500);
  rect(560, 20, 500, 500);
  strokeWeight(1);
  line(270, 20, 270, 520);
  line(20, 270, 520, 270);
  fill(0);
  triangle(520, 270, 510, 265, 510, 275);
  triangle(270, 20, 265, 30, 275, 30);
  triangle(20, 270, 30, 265, 30, 275);
  triangle(270, 520, 265, 510, 275, 510);
  textSize(15);
  
  for (int i = -4; i <= 4; i++) {
    if (i == 0) continue;
    int x = 270 + i * 50;
    line(x, 275, x, 265);
    text(String.valueOf(Math.abs((float)Math.round((float)i / 5.0 * 10.0) / 10)), x - 9, 285);
  }
  
  for (int i = -4; i <= 4; i++) {
    int y = 270 + i * 50;
    line(265, y, 275, y);
    text(String.valueOf(Math.abs((float)Math.round((float)i / 5.0 * 10.0) / 10)), 250, y - 3);
  }
  
  stroke(240, 240, 255);
  for (int i = 4; i >= -4; i--) {
    int y = 270 - i * 50;
    int x = 539;
    if (i < 0) x -= 5;
    text(String.valueOf((float)Math.round((float)i / 5.0 * 10.0) / 10), x, y - 3);
    line (562, y, 1058, y);
  }
  
  for (int i = 1; i <= 3; i++) {
    int x = 560 + i * 125;
    line (x, 22, x, 518);
    text(String.valueOf(i * 90), x - 5, 285);
  }
  
  stroke(0);
  line(560, 270, 1060, 270);
  
  if (stateBPSK) drawBPSK();
  if (stateQPSK) drawQPSK();
  if (state16QAM) draw16QAM();
}

void drawBPSK() {
  fill(255);
  circle(420, 270, 20);
  circle(120, 270, 20);
  fill(0);
  textSize(20);
  text("1", 416, 276);
  text("0", 116, 276);
}

void drawQPSK() {
  float d = (float)Math.sin(PI/4.0) * 150.0;
  fill(255);
  circle(270 + d, 270 - d, 20);
  circle(270 + d, 270 + d, 20);
  circle(270 - d, 270 + d, 20);
  circle(270 - d, 270 - d, 20);
  fill(0);
  textSize(15);
  text("00", 263 + d, 274 - d);
  text("01", 263 + d, 274 + d);
  text("11", 263 - d, 274 + d);
  text("10", 263 - d, 274 - d);
}

void draw16QAM() {
  float d1 = (float)Math.sin(PI/4.0) * 200.0;
  float d2 = d1 / 3.0;
  fill(255);
  circle(270 - d1, 270 + d1, 20);
  circle(270 - d1, 270 + d2, 20);
  circle(270 - d1, 270 - d2, 20);
  circle(270 - d1, 270 - d1, 20);
  circle(270 - d2, 270 + d1, 20);
  circle(270 - d2, 270 + d2, 20);
  circle(270 - d2, 270 - d2, 20);
  circle(270 - d2, 270 - d1, 20);
  circle(270 + d2, 270 + d1, 20);
  circle(270 + d2, 270 + d2, 20);
  circle(270 + d2, 270 - d2, 20);
  circle(270 + d2, 270 - d1, 20);
  circle(270 + d1, 270 + d1, 20);
  circle(270 + d1, 270 + d2, 20);
  circle(270 + d1, 270 - d2, 20);
  circle(270 + d1, 270 - d1, 20);
  
  fill(0);
  textSize(10);
  text("0000", 260 - d1, 273 + d1);
  text("0001", 260 - d1, 273 + d2);
  text("0011", 260 - d1, 273 - d2);
  text("0010", 260 - d1, 273 - d1);
  text("0100", 260 - d2, 273 + d1);
  text("0101", 260 - d2, 273 + d2);
  text("0111", 260 - d2, 273 - d2);
  text("0110", 260 - d2, 273 - d1);
  text("1100", 260 + d2, 273 + d1);
  text("1101", 260 + d2, 273 + d2);
  text("1111", 260 + d2, 273 - d2);
  text("1110", 260 + d2, 273 - d1);
  text("1000", 260 + d1, 273 + d1);
  text("1001", 260 + d1, 273 + d2);
  text("1011", 260 + d1, 273 - d2);
  text("1010", 260 + d1, 273 - d1);
}

float distanceBetweenTwoPoints(int x1, int y1, int x2, int y2) {
  float res;
  res = (float)Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
  return res;
}

boolean withinCoordinatePlane(int x, int y, int p) { // p = 0 is left coordinate plane, p = 1 is the right one
  int margin = 0;
  if (p == 0) margin = 5;
  int size = 500;
  int xborder = p * 540 + 20 + size - margin;
  int yborder = 20 + size - margin;
  if (x < xborder && x > xborder - size + 2 * margin && y < yborder && y > yborder - size + 2 * margin) {
    return true;
  }
  return false;
}
