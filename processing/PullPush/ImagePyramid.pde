String toS(color c) { //<>// //<>//
  return "(" + ((c>>16) & 0xFF) + ", " + ((c>>8) & 0xFF) + ", " + (c & 0xFF) + ")";
}


class ImagePyramid {
  ImagePyramid higher = null;
  ImagePyramid lower = null;

  Image image;
  float weights[];
  byte pixelFlags[];

  ImagePyramid(PImage image, ImagePyramid higher) {
    this.image = new Image(image);
    this.higher = higher;
    weights = new float[width()*height()];
    pixelFlags = new byte[width()*height()];

    setWeight(0, 0, 1.0f);

    if (width() == 1) return;

    if (higher != null) return;

    for (int y=0; y<height(); y++) {
      for (int x=0; x<width(); x++) {
        if (bound.get(x, y) == color(0)) { 
          if (glowEffect)
            setWeight(x, y, 0.01f);
          else
            setWeight(x, y, 0.0f);
          markInvalid(x, y);
        } else {
          setWeight(x, y, 1.0f);
          markValid(x, y);
        }
      }
    }
  }

  ImagePyramid(PImage image, ImagePyramid higher, float weights[]) {
    this.image = new Image(image);
    this.higher = higher;
    this.weights = weights;
    pixelFlags = new byte[width()*height()];
  }

  ImagePyramid(Image image, ImagePyramid higher, float weights[]) {
    this.image = image;
    this.higher = higher;
    this.weights = weights;
    pixelFlags = new byte[width()*height()];
  }

  int width() { 
    return image.w;
  }

  int height() { 
    return image.h;
  }

  float getWeight(int x, int y) {
    return weights[width()*y + x];
  }

  void setWeight(int x, int y, float w) {
    weights[width()*y+x] = w;
  }

  void markInvalid(int x, int y) {
    pixelFlags[width()*y + x] &= ~0x01;
  }

  void markValid(int x, int y) {
    pixelFlags[width()*y + x] |= 0x01;
  }

  boolean valid(int x, int y) {
    return (pixelFlags[width()*y + x] & 0x01) == 1;
  }


  /**
   * Pull from *this* to *lower* resolution image.
   */
  void pull() {
    println("==== pull " + width() + " ====");

    Image newImage = new Image(width()/2, height()/2);
    float newWeights[] = new float[(width()/2)*(height()/2)];

    for (int y=0; y<height()/2; y++) {
      for (int x=0; x<width()/2; x++) {
        int xOff = 2*x;
        int yOff = 2*y;

        // Indices
        int ix0 = xOff-1;
        int ix1 = ix0 + 1;
        int ix2 = ix0 + 2;
        int ix3 = ix0 + 3;

        int iy0 = yOff-1;
        int iy1 = iy0 + 1;
        int iy2 = iy0 + 2;
        int iy3 = iy0 + 3;

        // Wrap indices 
        if (ix0 < 0) ix0 = width() - 1;
        if (iy0 < 0) iy0 = height() - 1; 
        if (ix3 >= width()) ix3 = 0;
        if (iy3 >= height()) iy3 = 0;

        // Colors
        Color c00 = new Color(image.get(ix0, iy0));
        Color c10 = new Color(image.get(ix1, iy0));
        Color c20 = new Color(image.get(ix2, iy0));
        Color c30 = new Color(image.get(ix3, iy0));

        Color c01 = new Color(image.get(ix0, iy1));
        Color c11 = new Color(image.get(ix1, iy1));
        Color c21 = new Color(image.get(ix2, iy1));
        Color c31 = new Color(image.get(ix3, iy1));

        Color c02 = new Color(image.get(ix0, iy2));
        Color c12 = new Color(image.get(ix1, iy2));
        Color c22 = new Color(image.get(ix2, iy2));
        Color c32 = new Color(image.get(ix3, iy2));

        Color c03 = new Color(image.get(ix0, iy3));
        Color c13 = new Color(image.get(ix1, iy3));
        Color c23 = new Color(image.get(ix2, iy3));
        Color c33 = new Color(image.get(ix3, iy3));

        // -----------------
        // | 0 | 1 | 1 | 0 |
        // |----------------
        // | 1 | 1 | 1 | 1 |
        // |----------------
        // | 1 | 1 | 1 | 1 |
        // |----------------
        // | 0 | 1 | 1 | 0 |
        // |----------------

        // Weights
        float w00 = hPull[4]*min(getWeight(ix0, iy0), 1.0f);
        float w10 = hPull[0]*min(getWeight(ix1, iy0), 1.0f);
        float w20 = hPull[0]*min(getWeight(ix2, iy0), 1.0f);
        float w30 = hPull[4]*min(getWeight(ix3, iy0), 1.0f);

        float w01 = hPull[0]*min(getWeight(ix0, iy1), 1.0f);
        float w11 = hPull[1]*min(getWeight(ix1, iy1), 1.0f);
        float w21 = hPull[2]*min(getWeight(ix2, iy1), 1.0f);
        float w31 = hPull[3]*min(getWeight(ix3, iy1), 1.0f);

        float w02 = hPull[0]*min(getWeight(ix0, iy2), 1.0f);
        float w12 = hPull[1]*min(getWeight(ix1, iy2), 1.0f);
        float w22 = hPull[2]*min(getWeight(ix2, iy2), 1.0f);
        float w32 = hPull[3]*min(getWeight(ix3, iy2), 1.0f);

        float w03 = hPull[4]*min(getWeight(ix0, iy3), 1.0f);
        float w13 = hPull[3]*min(getWeight(ix1, iy3), 1.0f);
        float w23 = hPull[3]*min(getWeight(ix2, iy3), 1.0f);
        float w33 = hPull[4]*min(getWeight(ix3, iy3), 1.0f);

        //float wSum = w11 + w21 + w12 + w22;  
        //float wSum = w10 + w20 + w01 + w11 + w21 + w31 + w02 + w12 + w22 + w32 + w13 + w23;
        float wSum = w00 + w10 + w20 + w30 + w01 + w11 + w21 + w31 + w02 + w12 + w22 + w32 + w03 + w13 + w23 + w33;
        if (wSum == 0) {
          newImage.set(x, y, new Color());
          newWeights[(width()/2)*y + x] = 0.0f;
          continue;
        }

        Color c = new Color();
        c.addInto(c00.mult(w00)); 
        c.addInto(c10.mult(w10)); 
        c.addInto(c20.mult(w20));
        c.addInto(c30.mult(w30)); 

        c.addInto(c01.mult(w01)); 
        c.addInto(c11.mult(w11));
        c.addInto(c21.mult(w21)); 
        c.addInto(c31.mult(w31));

        c.addInto(c02.mult(w02)); 
        c.addInto(c12.mult(w12));
        c.addInto(c22.mult(w22)); 
        c.addInto(c32.mult(w32));

        c.addInto(c03.mult(w03));
        c.addInto(c13.mult(w13));
        c.addInto(c23.mult(w23));
        c.addInto(c33.mult(w33));

        c.multInto(1.0f/wSum);

        newImage.set(x, y, c);
        newWeights[(width()/2)*y + x] = wSum;
      }
    }

    lower = new ImagePyramid(newImage, this, newWeights);
    if (width() > 2 && height() > 2)
      lower.pull();
  }

  /**
   * Push from *this* to *higher* resolution image.
   */
  void push() {
    if (lower != null)
      lower.push();

    if (higher == null) return;

    println("==== push " + width() + " ====");

    for (int y=0; y<height(); y++) {
      for (int x=0; x<width(); x++) {
        int xOff = 2*x;
        int yOff = 2*y;

        PushData data = getPushData(x, y);

        float tw00 = data.weightSum(0, 0);
        float tw10 = data.weightSum(1, 0);
        float tw01 = data.weightSum(0, 1);
        float tw11 = data.weightSum(1, 1);

        // Up-Left
        Color tx00 = data.colorSum(0, 0);
        tx00.multInto(1.0f/tw00);

        // Up-Right
        Color tx10 = data.colorSum(1, 0);
        tx10.multInto(1.0f/tw10);

        // Down-Left
        Color tx01 = data.colorSum(0, 1);
        tx01.multInto(1.0f/tw01);

        // Down-Right
        Color tx11 = data.colorSum(1, 1);
        tx11.multInto(1.0f/tw11);

        float w00 = min(higher.getWeight(xOff, yOff), 1.0f);
        float w10 = min(higher.getWeight(xOff+1, yOff), 1.0f);
        float w01 = min(higher.getWeight(xOff, yOff+1), 1.0f);
        float w11 = min(higher.getWeight(xOff+1, yOff+1), 1.0f);

        Color c00 = new Color(higher.image.get(xOff, yOff));
        Color c10 = new Color(higher.image.get(xOff+1, yOff));
        Color c01 = new Color(higher.image.get(xOff, yOff+1));
        Color c11 = new Color(higher.image.get(xOff+1, yOff+1));

        Color x00 = tx00.mult(1.0f-w00).addInto(c00.mult(w00));
        Color x10 = tx10.mult(1.0f-w10).addInto(c10.mult(w10));
        Color x01 = tx01.mult(1.0f-w01).addInto(c01.mult(w01));
        Color x11 = tx11.mult(1.0f-w11).addInto(c11.mult(w11));

        higher.image.set(xOff, yOff, x00);
        higher.setWeight(xOff, yOff, tw00*(1.0f-w00) + w00);

        higher.image.set(xOff+1, yOff, x10);
        higher.setWeight(xOff+1, yOff, tw10*(1.0f-w10) + w10);

        higher.image.set(xOff, yOff+1, x01);
        higher.setWeight(xOff, yOff+1, tw01*(1.0f-w01) + w01);

        higher.image.set(xOff+1, yOff+1, x11);
        higher.setWeight(xOff+1, yOff+1, tw11*(1.0f-w11) + w11);
      }
    }
  }

  PushData getPushData(int x, int y) {
    // Indices
    int ix0 = x-1;
    int ix1 = ix0 + 1;
    int ix2 = ix0 + 2;

    int iy0 = y-1;
    int iy1 = iy0 + 1;
    int iy2 = iy0 + 2;

    // Wrap indices
    if (ix0 < 0) ix0 = width() - 1;
    if (iy0 < 0) iy0 = height() - 1;
    if (ix2 >= width()) ix2 = 0;
    if (iy2 >= height()) iy2 = 0;

    // Colors
    Color x00 = new Color(image.get(ix0, iy0));
    Color x10 = new Color(image.get(ix1, iy0));
    Color x20 = new Color(image.get(ix2, iy0));

    Color x01 = new Color(image.get(ix0, iy1));
    Color x11 = new Color(image.get(ix1, iy1));
    Color x21 = new Color(image.get(ix2, iy1));

    Color x02 = new Color(image.get(ix0, iy2));
    Color x12 = new Color(image.get(ix1, iy2));
    Color x22 = new Color(image.get(ix2, iy2));

    // Weights
    float tw00 = hPull[0]*min(getWeight(ix0, iy0), 1.0f);
    float tw10 = hPull[0]*min(getWeight(ix1, iy0), 1.0f);
    float tw20 = hPull[0]*min(getWeight(ix2, iy0), 1.0f);

    float tw01 = hPull[0]*min(getWeight(ix0, iy1), 1.0f);
    float tw11 = hPull[1]*min(getWeight(ix1, iy1), 1.0f);
    float tw21 = hPull[2]*min(getWeight(ix2, iy1), 1.0f);

    float tw02 = hPull[0]*min(getWeight(ix0, iy2), 1.0f);
    float tw12 = hPull[2]*min(getWeight(ix1, iy2), 1.0f);
    float tw22 = hPull[0]*min(getWeight(ix2, iy2), 1.0f);

    return new PushData(new Color[]{x00, x10, x20, x01, x11, x21, x02, x12, x22}, new float[]{tw00, tw10, tw20, tw01, tw11, tw21, tw02, tw12, tw22});
  }
}
