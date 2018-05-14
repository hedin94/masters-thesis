enum SamplingType {
  GAUSSIAN, 
    UNIFORM
};

PImage input;
PImage output;
PVector center;
PVector[] samples;
int N = 40000;
String filename = "gradient.png";

SamplingType samplingType = SamplingType.GAUSSIAN;

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
    color c = input.get(int(p.x), int(p.y));
    output.set(int(p.x), int(p.y), c);
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
  int x = 0;
  int y = 0;

  if (samplingType == SamplingType.GAUSSIAN) {
    float r = abs(randomGaussian()) * 0.15625f*input.width;
    float a = random(360);
    x = constrain(round(r*cos(a)), -input.width, input.width) + input.width/2;
    y = constrain(round(r*sin(a)), -input.height, input.height) + input.height/2;
  } else if (samplingType == SamplingType.UNIFORM) {
    x = floor(random(input.width));
    y = floor(random(input.height));
  }
  return new PVector(x, y);
}
