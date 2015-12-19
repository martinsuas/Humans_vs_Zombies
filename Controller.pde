import java.util.Map;

// Class used to map keys into the game
static class Controller {
  HashMap<Integer, Boolean> map;
  
  Controller() {
    map = new HashMap<Integer, Boolean>();
  }
  
  // Record Key Press
  void recKP(int c) {
    map.put(c, true);
  }
  
  // Record Key Release
  void recKR(int c) {
    map.put(c, false);
  }
  
  // Is Key Press?
  boolean isKP(int c) {
    if (map.get(c) == null)
      return false;
    return map.get(c);
  }
  
  // Is Key Release?
  boolean isKR(int c) {
    if (map.get(c) == null)
      return false;
    return !map.get(c);
  }
}