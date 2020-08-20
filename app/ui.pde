class UI {
  
  private class Button {
    private int x;
    private int y;
    private String label;
    private String image;
    private short event;
    
    Button(int x, int y, String label, String image, short event) {
      this.x = x;
      this.y = y;
      this.label = label;
      this.image = image;
      this.event = event;
    }
  }

  private final float keypadHeightPercent = 30;
  private final float scrollWidthPercent = 15;
  private final float scrollCornerRadius = 50;
  private int buttonWidth = 0;
  private int buttonHeight = 0;
  private int maxRow = 0;
  private int maxCol = 0;
  
  private ArrayList<Button> buttons = new ArrayList<Button>();
  
  public UI() {
    background(0);
    buttons.add(new Button(0, 0, "bkspace", "ic_keyboard_backspace",  Event.KEY_BACKSPACE));
    buttons.add(new Button(1, 0, "up",      "ic_keyboard_arrow_up",   Event.KEY_UP));
    buttons.add(new Button(2, 0, "play",    "ic_keyboard_return",     Event.KEY_ENTER));
    buttons.add(new Button(3, 0, "volUp",   "ic_volume_up",           Event.KEY_VOLUMEUP));

    buttons.add(new Button(0, 1, "left",    "ic_chevron_left",        Event.KEY_LEFT));
    buttons.add(new Button(1, 1, "down",    "ic_keyboard_arrow_down", Event.KEY_DOWN));
    buttons.add(new Button(2, 1, "right",   "ic_chevron_right",       Event.KEY_RIGHT));
    buttons.add(new Button(3, 1, "volDown", "ic_volume_down",         Event.KEY_VOLUMEDOWN));

    buttons.add(new Button(0, 2, "red",     "ic_red",                 Event.KEY_RED));
    buttons.add(new Button(1, 2, "green",   "ic_green",               Event.KEY_GREEN));
    buttons.add(new Button(2, 2, "yelow",   "ic_yellow",              Event.KEY_YELLOW));
    buttons.add(new Button(3, 2, "blue",    "ic_blue",                Event.KEY_BLUE));
    setupKeypad();
    setupScroll();
  }
    
  private int buttonX(Button b) {
    return buttonWidth * b.x;
  }

  private int buttonY(Button b) {
    return height - buttonHeight * (maxRow - b.y + 1);
  }
  
  private void setupScroll() {
    fill(30);
    int scrollWidthPx=Math.round(width * scrollWidthPercent / 100);
    int scrollHeightPx=Math.round(height * (100 - keypadHeightPercent) / 100);
    rect(width - scrollWidthPx, 0, scrollWidthPx, scrollHeightPx, scrollCornerRadius, scrollCornerRadius, scrollCornerRadius, scrollCornerRadius);
  }
  
  private void setupKeypad() {
    for (Button b: buttons) {
      maxRow = Math.max(maxRow, b.y);
      maxCol = Math.max(maxCol, b.x);
    }
    buttonWidth = width / (maxCol + 1);
    buttonHeight = Math.round(height / (maxRow + 1) * keypadHeightPercent / 100.0);

    imageMode(CENTER);
    for (Button b: buttons) {
       image(loadImage(b.image + ".png"), buttonX(b) + buttonWidth / 2, buttonY(b) + buttonHeight / 2);
    }
  }
 
  public boolean isScroll() {
    int scrollWidthPx=Math.round(width * scrollWidthPercent / 100);
    int scrollHeightPx=Math.round(height * (100 - keypadHeightPercent) / 100);
    return mouseX > width - scrollWidthPx && mouseY < scrollHeightPx;
  }
 
  public short getKey() {
    for (Button b: buttons) {
      if (mouseX > buttonX(b) && 
          mouseX < buttonX(b) + buttonWidth &&
          mouseY > buttonY(b) && 
          mouseY < buttonY(b) + buttonHeight) {    
        return b.event;
      }
    }
    return Event.BTN_LEFT;
  }

}
