import java.io.File;

PImage input;
PImage bound;

float threshold = 0.05;

int pixelFlags[];
int border = 2;

float hPull[];
float hPush[];

String datadir = "data/";

ImagePyramid pyramid;

boolean glowEffect = false;

void settings() {
  input = loadImage("gradient_sampled.png");
  size(2*input.width, input.height);
}

void setup() {
  String filename = dataPath("");
  File f = new File(filename);
  if (f.exists()) {
    println("Deleting " + filename);
    f.delete();
  }

  //bound = loadImage("woman_bound.png");
  bound = input.copy();
  bound.filter(THRESHOLD, 0.01);

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
