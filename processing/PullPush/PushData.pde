int[] indices = new int[]{1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 2, 1, 2, 0, 
  1, 1, 0, 1, 1, 2, 0, 2, 1, 1, 1, 2, 2, 1, 2, 2};

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

  float weightSum(int x, int y) {
    float sum = 0;

    for (int i=0; i<4; i++) {
      int offset = ((((y << 1) + x) << 2) + i) << 1;
      int i0 = indices[offset];
      int i1 = indices[offset + 1];
      sum += hPush[i]*min(weight(i0, i1), 1.0f);
    }
    
    return sum;
  };

  Color colorSum(int x, int y) {
    Color sum = new Color();
    
    for (int i=0; i<4; i++) {
      int offset = ((((y << 1) + x) << 2) + i) << 1;
      int i0 = indices[offset];
      int i1 = indices[offset + 1];
      sum.addInto(getColor(i0, i1).mult(hPush[i]*min(weight(i0, i1), 1.0f)));
    }
    
    return sum;
  };
}
