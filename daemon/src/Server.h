#ifndef UINPUTD_SERVER_H
#define UINPUTD_SERVER_H

#include <thread>
#include <unistd.h>
#include <fstream>
#include <iostream>
#include <Poco/Util/ServerApplication.h>
#include <ServerTask.h>

using namespace Poco;
using namespace Poco::Util;
using namespace std;

class ServerApp : public ServerApplication
{
protected:
    int main(const vector<string> &);
};

#endif //UINPUTD_SERVER_H
