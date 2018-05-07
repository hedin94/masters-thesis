PImage input;
PImage output;
PVector center;
PVector[] samples;
int N = 80000;
String filename = "lena.png";

void settings() {
  input = loadImage(filename);
  size(2*input.width, input.height);
}

void setup() {
  output = createImage(input.width, input.height, RGB);
  println(input.width, input.height);

  center = new PVector(1.5f*input.width, 0.5f*input.height);
  image(input, 0, 0);
  image(output, input.width, 0);

  samples = new PVector[N];
  for (int i=0; i<N; i++)
    samples[i] = generate();

  for (PVector p : samples) {
    color c = input.get(int(p.x) + input.width/2, int(p.y) + input.height/2);
    output.set(int(p.x) + input.width/2, int(p.y) + input.height/2, c);
  }
  
  output.updatePixels();
  output.save("sampled.png");
}

void draw() {
  background(0);
  image(input, 0, 0);
  image(output, input.width, 0);
}

PVector generate() {
  float r = abs(randomGaussian()) * 0.15625f*input.width;
  float a = random(360);
  int x = constrain(round(r*cos(a)), -input.width, input.width);
  int y = constrain(round(r*sin(a)), -input.height, input.height);

  return new PVector(x, y);
}
