import java.nio.ByteBuffer;
import java.nio.ByteOrder;

class Event {
  public static final short EV_KEY = 0x01;
  public static final short EV_REL = 0x02;
  public static final short REL_X = 0x00;
  public static final short REL_Y = 0x01;
  public static final short REL_WHEEL = 0x08;
  public static final short BTN_LEFT   = 0x110;
  public static final short BTN_RIGHT  = 0x111;
  public static final short BTN_MIDDLE = 0x112;
  public static final short KEY_LEFT   = 105;
  public static final short KEY_RIGHT  = 106;
  public static final short KEY_UP     = 103;
  public static final short KEY_DOWN   = 108;
  public static final short KEY_VOLUMEUP   = 115;
  public static final short KEY_VOLUMEDOWN = 114;
  public static final short KEY_BACKSPACE  = 14;
  public static final short KEY_ENTER  = 28;
  public static final short KEY_PLAY   = 207;
  public static final short KEY_STOP   = 128;
  public static final short KEY_RED    = 0x18e;
  public static final short KEY_GREEN  = 0x18f;
  public static final short KEY_YELLOW = 0x190;
  public static final short KEY_BLUE   = 0x191;
 
  private long time_sec;
  private long time_usec;
  private short type;
  private short code;
  private int value;

  public Event() {
    this.time_sec = second();
    this.time_usec = millis() * 1000;
  }
  
  public Event(short type, short code, int value) {
    this();
    this.type = type;
    this.code = code;
    this.value = value;
  }
  
  public byte[] buffer() {
    return ByteBuffer
      .allocate(24)
      .order(ByteOrder.LITTLE_ENDIAN)
      .putLong(time_sec)
      .putLong(time_usec)
      .putShort(type)
      .putShort(code)
      .putInt(value)
      .array();
  }

}
