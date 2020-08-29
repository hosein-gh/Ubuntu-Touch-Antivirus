#include "mytype.h"
#include <QDebug>
#include <QNetworkRequest>
#include <QNetworkAccessManager>
#include <QThread>
#include <QEventLoop>
#include <QScreen>
#include <QFile>
#include <QTextStream>

MyType::MyType(QObject *parent) :
    QObject(parent),
m_process(new QProcess(this))
{

    m_manager = new QNetworkAccessManager(this);


}

QString MyType::checkFirewall()
{

        QProcess OProcess;
        QString Command;    //Contains the command to be executed
        QStringList args;   //Contains arguments of the command

        Command = "service";
        args << "ufw" << "status";

        OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
        OProcess.waitForFinished();                       //Waits for execution to complete

        QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
        QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

        //qDebug() << "\n Printing the standard output..........\n";
        //qDebug() << StdOut;
        //qDebug() << "\n Printing the standard error..........\n";
        //qDebug() << StdError;

        //qDebug() << "\n\n";


        QString status = "";
        StdOut.remove(QRegExp("[\\n\\t\\r]"));

        if(StdOut == "ufw start/running") {

            status = "Active";

        }else {

            status = "inactive";

        }

        //qDebug() << status;

    return status;

}

QString MyType::getFirewallConfig(const QString &address)
{

        QProcess OProcess;
        QString Command;    //Contains the command to be executed
        QStringList args;   //Contains arguments of the command

        Command = "bash";
        args << "-c" << address;

        OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
        OProcess.waitForFinished();                       //Waits for execution to complete

        QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
        QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

        //qDebug() << "\n Printing the standard output..........\n";
        //qDebug() << StdOut;
        //qDebug() << "\n Printing the standard error..........\n";
        //qDebug() << StdError;

        //qDebug() << "\n\n";


        if(StdError.contains("Sorry, try again.", Qt::CaseInsensitive)) {

            return "error";

        }else {

            return StdOut;

        }

}

QString MyType::getIpStatus(const QString &address)
{


        QEventLoop eventLoop;

        // "quit()" the event-loop, when the network request "finished()"
        QNetworkAccessManager mgr;
        QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));

        // the HTTP request
        QNetworkRequest req( QUrl( QString("http://www.malwaredomainlist.com/mdl.php?search=" + address + "&colsearch=All&quantity=1") ) );
        QNetworkReply *reply = mgr.get(req);
        eventLoop.exec(); // blocks stack until "finished()" has been called

        if (reply->error() == QNetworkReply::NoError) {
            //success
            ////qDebug() << "Success" <<reply->readAll();

        }
        else {
            //failure
            ////qDebug() << "Failure" <<reply->errorString();

            if(reply->errorString() == "Network unreachable") {

                return "Network unreachable";

            }else {

                return "Network unreachable";

            }

        }

        QByteArray data=reply->readAll();
        QString str(data);

        str.remove(QRegExp("[\\n\\t\\r]"));

        if (str.count(address) > 21) {

            QString subString = str.mid(str.indexOf("<center><p>Page",Qt::CaseInsensitive),str.indexOf("<div class=\"disclaimer\">",Qt::CaseInsensitive) - str.indexOf("<center><p>Page",Qt::CaseInsensitive));

            QString country = subString.mid(subString.indexOf("title=",Qt::CaseInsensitive)+6, subString.indexOf("\"/></td></tr></table><center><p>Page",Qt::CaseInsensitive) - (subString.indexOf("title=",Qt::CaseInsensitive)+6));
            country.remove(QRegExp("\""));



            int j = 0;
            QStringList sttrr;

            while ((j = subString.indexOf("<td>", j)) != -1) {
                sttrr << QString::number(j);
                ++j;
            }

            int jj = 0;
            QStringList sttrrr;

            while ((jj = subString.indexOf("</td>", jj)) != -1) {
                sttrrr << QString::number(jj);
                ++jj;
            }

            QString type = subString.mid(sttrr[20].toInt()+4,(sttrrr[20].toInt()) - (sttrr[20].toInt()+4));

            ipResult = country + "-" + type;

        }else {

            ipResult = "not contain";

        }


    return ipResult;

}

QString MyType::getServiceList()
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "service";
    args << "--status-all";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    ////qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    QStringList strlist;
    QString finalString;

    StdOut.remove(QRegExp(" "));

    strlist = StdOut.split(QRegExp("[\n]"),QString::SkipEmptyParts);

    qint32 counter = 0;

    while(counter <= strlist.count()-1) {

        if(strlist[counter].contains("[-]", Qt::CaseInsensitive)) {

            strlist[counter].remove("[-]");
            if(finalString == "") {

                finalString += strlist[counter] + "  [Stoped]";

            }else {

                finalString += "==" + strlist[counter] + "  [Stoped]";

            }

        }else if(strlist[counter].contains("[+]", Qt::CaseInsensitive)) {

            strlist[counter].remove("[+]");
            if(finalString == "") {

                finalString += strlist[counter] + "  [Running]";

            }else {

                finalString += "==" + strlist[counter] + "  [Running]";

            }

        }else if(strlist[counter].contains("[?]", Qt::CaseInsensitive)) {

            strlist[counter].remove("[?]");
            if(finalString == "") {

                finalString += strlist[counter] + "  [Can't Detect]";

            }else {

                finalString += "==" + strlist[counter] + "  [Can't Detect]";

            }

        }

        counter ++;

    }

    ////qDebug() << finalString;

    return finalString;

}

QString MyType::activeFirewall(const QString &command)
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "bash";
    args<< "-c" << command;

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    if(StdOut == "") {

        return "error";

    }else {

        return StdOut;

    }

}

QString MyType::stopService(const QString &command)
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "bash";
    args<< "-c" << command;

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    StdError.remove(QRegExp("[\\n\\t\\r]"));

    if(StdError.contains("Sorry, try again.", Qt::CaseInsensitive)) {

        return "error";

    }else {

        return StdOut;

    }

}

QString MyType::getClickList()
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "click";
    args<< "list";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";


    return StdOut;

}

QString MyType::getMaliciousClickList()
{

    QEventLoop eventLoop;

    // "quit()" the event-loop, when the network request "finished()"
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));

    // the HTTP request
    QNetworkRequest req( QUrl( QString("http://80.82.69.185/click.list") ) );
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec(); // blocks stack until "finished()" has been called

    if (reply->error() == QNetworkReply::NoError) {
        //success
        //qDebug() << "Success" <<reply->readAll();

        return reply->readAll();


    }
    else {
        //failure
        //qDebug() << "Failure" <<reply->errorString();

        return "sommergram.jdev\n";

    }

}

QString MyType::getReasonList()
{

    QEventLoop eventLoop;

    // "quit()" the event-loop, when the network request "finished()"
    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));

    // the HTTP request
    QNetworkRequest req( QUrl( QString("http://80.82.69.185/reason.list") ) );
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec(); // blocks stack until "finished()" has been called

    if (reply->error() == QNetworkReply::NoError) {
        //success
        //qDebug() << "Success" <<reply->readAll();

        return reply->readAll();


    }
    else {
        //failure
        //qDebug() << "Failure" <<reply->errorString();

        return "send user data to a third party server.\n";

    }

}

QString MyType::checkPassword()
{


    QProcess OProcess1;
    QString Command1;    //Contains the command to be executed
    QStringList args1;   //Contains arguments of the command

    Command1 = "whoami";

    OProcess1.start(Command1,args1,QIODevice::ReadOnly); //Starts execution of command
    OProcess1.waitForFinished();                       //Waits for execution to complete

    QString StdOut1      =   OProcess1.readAllStandardOutput();  //Reads standard output
    QString StdError1    =   OProcess1.readAllStandardError();   //Reads standard error

    StdOut1.remove(QRegExp("[\\n\\t\\r]"));

    //qDebug() << StdOut1;

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "passwd";
    args<< "--status" << StdOut1;

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    return StdOut;

}

QString MyType::checkRcLocal()
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "cat";
    args<< "/etc/rc.local";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    return StdOut;

}

QString MyType::getListenPorts()
{

    QString result = "";

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "bash";
    args<< "-c" << "netstat -atun | grep LISTEN";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    QStringList splited = StdOut.split("\n");

    qint32 counter = 0;

    for(counter = 0 ; counter <= splited.count()-1 ; counter++) {

        QString str = splited[counter];

        if(str.left(4) == "tcp6" || str.left(4) == "udp6" || str == "") {


        }else {

            QStringList spil = str.split(":");

            QString str2;

            if(spil.count() > 1) {

                if(result == "") {

                    str2 = spil[1];
                    str2 = str2.left(5);
                    result = str2.remove(QRegExp(" "));

                }else {

                    str2 = spil[1];
                    str2 = str2.left(5);
                    result = result + "==" + str2.remove(QRegExp(" "));

                }

            }
        }

    }


    return result;

}

QString MyType::getIpList()
{

    QString result = "";

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "bash";
    args<< "-c" << "netstat -atun | grep ESTABLISHED";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    QStringList splited = StdOut.split("\n");

    qint32 counter = 0;

    for(counter = 0 ; counter <= splited.count()-1 ; counter++) {

        QString str = splited[counter];

        if(str.left(4) == "tcp6" || str.left(4) == "udp6" || str == "") {


        }else {

            QStringList spil = str.split(":");

            QString str2;

            if(spil.count() > 1) {

                str2 = spil[1];
                str2 = str2.remove(str2.left(5));
                str2 = str2.remove(QRegExp(" "));

                if(str2 == "0.0.0.0" || str2 == "127.0.0.1") {

                }else {

                    if(result == "") {

                        result = str2;

                    }else {

                        result = result + "==" + str2;

                    }

                }
            }
        }

    }

    return result;

}

QString MyType::scanIp(const QString &address)
{


        QEventLoop eventLoop;

        // "quit()" the event-loop, when the network request "finished()"
        QNetworkAccessManager mgr;
        QObject::connect(&mgr, SIGNAL(finished(QNetworkReply*)), &eventLoop, SLOT(quit()));

        // the HTTP request
        QNetworkRequest req( QUrl( QString("http://www.malwaredomainlist.com/mdl.php?search=" + address + "&colsearch=All&quantity=1") ) );
        QNetworkReply *reply = mgr.get(req);
        eventLoop.exec(); // blocks stack until "finished()" has been called

        if (reply->error() == QNetworkReply::NoError) {
            //success
            ////qDebug() << "Success" <<reply->readAll();

        }
        else {
            //failure
            ////qDebug() << "Failure" <<reply->errorString();

            if(reply->errorString() == "Network unreachable") {

                return "Network unreachable";

            }else {

                return "Network unreachable";

            }

        }

        QByteArray data=reply->readAll();
        QString str(data);

        str.remove(QRegExp("[\\n\\t\\r]"));

        if (str.count(address) > 21) {

            ipResult = "contain";

        }else {

            ipResult = "not contain";

        }


    return ipResult;

}

QString MyType::resolveRISKS(const QString &commandd)
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "bash";
    args<< "-c" << commandd;

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    if(StdOut == "") {

        return "NO";

    }else {

        return "YES";

    }

}
QString MyType::pass(const QString &pass)
{

    QProcess OProcess;
    QString Command;    //Contains the command to be executed
    QStringList args;   //Contains arguments of the command

    Command = "bash";
    args<< "-c" << "echo '" + pass + "' | sudo -S id";

    OProcess.start(Command,args,QIODevice::ReadOnly); //Starts execution of command
    OProcess.waitForFinished();                       //Waits for execution to complete

    QString StdOut      =   OProcess.readAllStandardOutput();  //Reads standard output
    QString StdError    =   OProcess.readAllStandardError();   //Reads standard error

    //qDebug() << "\n Printing the standard output..........\n";
    //qDebug() << StdOut;
    //qDebug() << "\n Printing the standard error..........\n";
    //qDebug() << StdError;

    //qDebug() << "\n\n";

    if(StdOut == "") {

        return "NO";

    }else {

        return "YES";

    }

}

MyType::~MyType() {

}
