
// Simple timer class to avoid rapidly pressing any key.
class Timer {
  int time;
  
  //Constructor
  Timer( int i ) {
    time = i;
  }
  
  //Current timer's time
  int time() {
    return time;
  }
  
  //Set timer to a certain number
  void set_to(int i) {
    time = i;
  }
  
  //Tick the timer
  void tick() {
    if (time > 0 )
      time -= 1;
  }
}