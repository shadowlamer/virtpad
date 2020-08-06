import android.os.Bundle;
import android.view.WindowManager;
import android.app.Activity;
import hypermedia.net.*; 

private final String multicastGroup = "224.0.0.178";
private final int udpPort = 1514;

private UDP udptx;

private int mx;
private int my;
private boolean moved;

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void setup()
{
  fullScreen(P2D);
  udptx = new UDP(this, udpPort, multicastGroup);
}


void draw()
{
  background(0);
}


void touchStarted() {
  mx = mouseX;
  my = mouseY;
  moved = false;
}

void touchMoved() {
  if (mx != mouseX || my != mouseY) {
    moved = true;
  }
  udptx.send(new Event(Event.EV_REL, Event.REL_X, mouseX - mx).buffer());
  udptx.send(new Event(Event.EV_REL, Event.REL_Y, mouseY - my).buffer());
  mx = mouseX;
  my = mouseY;
}

void touchEnded() { 
  touchMoved();
  if (!moved) {
    udptx.send(new Event(Event.EV_KEY, Event.BTN_LEFT, 1).buffer());
    delay(10);
    udptx.send(new Event(Event.EV_KEY, Event.BTN_LEFT, 0).buffer());  
  }
}

void onStop() {
  super.onStop();
  getActivity().finish();
  System.exit(0);
}
