import java.nio.ByteBuffer;
import java.nio.ByteOrder;

class Event {
  public static final short EV_KEY = 0x01;
  public static final short EV_REL = 0x02;
  public static final short REL_X = 0x00;
  public static final short REL_Y = 0x01;
  public static final short REL_Z = 0x02;
  public static final short BTN_LEFT   = 0x110;
  public static final short BTN_RIGHT  = 0x111;
  public static final short BTN_MIDDLE = 0x112;
  
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
