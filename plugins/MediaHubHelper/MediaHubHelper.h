#ifndef EXAMPLE_H
#define EXAMPLE_H

#include <QObject>

class QDBusInterface;

class MediaHubHelper: public QObject {
    Q_OBJECT

public:
    explicit MediaHubHelper(QObject *parent = 0);
    ~MediaHubHelper() = default;

    Q_INVOKABLE const QString getEqualizerBands();
    Q_INVOKABLE void setEqualizerBand(int band, double gain);

Q_SIGNALS:
    void equalizerBandChanged(int band, double gain);

private Q_SLOTS:
    void onEqualizerBandChanged(int band, double gain);

private:

    QDBusInterface *dbus_mediahub;
};

#endif
