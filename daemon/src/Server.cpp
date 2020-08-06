#include <Server.h>

int ServerApp::main(const vector<string> &)
{
    TaskManager tm;
    try {
        tm.start(new ServerTask());
    } catch (int e) {
        cerr << e << endl;
    }
    waitForTerminationRequest();

    tm.cancelAll();
    tm.joinAll();

    return Application::EXIT_OK;
}
