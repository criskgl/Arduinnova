//
// states
final int stateMenu                  = 0;
final int stateSeeChartFootball      = 1;
final int stateSeeFootballStatistics = 2;
int state = stateMenu;
//
// font
PFont font;
//

// ----------------------------------------------------------------------
// main functions

void setup()
{
  // runs only once
  //
  size(700, 600);
  smooth();
  font = createFont("ARCARTER-78.vlw", 14);
  textFont(font);
} // func
//
void draw()
{
  // the main routine. It handels the states.
  // runs again and again
  switch (state) {
  case stateMenu:
    showMenu();
    break;
  case stateSeeChartFootball:
    handleStateSeeChartFootball();
    break;
  case stateSeeFootballStatistics:
    handleStateSeeFootballStatistics();
    break;
  default:
    println ("Unknown state (in draw) "
      + state
      + " ++++++++++++++++++++++");
    exit();
    break;
  } // switch
  //
} // func
// ----------------------------------------------------------------
// keyboard functions

void keyPressed() {
  // keyboard. Also different depending on the state.
  switch (state) {
  case stateMenu:
    keyPressedForStateMenu();
    break;
  case stateSeeChartFootball:
    keyPressedForStateSeeChartFootball();
    break;
  case stateSeeFootballStatistics:
    keyPressedForStateSeeFootballStatistics();
    break;
  default:
    println ("Unknown state (in keypressed) "
      + state
      + " ++++++++++++++++++++++");
    exit();
    break;
  } // switch
  //
} // func
void keyPressedForStateMenu() {
  //
  switch(key) {
  case '1':
    state = stateSeeChartFootball;
    break;
  case '2':
    state = stateSeeFootballStatistics;
    break;
  case 'x':
  case 'X':
    // quit
    exit();
    break;
  default:
    // do nothing
    break;
  }// switch
  //
} // func
void keyPressedForStateSeeChartFootball() {
  // any key is possible
  switch(key) {
  default:
    state = stateMenu;
    break;
  } // switch
  //
} // func
void keyPressedForStateSeeFootballStatistics() {
  // any key is possible
  switch(key) {
  default:
    state = stateMenu;
    break;
  } // switch
  //
} // func

// ----------------------------------------------------------------
// functions to show the menu and functions that are called from the menu.
// They depend on the states and are called by draw().

void showMenu() {
  background(255, 204, 0);
  fill(0);
  textSize(32);
  text(" Your football program ", 150, 100, 3);
  textSize(14);
  text("Press 1 See chart football ", 100, 200);
  text("Press 2 See football statistics ", 100, 220);
  //
  text("Press x to quit ", 100, 260);
  //
} // func

void handleStateSeeChartFootball() {
  background(255, 204, 0);
  fill(0);
  textSize(32);
  text(" See chart football ", 150, 100, 3);
  textSize(14);
  text("..... some text ", 100, 200);
  //
} // func
//

void handleStateSeeFootballStatistics() {
  background(255, 204, 0);
  fill(0);
  textSize(32);
  text(" See football statistics ", 150, 100, 3);
  textSize(14);
  text("..... some text ", 100, 200);
  //
} // func
// ----------------------------------------------------------------
//
