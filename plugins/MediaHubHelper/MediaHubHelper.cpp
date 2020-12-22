#include <QDebug>

#include "MediaHubHelper.h"

#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDBusInterface>

MediaHubHelper::MediaHubHelper() {
    auto connection = QDBusConnection::sessionBus();
    auto interface = connection.interface();
    interface->startService(QStringLiteral("core.ubuntu.media.Service"));

    dbus_mediahub = new QDBusInterface(QStringLiteral("core.ubuntu.media.Service"),
                                       QStringLiteral("/core/ubuntu/media/Service"),
                                       QStringLiteral("core.ubuntu.media.Service"),
                                       connection, this);

    connect(dbus_mediahub, SIGNAL(EqualizerBandChanged(int band, double gain)),
            this, SLOT(onEqualizerBandChanged(int band, double gain)));
}

const QString MediaHubHelper::getEqualizerBands() {
    QDBusMessage reply = dbus_mediahub->call("EqualizerGetBands");
    qDebug() << reply;

    QMap<int,double> bands;
    const QDBusArgument &dbusArg = reply.arguments().at( 0 ).value<QDBusArgument>();
    dbusArg >> bands;

    // create JSON
    QString json = "{\"bands\":[";
    bool first = true;
    for(int band : bands.keys()) {
        double gain = bands.value(band);
        if(!first)
            json += ", ";
        json += QStringLiteral("{\"band\": \"band%1\", \"gain\": %2}").arg(band).arg(gain);
        first = false;
    }
    json += "]}";

    return json;
}

void MediaHubHelper::setEqualizerBand(int band, double gain) {
    QDBusMessage reply = dbus_mediahub->call(QStringLiteral("EqualizerSetBand"), band, gain);
    qDebug() << "setEqualizerBand: " << reply;
}

void MediaHubHelper::onEqualizerBandChanged(int band, double gain) {
    qDebug() << "onEqualizerBandChanged: " << band << ", " << gain;
    Q_EMIT equalizerBandChanged(band, gain);
}
