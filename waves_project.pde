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
PFont font1;
ControlFont myFont;
boolean stateBPSK = false;
boolean stateQPSK = false;
boolean state16QAM = false;
boolean stateVectorB = false;
boolean stateVectorSum = false;
boolean dragA = false;
boolean dragB = false;

void setup() {
  //printArray(PFont.list());
  size(1080, 620);
  background(200);
  font1 = createFont("ArialMT", 12);
  myFont = new ControlFont(font1);
  cp5 = new ControlP5(this);
  checkBox = cp5.addCheckBox("checkBox")
    .setPosition(20, 535)
    .setSize(30, 30)
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
     t.getCaptionLabel().setFont(font1);
   }
}

void draw() {
  drawCoordinatePlane();
  drawVector(pointA_x, pointA_y, color(255, 0, 0));
  float amplitude = distanceTwoPoints(270, 270, pointA_x, pointA_y) * 1 / 250;
  float shift = -atan(((float)(pointA_y - 270)) / ((float)(pointA_x - 270)));
  if (pointA_x < 270) shift += Math.PI;
  drawWave(amplitude, shift, color(255, 0, 0));
  
  float amplitudeB = 0;
  float shiftB = 0;
  if (stateVectorB) {
    drawVector(pointB_x, pointB_y, color(0, 0, 255));
    amplitudeB = distanceTwoPoints(270, 270, pointB_x, pointB_y) * 1 / 250;
    shiftB = -atan(((float)(pointB_y - 270)) / ((float)(pointB_x - 270)));
    if (pointB_x < 270) shiftB += Math.PI;
    drawWave(amplitudeB, shiftB, color(0, 0, 255));
  }
  
  if (stateVectorSum) {
    drawSumWave(amplitude, shift, amplitudeB, shiftB, color(0, 255, 0));
  }
  
  fill(0);
  textSize(30);
  text("Amplitude A: " + Math.round(amplitude * 1000.0) / 1000.0, 560, 560);
  text("Shift A: " + Math.round(shift * 1000.0) / 1000.0 + " radians", 800, 560);
  if (stateVectorB) {
    text("Amplitude B: " + Math.round(amplitudeB * 1000.0) / 1000.0, 560, 600);
    text("Shift B: " + Math.round(shiftB * 1000.0) / 1000.0 + " radians", 800, 600);  
  }
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
  line(560, 270, 1060, 270);
  fill(0);
  triangle(520, 270, 510, 265, 510, 275);
  triangle(270, 20, 265, 30, 275, 30);
  triangle(20, 270, 30, 265, 30, 275);
  triangle(270, 520, 265, 510, 275, 510);
  textSize(15);
  text("0", 260, 285);
  text("0.2", 309, 285);
  text("0.4", 363, 285);
  text("0.6", 417, 285);
  text("0.8", 471, 285);
  
  text("0.2", 250, 231);
  text("0.4", 250, 177);
  text("0.6", 250, 123);
  text("0.8", 250, 69);
  
  text("0.2", 250, 329);
  text("0.4", 250, 378);
  text("0.6", 250, 427);
  text("0.8", 250, 481);
  
  text("0.2", 206, 285);
  text("0.4", 153, 285);
  text("0.6", 103, 285);
  text("0.8", 53, 285);
  
  text("0", 550, 285);
  text("0.2", 540, 231);
  text("0.4", 540, 177);
  text("0.6", 540, 123);
  text("0.8", 540, 69);
  
  text("-0.2", 535, 329);
  text("-0.4", 535, 378);
  text("-0.6", 535, 427);
  text("-0.8", 535, 481);
  
  text("90", 675, 285);
  text("180", 805, 285);
  text("270", 935, 285);
  text("360", 1035, 285);
  
  if (stateBPSK) drawBPSK();
  if (stateQPSK) drawQPSK();
  if (state16QAM) draw16QAM();
}

void drawPoint(int x, int y, color c) {
  stroke(0);
  strokeWeight(1);
  fill(c);
  circle(x, y, 10);
}

void drawVector(int x, int y, color c) {
  strokeWeight(1.5);
  stroke(c);
  line(270, 270, x, y);
  drawPoint(x, y, c);
}

void drawWave(float A, float shift, color c) { // shift is in radians
  strokeWeight(0);
  fill(c);
  for (int x = 0; x < 360; x++) { // x is in degrees, so we need to convert them to radians
    float y = A * sin(((float)x * 2 * (float)Math.PI) / 360 + shift);
    float i = 560 + ((float)x / 360) * 500;
    float j = 20 + 500 - ((y + 1) / 2) * 500;
    if (withinRightCoordinatePlane((int)i, (int)j)) circle(i, j, 5);
  }
}

void drawSumWave (float A1, float shift1, float A2, float shift2, color c) {
  strokeWeight(0);
  fill(c);
  for (int x = 0; x < 360; x++) {
    float y = A1 * sin(((float)x * 2 * (float)Math.PI) / 360 + shift1) + A2 * sin(((float)x * 2 * (float)Math.PI) / 360 + shift2);
    float i = 560 + ((float)x / 360) * 500;
    float j = 20 + 500 - ((y + 1) / 2) * 500;
    if (withinRightCoordinatePlane((int)i, (int)j)) circle(i, j, 5);
  }
}

float distanceTwoPoints(int x1, int y1, int x2, int y2) {
  float res;
  res = (float)Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
  return res;
}

void mouseDragged() {
  if (!dragB && distanceTwoPoints(pointA_x, pointA_y, mouseX, mouseY) <= 15 && withinLeftCoordinatePlane()) {
    pointA_x = mouseX;
    pointA_y = mouseY;
    dragA = true;
  }
  if (!dragA && stateVectorB && distanceTwoPoints(pointB_x, pointB_y, mouseX, mouseY) <= 15 && withinLeftCoordinatePlane()) {
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

boolean withinLeftCoordinatePlane() {
  if (mouseX < 515 && mouseX > 25 && mouseY < 515 && mouseY > 25) return true;
  return false;
}

boolean withinRightCoordinatePlane(int x, int y) {
  if (x < 1060 && x > 560 && y < 520 && y > 20) return true;
  return false;
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
  fill(255);
  circle(370, 170, 20);
  circle(370, 370, 20);
  circle(170, 370, 20);
  circle(170, 170, 20);
  fill(0);
  textSize(15);
  text("00", 363, 175);
  text("01", 363, 375);
  text("11", 163, 375);
  text("10", 163, 175);
}

void draw16QAM() {
  fill(255);
  circle(120, 120, 20);
  circle(220, 120, 20);
  circle(320, 120, 20);
  circle(420, 120, 20);
  circle(120, 220, 20);
  circle(220, 220, 20);
  circle(320, 220, 20);
  circle(420, 220, 20);
  circle(120, 320, 20);
  circle(220, 320, 20);
  circle(320, 320, 20);
  circle(420, 320, 20);
  circle(120, 420, 20);
  circle(220, 420, 20);
  circle(320, 420, 20);
  circle(420, 420, 20);
  fill(0);
  textSize(10);
  text("0000", 110, 423);
  text("0001", 110, 323);
  text("0011", 110, 223);
  text("0010", 110, 123);
  text("0100", 210, 423);
  text("0101", 210, 323);
  text("0111", 210, 223);
  text("0110", 210, 123);
  text("1100", 310, 423);
  text("1101", 310, 323);
  text("1111", 310, 223);
  text("1110", 310, 123);
  text("1000", 410, 423);
  text("1001", 410, 323);
  text("1011", 410, 223);
  text("1010", 410, 123);
}
