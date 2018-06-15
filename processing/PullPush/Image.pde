class Image {
  ArrayList<Color> colors;
  int w;
  int h;

  Image(int w, int h) {
    this.w = w;
    this.h = h;

    colors = new ArrayList<Color>();
    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        colors.add(new Color());
  }

  Image(Image other) {
    w = other.w;
    h = other.h;

    colors = new ArrayList<Color>();
    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        colors.add(new Color(other.get(x, y)));
  }

  Image(PImage img) {
    w = img.width;
    h = img.height;

    colors = new ArrayList<Color>();
    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        colors.add(new Color(img.get(x, y)));
  }

  void save(String filename) {
    PImage img = createImage(w, h, RGB);
    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        img.set(x, y, get(x, y).toColor());

    img.save(filename);
  }

  Color get(int x, int y) {
    return colors.get(w*y + x);
  }

  void set(int x, int y, Color c) {
    colors.set(w*y + x, c);
  }

  void set(int x, int y, color c) {
    set(x, y, new Color(c));
  }

  PImage image() {
    PImage img = createImage(w, h, RGB);
    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        img.set(x, y, get(x, y).toColor());

    return img;
  }

  Image add(Image img) {
    Image res = new Image(w, h);

    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        res.set(x, y, get(x, y).add(img.get(x, y)));
    return res;
  }

  Image mult(float s) {
    Image res = new Image(w, h);
    
    for (int y=0; y<h; y++)
      for (int x=0; x<w; x++)
        res.set(x, y, get(x, y).mult(s));
    return res;
  }
}
