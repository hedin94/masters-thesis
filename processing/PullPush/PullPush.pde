import java.io.File;

PImage input;
PImage bound;

PImage[] bounds;
float[] thresholds;
PImage avgBound;

float threshold = 0.05;

int pixelFlags[];
int border = 2;

float hPull[];
float hPush[];

String datadir = "data/";

ImagePyramid pyramid;

boolean glowEffect = false;

void settings() {
  input = loadImage("woman_input.jpg");
  size(2*input.width, input.height);
}

void setup() {
  String filename = dataPath("");
  File f = new File(filename);
  if (f.exists()) {
    println("Deleting " + filename);
    f.delete();
  }

  bound = loadImage("woman_bound.png");
  //bound = input.copy();
  //bound.filter(THRESHOLD, 0.01);

  //bounds = new PImage[5];
  //thresholds = new float[5];

  //thresholds[0] = 0.5;
  //thresholds[1] = 0.25;
  //thresholds[2] = 0.125;
  //thresholds[3] = 0.0625;
  //thresholds[4] = 0.03125;

  //for (int i=0; i<5; i++) {
  //  bounds[i] = input.copy();
  //  bounds[i].filter(THRESHOLD, thresholds[i]);
  //  bounds[i].save(datadir + "bound" + i + ".png");
  //}

  //avgBound = averageBound();
  //avgBound.save(datadir + "avgBound.png");
  //PImage avgCopy = avgBound.copy();
  //avgCopy.filter(THRESHOLD, 0.01);
  //avgCopy.save(datadir + "bound.png");
  //bound = avgCopy;
  
  //surface.setResizable(true);
  //surface.setSize(width=input.width*2, height=input.height);

  gaussPullFilter();

  hPush = new float[4];
  hPush[0] = 9.0f;
  hPush[1] = 3.0f;
  hPush[2] = 3.0f;
  hPush[3] = 1.0f; 

  pyramid = new ImagePyramid(input, null);
  pyramid.pull();

  int i = 0;
  ImagePyramid cur = pyramid;

  while (true) {
    cur.image.save(datadir + "pull" + i++ + ".png");
    if (cur.lower == null) break;
    cur = cur.lower;
  }

  pyramid.push();
  cur = pyramid;

  i--;
  while (true) {
    cur.image.save(datadir + "push" + i-- + ".png");
    if (cur.lower == null) break;
    cur = cur.lower;
  }

  PImage res = pyramid.image.image();
  if (glowEffect) res.filter(DILATE);
  res.save("output.png");
  println("DONE");
  noLoop();
}

void draw() {
  PImage image = input.copy(); 
  //image.filter(THRESHOLD, 0.1);
  image(image, 0, 0);

  //pyramid.image.image().filter(DILATE);
  image(pyramid.image.image(), input.width, 0);
  //filter(DILATE);
  //image(avgBound, 0, 0);
  //avgBound.filter(THRESHOLD, 0.01);
  //image(avgBound, input.width, 0);
}

PImage stretchedImage(PImage img, int y) {
  PImage s = createImage(img.width, y, RGB);
  for (int i=0; i<y; i++) {
    for (int j=0; j<img.width; j++) {
      s.set(j, i, img.get(j, 0));
    }
  }
  return s;
}

PImage combine(PImage a, PImage b) {
  PImage image = createImage(a.width, 2*a.height, RGB);

  for (int y=0; y<a.height; y++)
    for (int x=0; x<a.width; x++)
      image.set(x, y, a.get(x, y));

  for (int y=0; y<b.height; y++)
    for (int x=0; x<a.width; x++)
      image.set(x, a.height+y, b.get(x, y));

  return image;
}

void boxPullFilter() {
  hPull = new float[5];
  hPull[0] = hPull[3] = hPull[1] = hPull[2] = hPull[4] = 1.0f;
}

void gaussPullFilter() {
  hPull = new float[5];
  hPull[0] = hPull[3] = 2.0f;
  hPull[1] = hPull[2] = 4.0f; 
  hPull[4] = 1.0f;
}

PImage averageBound() {
  Image res = new Image(bounds[0].width, bounds[0].height);

  for (int i=0; i<5; i++)
    res = res.add(new Image(bounds[i]));

  res = res.mult(1.0f/5.0f);
  return res.image();
}
