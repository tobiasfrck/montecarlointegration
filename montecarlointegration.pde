FloatList yVals = new FloatList();

float intervallStart = 2f;
float intervallEnd = 5f;

int n = 10;

boolean showMonteCarlo = false;

public void settings() {
  size(1000, 1000);
}

void setup() {
  generateNewImage();
}

void draw() {
  
}
void generateNewImage() {
    background(0);
    calculateYValues();
    stretchGraph();
    for(int i = 0; i<2;i++) {
      filter(BLUR);
      strokeWeight(1);
      drawGraph();
    }

    if(showMonteCarlo) {
      calculateYValues();
      if(n>=100000) {
        strokeWeight(1);
      } else if(n>=10000) {
        strokeWeight(3.5f);
      } else {
        strokeWeight(8);
      }
      monteCarloIntegration();
      fill(255);
      textSize(32);
      text("Monte Carlo Integration",10,32);
      text("n: "+n,10,64);
    }
}

void keyPressed() {
  if(key == ' ') {
    generateNewImage();
  }

  if(key == 'm') {
    showMonteCarlo = !showMonteCarlo;
    generateNewImage();
  }

  if(keyCode == LEFT) {
    if(n<=10) {
      n = 10;
    } else {
      n/=10;
    }
    generateNewImage();
  }

  if(keyCode == RIGHT) {
    n*=10;
    generateNewImage();
  }
}

void monteCarloIntegration() {
  float area = 0;
  float x;
  float y;
  for(int i = 0; i<n;i++) {
    x = random(intervallStart,intervallEnd);
    y = random(0,yVals.max());
    if(y<=f(x)) {
      stroke(#00FF00);
      point(Remap(x,intervallStart,intervallEnd,0,width),height-(Remap(y,0,yVals.max(),0,height)));
      area++;
    } else {
      stroke(#FF0000);
      point(Remap(x,intervallStart,intervallEnd,0,width),height-(Remap(y,0,yVals.max(),0,height)));
    }
  }
  textSize(32);
  text("Area: "+area/n*(intervallEnd-intervallStart)*yVals.max(),10,98);
  text("Acutal Area: 39.0",10,130);
  println("Area: "+area/n*(intervallEnd-intervallStart)*yVals.max());
}

void stretchGraph() {
  float ymax = yVals.max();
  float ymin = 0;
  for(int i = 0; i<yVals.size();i++) {
    yVals.set(i,Remap(yVals.get(i),ymin,ymax,0,height));
  }
}

void drawGraph() {
  stroke(#FFFFFF);
  for(int i = 0; i<width;i++) {
    if(yVals.get(i)>=0) {
      point(i,height-(yVals.get(i)));
    }
  }
}

void calculateYValues() {
 yVals.clear();
 for(int i = 0; i<width;i++) {
  yVals.append(f(Remap(i,0,width,intervallStart,intervallEnd)));
 }
}

float f(float x) {
  return x*x;
  //return -0.5f+sin(2*sin(2*sin(2*sin(x*.75f))));
}

float Remap (float value, float from1, float to1, float from2, float to2) {
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
}
