import processing.video.*;
Capture cam;
PImage img;
char k = 'n';
float 
  targetH = 0.195555555, targetS = 0.41208792, targetB = 0.7137255, 
  importanceH = 19.96875, importanceS = 0.84375, importanceB = 0.375, 
  limiar = 0.25;

void setup() {
  size(640, 480);
  colorMode(HSB, 1);
  cam = new Capture(this, 640, 480, Capture.list()[0]);
  cam.start();
  img = createImage(640, 480, RGB);
}      

void draw() {
  if (cam.available()) cam.read();
  cam.loadPixels();
  img.loadPixels();

  for (int i = 0; i < cam.pixels.length; i++) {
    color c = cam.pixels[i];
    
    //distancias ao quadrado, vezes a importancia que queremos que tenham na equação
    float distH = pow( hue(c) - targetH, 2) * importanceH, 
      distS = pow(saturation(c) - targetS, 2) * importanceS, 
      distB = pow(brightness(c) - targetB, 2) * importanceB;
    //raiz quadrada da soma das distancias 
    float dist = sqrt(distH + distS + distB);

    if (dist < limiar) img.pixels[i] = color(0, 0, 1);
    else img.pixels[i] = color(0, 0, 0);
  }

  img.updatePixels();
  image(img, 0, 0);

  //Definir importancia de cada variavel com o rato
  if (k == 'h' ) importanceH = map(mouseX, 0, width, 0, 20);
  else if (k == 's' ) importanceS = map(mouseX, 0, width, 0, 20);
  else if (k == 'b' ) importanceB = map(mouseX, 0, width, 0, 20);
  else if (k == 'l') limiar =  map(mouseX, 0, width, 0, 20);
  println("");
  println("target:", targetH, targetS, targetB);
  println("target importance:", importanceH, importanceS, importanceB);
  println("limiar:", limiar);
}

void mousePressed() {
  color c =  cam.get(mouseX, mouseY);
  targetH = hue(c);
  targetS = saturation(c);
  targetB = brightness(c);
}

void keyPressed() {
  k = key;
  println(key);
}
