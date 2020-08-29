#ifndef FIREWALLBACKEND_H
#define FIREWALLBACKEND_H

#include <QObject>

class firewallBackend : public QObject
{
    Q_OBJECT
public:
    explicit firewallBackend(QObject *parent = 0);

signals:

public slots:
};

#endif // FIREWALLBACKEND_H