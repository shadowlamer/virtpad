#include <ServerTask.h>
#include <iostream>

ServerTask::ServerTask():
        Task(SERVER_TASK_ID),
        sa(IPAddress(), UDP_PORT),
        sock(sa, true),
        buffer{}
{
  sock.setBlocking(false);
  sock.joinGroup(IPAddress(UDP_MULTICAST_GROUP));

  fd = open(UINPUT_PATH, O_WRONLY | O_NONBLOCK);

  //Enable mouse events
  ioctl(fd, UI_SET_EVBIT, EV_REL);
  ioctl(fd, UI_SET_RELBIT, REL_X);
  ioctl(fd, UI_SET_RELBIT, REL_Y);
  ioctl(fd, UI_SET_RELBIT, REL_Z);
  ioctl(fd, UI_SET_EVBIT, EV_KEY);
  ioctl(fd, UI_SET_KEYBIT, BTN_LEFT);
  ioctl(fd, UI_SET_KEYBIT, BTN_RIGHT);
  ioctl(fd, UI_SET_KEYBIT, BTN_MIDDLE);

  ioctl(fd, UI_DEV_SETUP, &uinputd_device);
  ioctl(fd, UI_DEV_CREATE);
}

ServerTask::~ServerTask() {
  ioctl(fd, UI_DEV_DESTROY);
  close(fd);
}

void ServerTask::runTask() {
  int n;
    try {
        while (!sleep(POLL_INTERVAL)) {
          SocketAddress sender;
          do {
            n = sock.receiveFrom(buffer, sizeof(buffer) - 1, sender);
            if (n == sizeof(input_event)) {
              write(fd, buffer, sizeof(input_event));
              write(fd, &sync_event, sizeof(input_event));
            }
          } while (n >= 0);
        }
    } catch (exception& e) {
        cerr << e.what() << endl;
        Poco::Process::requestTermination(Poco::Process::id());
    }
}
