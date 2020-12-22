#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "MediaHubHelper.h"

void MediaHubHelperPlugin::registerTypes(const char *uri) {
    //@uri MediaHubHelper
    qmlRegisterSingletonType<MediaHubHelper>(uri, 1, 0, "MediaHubHelper", [](QQmlEngine*, QJSEngine*) -> QObject* { return new MediaHubHelper; });
}
