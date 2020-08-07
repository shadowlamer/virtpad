#ifndef UINPUTD_SERVERTASK_H
#define UINPUTD_SERVERTASK_H

#include "Poco/Task.h"
#include "Poco/Process.h"
#include "Poco/TaskManager.h"
#include <Poco/Util/ServerApplication.h>
#include <Poco/Net/IPAddress.h>
#include <Poco/Net/SocketAddress.h>
#include <Poco/Net/MulticastSocket.h>

#include <linux/uinput.h>

#include "settings.h"

using namespace Poco;
using namespace std;
using namespace Poco::Util;
using namespace Poco::Net;

class ServerTask: public Task {
public:
    ServerTask();
    void runTask(void);

    virtual ~ServerTask();

private:
    SocketAddress sa;
    MulticastSocket sock;
    char buffer[INPUT_BUFFER_SIZE];
    int fd;
    struct input_event sync_event = {
        .time = {
            .tv_sec = 0,
            .tv_usec = 0
        },
        .type = EV_SYN,
        .code = SYN_REPORT,
        .value = 0
    };
    struct uinput_setup uinputd_device = {
        .id = {
            .bustype = BUS_VIRTUAL,
            .vendor  = VIRTUAL_DEVICE_VENDOR,
            .product = VIRTUAL_DEVICE_PRODUCT,
            .version = VIRTUAL_DEVICE_VERSION,
        },
        .name = SERVER_TASK_ID,
        .ff_effects_max = 0,
    };
    vector<short int> allowed_keys = {
        BTN_LEFT,
        BTN_RIGHT,
        BTN_MIDDLE,
        KEY_LEFT,
        KEY_RIGHT,
        KEY_UP,
        KEY_DOWN,
        KEY_VOLUMEUP,
        KEY_VOLUMEDOWN,
        KEY_BACKSPACE,
        KEY_ENTER,
        KEY_PLAY,
        KEY_STOP
    };
};

#endif //UINPUTD_SERVERTASK_H
