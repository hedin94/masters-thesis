class Color {
  float r;
  float g;
  float b;

  Color() { 
    r=0; 
    g=0; 
    b=0;
  }

  //Color(int r, int g, int b) {
  //  this.r = r;
  //  this.g = g;
  //  this.b = b;
  //}
  
  Color(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  Color(color c) {
    r = ((c>>16) & 0xFF);
    g = ((c>>8) & 0xFF);
    b = (c & 0xFF);
  }

  Color(Color c) {
    r = c.r;
    g = c.g;
    b = c.b;
  }

  Color mult(float w) {
    return new Color(r, g, b).multInto(w);
  }

  Color multInto(float w) {
    r *= w;
    g *= w;
    b *= w;
    return this;
  }

  Color add(Color c) {
    return new Color(r, g, b).addInto(c);
  }

  Color addInto(color c) {
    r += (c<<16) & 0xFF;
    g += (c<<8) & 0xFF;
    b += c & 0xFF;
    return this;
  }

  Color addInto(Color c) {
    r += c.r;
    g += c.g;
    b += c.b;
    return this;
  }

  color toColor() {
    int tr = constrain(floor(r), 0, 255);
    int tg = constrain(floor(g), 0, 255);
    int tb = constrain(floor(b), 0, 255);
    return color(tr, tg, tb);
  }

  String toS() {
    return "(" + r + ", " + g + ", " + b + ")";
  }

  Color copy() {
    return new Color(r, g, b);
  }

  boolean check() {
    if (0 > r || 0 > g || 0 > b) 
      return false;
    return true;
  }
}
