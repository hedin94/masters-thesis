String toS(color c) {
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
            setWeight(x, y, 0.0f);
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

    //for (int x=0; x<width(); x++) { 
    //  int xOff = 2*x;

    //if ((x>0 && higher.valid(xOff-1)) || higher.valid(xOff) || higher.valid(xOff+1) || (x<width()-1 && higher.valid(xOff+2))) 
    //  markValid(x);
    //else
    //  markInvalid(x);
    //}
  }

  ImagePyramid(Image image, ImagePyramid higher, float weights[]) {
    this.image = image;
    this.higher = higher;
    this.weights = weights;
    pixelFlags = new byte[width()*height()];

    //for (int x=0; x<width(); x++) { 
    //  int xOff = 2*x;

    //  if ((x>0 && higher.valid(xOff-1)) || higher.valid(xOff) || higher.valid(xOff+1) || (x<width()-1 && higher.valid(xOff+2))) 
    //    markValid(x);
    //  else
    //    markInvalid(x);
    //}
  }

  int width() { 
    return image.w;
  }

  int height() { 
    return image.h;
  }

  float getWeight(int x, int y) {
    //println("(" + x + ", " + y + ") " + width() + ", " + height());
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
        //int ix0 = max(0, min(xOff-1, width()-4));
        //int ix1 = min(ix0 + 1, width()-1);
        //int ix2 = min(ix0 + 2, width()-1);
        //int ix3 = min(ix0 + 3, width()-1);

        //int iy0 = max(0, min(yOff-1, height()-4));
        //int iy1 = min(iy0 + 1, height()-1);
        //int iy2 = min(iy0 + 2, height()-1);
        //int iy3 = min(iy0 + 3, height()-1);

        int ix0 = xOff-1;
        int ix1 = ix0 + 1;
        int ix2 = ix0 + 2;
        int ix3 = ix0 + 3;

        int iy0 = yOff-1;
        int iy1 = iy0 + 1;
        int iy2 = iy0 + 2;
        int iy3 = iy0 + 3;

        // Colors
        Color c10 = iy0 >= 0 ? new Color(image.get(ix1, iy0)) : new Color();
        Color c20 = iy0 >= 0 ? new Color(image.get(ix2, iy0)) : new Color();

        Color c01 = ix0 >=0 ? new Color(image.get(ix0, iy1)) : new Color();
        Color c11 = new Color(image.get(ix1, iy1));
        Color c21 = new Color(image.get(ix2, iy1));
        Color c31 = ix3 < width() ? new Color(image.get(ix3, iy1)) : new Color();

        Color c02 = ix0 >= 0 ? new Color(image.get(ix0, iy2)) : new Color();
        Color c12 = new Color(image.get(ix1, iy2));
        Color c22 = new Color(image.get(ix2, iy2));
        Color c32 = ix3 < width() ? new Color(image.get(ix3, iy2)) : new Color();

        Color c13 = iy3 < height() ? new Color(image.get(ix1, iy3)) : new Color();
        Color c23 = iy3 < height() ? new Color(image.get(ix2, iy3)) : new Color();

        // Weights
        float w10 = iy0 >= 0 ? hPull[0]*min(getWeight(ix1, iy0), 1) : 0;
        float w20 = iy0 >= 0 ? hPull[0]*min(getWeight(ix2, iy0), 1) : 0;

        float w01 = ix0 >= 0 ? hPull[0]*min(getWeight(ix0, iy1), 1) : 0;
        float w11 = hPull[1]*min(getWeight(ix1, iy1), 1);
        float w21 = hPull[2]*min(getWeight(ix2, iy1), 1);
        float w31 = ix3 < width() ? hPull[3]*min(getWeight(ix3, iy1), 1) : 0;

        float w02 = ix0 >= 0 ? hPull[0]*min(getWeight(ix0, iy2), 1) : 0;
        float w12 = hPull[1]*min(getWeight(ix1, iy2), 1);
        float w22 = hPull[2]*min(getWeight(ix2, iy2), 1);
        float w32 = ix3 < width() ? hPull[3]*min(getWeight(ix3, iy2), 1) : 0;

        float w13 = iy3 < height() ? hPull[3]*min(getWeight(ix1, iy3), 1) : 0;
        float w23 = iy3 < height() ? hPull[3]*min(getWeight(ix2, iy3), 1) : 0;

        float wSum = w10 + w20 + w01 + w11 + w21 + w31 + w02 + w12 + w22 + w32 + w13 + w23;
        if (wSum == 0) {
          newImage.set(x, y, new Color());
          newWeights[(width()/2)*y + x] = 0.0f;
          continue;
        }

        Color c = new Color();
        c.addInto(c10.mult(w10)); 
        c.addInto(c20.mult(w20));

        c.addInto(c01.mult(w01)); 
        c.addInto(c11.mult(w11));
        c.addInto(c21.mult(w21)); 
        c.addInto(c31.mult(w31));

        c.addInto(c02.mult(w02)); 
        c.addInto(c12.mult(w12));
        c.addInto(c22.mult(w22)); 
        c.addInto(c32.mult(w32));

        c.addInto(c13.mult(w13));
        c.addInto(c23.mult(w23));

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

        // Indices
        //int ix0 = max(0, min(x-1, width()-3));
        //int ix1 = min(ix0 + 1, width()-1);
        //int ix2 = min(ix0 + 2, width()-1);

        //int iy0 = max(0, min(y-1, height()-3));
        //int iy1 = min(iy0 + 1, height()-1);
        //int iy2 = min(iy0 + 2, height()-1);

        //int ix0 = x-1;
        //int ix1 = ix0 + 1;
        //int ix2 = ix0 + 2;

        //int iy0 = y-1;
        //int iy1 = iy0 + 1;
        //int iy2 = iy0 + 2;

        //// Colors
        //Color x10 = iy0 >= 0 ? new Color(image.get(ix1, iy0)) : new Color();
        //Color x01 = ix0 >= 0 ? new Color(image.get(ix0, iy1)) : new Color();
        //Color x11 = new Color(image.get(ix1, iy1));
        //Color x21 = ix2 < width() ? new Color(image.get(ix2, iy1)) : new Color();
        //Color x12 = iy2 < height() ? new Color(image.get(ix1, iy2)) : new Color();

        //// Weights
        //float tw10 = iy0 >= 0 ? hPush[0]*min(getWeight(ix1, iy0), 1) : 0;
        //float tw01 = ix0 >= 0 ? hPush[0]*min(getWeight(ix0, iy1), 1) : 0;
        //float tw11 = hPush[1]*min(getWeight(ix1, iy1), 1);
        //float tw21 = ix2 < width() ? hPush[2]*min(getWeight(ix2, iy1), 1) : 0;
        //float tw12 = iy2 < height() ? hPush[2]*min(getWeight(ix1, iy2), 1) : 0;

        //float tw = tw10 + tw01 + tw11 + tw21 + tw12;

        //Color tx = new Color();
        //tx.addInto(x10.mult(tw10));
        //tx.addInto(x01.mult(tw01));
        //tx.addInto(x11.mult(tw11));
        //tx.addInto(x21.mult(tw21));
        //tx.addInto(x12.mult(tw12));
        //tx.multInto(1.0f/tw);
        PushData data = getPushData(x, y);

        float tw00 = hPush[0]*min(data.weight(1, 1), 1) + hPush[1]*min(data.weight(0, 1), 1) + hPush[2]*min(data.weight(1, 0), 1) + hPush[3]*min(data.weight(0, 0), 1);
        float tw10 = hPush[0]*min(data.weight(1, 1), 1) + hPush[1]*min(data.weight(1, 0), 1) + hPush[2]*min(data.weight(2, 1), 1) + hPush[3]*min(data.weight(2, 0), 1);
        float tw01 = hPush[0]*min(data.weight(1, 1), 1) + hPush[1]*min(data.weight(0, 1), 1) + hPush[2]*min(data.weight(1, 2), 1) + hPush[3]*min(data.weight(0, 2), 1);
        float tw11 = hPush[0]*min(data.weight(1, 1), 1) + hPush[1]*min(data.weight(1, 2), 1) + hPush[2]*min(data.weight(2, 1), 1) + hPush[3]*min(data.weight(2, 2), 1);

        Color tx00 = new Color();
        tx00.addInto(data.getColor(1, 1).mult(hPush[0]*min(data.weight(1, 1), 1)));
        tx00.addInto(data.getColor(0, 1).mult(hPush[1]*min(data.weight(0, 1), 1)));
        tx00.addInto(data.getColor(1, 0).mult(hPush[2]*min(data.weight(1, 0), 1)));
        tx00.addInto(data.getColor(0, 0).mult(hPush[3]*min(data.weight(0, 0), 1)));
        tx00.multInto(1.0f/tw00);

        Color tx10 = new Color();
        tx10.addInto(data.getColor(1, 1).mult(hPush[0]*min(data.weight(1, 1), 1)));
        tx10.addInto(data.getColor(1, 0).mult(hPush[1]*min(data.weight(1, 0), 1)));
        tx10.addInto(data.getColor(2, 1).mult(hPush[2]*min(data.weight(2, 1), 1)));
        tx10.addInto(data.getColor(2, 0).mult(hPush[3]*min(data.weight(2, 0), 1)));
        tx10.multInto(1.0f/tw10);

        Color tx01 = new Color();
        tx01.addInto(data.getColor(1, 1).mult(hPush[0]*min(data.weight(1, 1), 1)));
        tx01.addInto(data.getColor(0, 1).mult(hPush[1]*min(data.weight(0, 1), 1)));
        tx01.addInto(data.getColor(1, 2).mult(hPush[2]*min(data.weight(1, 2), 1)));
        tx01.addInto(data.getColor(0, 2).mult(hPush[3]*min(data.weight(0, 2), 1)));
        tx01.multInto(1.0f/tw01);

        Color tx11 = new Color();
        tx11.addInto(data.getColor(1, 1).mult(hPush[0]*min(data.weight(1, 1), 1)));
        tx11.addInto(data.getColor(1, 2).mult(hPush[1]*min(data.weight(1, 2), 1)));
        tx11.addInto(data.getColor(2, 1).mult(hPush[2]*min(data.weight(2, 1), 1)));
        tx11.addInto(data.getColor(2, 2).mult(hPush[3]*min(data.weight(2, 2), 1)));
        tx11.multInto(1.0f/tw11);

        float w00 = min(higher.getWeight(xOff, yOff), 1);
        float w10 = min(higher.getWeight(xOff+1, yOff), 1);
        float w01 = min(higher.getWeight(xOff, yOff+1), 1);
        float w11 = min(higher.getWeight(xOff+1, yOff+1), 1);

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
    int ix0 = x-1;
    int ix1 = ix0 + 1;
    int ix2 = ix0 + 2;

    int iy0 = y-1;
    int iy1 = iy0 + 1;
    int iy2 = iy0 + 2;

    // Colors
    Color x00 = ix0 >= 0 && iy0 >= 0 ? new Color(image.get(ix0, iy0)) : new Color();
    Color x10 = iy0 >= 0 ? new Color(image.get(ix1, iy0)) : new Color();
    Color x20 = ix2 < width() && iy0 >= 0 ? new Color(image.get(ix2, iy0)) : new Color();

    Color x01 = ix0 >= 0 ? new Color(image.get(ix0, iy1)) : new Color();
    Color x11 = new Color(image.get(ix1, iy1));
    Color x21 = ix2 < width() ? new Color(image.get(ix2, iy1)) : new Color();

    Color x02 = ix0 >= 0 && iy2 < height() ? new Color(image.get(ix0, iy2)) : new Color();
    Color x12 = iy2 < height() ? new Color(image.get(ix1, iy2)) : new Color();
    Color x22 = ix2 < width() && iy2 < height() ? new Color(image.get(ix2, iy2)) : new Color();

    // Weights
    float tw00 = ix0 >= 0 && iy0 >= 0 ? hPull[0]*min(getWeight(ix0, iy0), 1) : 0;
    float tw10 = iy0 >= 0 ? hPull[0]*min(getWeight(ix1, iy0), 1) : 0;
    float tw20 = ix2 < width() && iy0 >= 0 ? hPull[0]*min(getWeight(ix2, iy0), 1) : 0;

    float tw01 = ix0 >= 0 ? hPull[0]*min(getWeight(ix0, iy1), 1) : 0;
    float tw11 = hPull[1]*min(getWeight(ix1, iy1), 1);
    float tw21 = ix2 < width() ? hPull[2]*min(getWeight(ix2, iy1), 1) : 0;

    float tw02 = ix0 >= 0 && iy2 < height() ? hPull[0]*min(getWeight(ix0, iy2), 1) : 0;
    float tw12 = iy2 < height() ? hPull[2]*min(getWeight(ix1, iy2), 1) : 0;
    float tw22 = ix2 < width() && iy2 < height() ? hPull[0]*min(getWeight(ix2, iy2), 1) : 0;

    //float tw = tw00+tw10+tw20 + tw01+tw11+tw21 + tw02+tw12+tw22;

    //Color tx = new Color();
    //tx.addInto(x00.mult(tw00));
    //tx.addInto(x10.mult(tw10));
    //tx.addInto(x20.mult(tw20));
    //tx.addInto(x01.mult(tw01));
    //tx.addInto(x11.mult(tw11));
    //tx.addInto(x21.mult(tw21));
    //tx.addInto(x02.mult(tw02));
    //tx.addInto(x12.mult(tw12));
    //tx.addInto(x22.mult(tw22));

    //tx.multInto(1.0f/tw);

    return new PushData(new Color[]{x00, x10, x20, x01, x11, x21, x02, x12, x22}, 
      new float[]{tw00, tw10, tw20, tw01, tw11, tw21, tw02, tw12, tw22});
  }
}
