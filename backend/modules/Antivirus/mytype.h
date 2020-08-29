#ifndef MYTYPE_H
#define MYTYPE_H

#include <QObject>
#include <QProcess>
#include <QNetworkReply>
#include <QNetworkAccessManager>

class MyType : public QObject
{
    Q_OBJECT

public:
    explicit MyType(QObject *parent = 0);
    ~MyType();
    Q_INVOKABLE QString checkFirewall();
    Q_INVOKABLE QString getFirewallConfig(const QString &address);
    Q_INVOKABLE QString getServiceList();
    Q_INVOKABLE QString activeFirewall(const QString &command);
    Q_INVOKABLE QString stopService(const QString &command);
    Q_INVOKABLE QString getIpStatus(const QString &address);

    Q_INVOKABLE QString getClickList();
    Q_INVOKABLE QString getReasonList();
    Q_INVOKABLE QString getMaliciousClickList();
    Q_INVOKABLE QString checkPassword();
    Q_INVOKABLE QString checkRcLocal();
    Q_INVOKABLE QString getListenPorts();
    Q_INVOKABLE QString getIpList();
    Q_INVOKABLE QString scanIp(const QString &address);

    Q_INVOKABLE QString resolveRISKS(const QString &commandd);
    Q_INVOKABLE QString pass(const QString &pass);

public slots:
    void replyFinished(QNetworkReply*);

private:
    QNetworkAccessManager* m_manager;

protected:

    qint8 lock;
    QString ipResult;
    QProcess *m_process;
    QProcess *process1;

};

#endif // MYTYPE_H
