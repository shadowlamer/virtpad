import android.os.Bundle;
import android.view.WindowManager;
import android.app.Activity;
import hypermedia.net.*; 

private final String multicastGroup = "224.0.0.178";
private final int udpPort = 1514;
private final double wheelQuotient = 0.1;

private UDP udptx;
private UI ui;

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
  ui = new UI();
}


void draw()
{
  ui.draw();
}


void touchStarted() {
  mx = mouseX;
  my = mouseY;
  moved = false;
}

void touchMoved() {
  moved = true;
  if (2 == touches.length) {
    udptx.send(new Event(Event.EV_REL, Event.REL_WHEEL, (short) Math.round((mouseY - my) * wheelQuotient)).buffer());
  } else {
    udptx.send(new Event(Event.EV_REL, Event.REL_X, mouseX - mx).buffer());
    udptx.send(new Event(Event.EV_REL, Event.REL_Y, mouseY - my).buffer());
  }
  mx = mouseX;
  my = mouseY;
}

void touchEnded() { 
  if (!moved) {
    short k = ui.getKey();
    udptx.send(new Event(Event.EV_KEY, k, 1).buffer());
    delay(10);
    udptx.send(new Event(Event.EV_KEY, k, 0).buffer());  
  }
}

void onStop() {
  super.onStop();
  getActivity().finish();
  System.exit(0);
}
