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
  ioctl(fd, UI_SET_RELBIT, REL_WHEEL);

  //Enable key events
  ioctl(fd, UI_SET_EVBIT, EV_KEY);
  for (auto key: allowed_keys) {
    ioctl(fd, UI_SET_KEYBIT, key);
  }

  ioctl(fd, UI_DEV_SETUP, &uinputd_device);
  ioctl(fd, UI_DEV_CREATE);

}

ServerTask::~ServerTask() {
  ioctl(fd, UI_DEV_DESTROY);
  close(fd);
}

void ServerTask::runTask() {
    try {
        while (!sleep(POLL_INTERVAL)) {
          SocketAddress sender;
          int n;
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
