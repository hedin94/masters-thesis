class PushData {
  Color[] colors;
  float[] weights;

  PushData() {
    colors = new Color[9];
    weights = new float[9];
  }

  PushData(Color[] c, float[] w) {
    colors = c;
    weights = w;
  }

  Color getColor(int x, int y) {
    return colors[3*y + x];
  }

  float weight(int x, int y) {
    return weights[3*y + x];
  }
}
