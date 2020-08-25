#ifndef ALARMTHREAD_H
#define ALARMTHREAD_H
#include <QObject>
#include <QThread>
#include <QDebug>
#include <QMutex>
#include <QMutexLocker>

class AlarmWorker : public QObject
{
    Q_OBJECT

public:
    AlarmWorker(int index, int hour, int minute);
    void getCurrentTime(struct tm *tmTime);

private:
    int mIndex;
    int mHour;
    int mMinute;
    bool isRunning;
    QMutex mutex;

public slots:
    void start();

public:
    void stop();
    void updateTime(int hour, int minute);

private:
    bool getRunningState();

signals:
    void finished(int index);
};

#endif // ALARMTHREAD_H
