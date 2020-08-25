#ifndef ALARMTHREAD_H
#define ALARMTHREAD_H
#include <QObject>
#include <QThread>
#include <QDebug>

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

public slots:
    void start();

public:
    void updateTime(int hour, int minute);

signals:
    void alarmDone(int index);
};

#endif // ALARMTHREAD_H
