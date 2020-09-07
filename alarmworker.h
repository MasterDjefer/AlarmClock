#ifndef ALARMTHREAD_H
#define ALARMTHREAD_H
#include <QObject>
#include <QThread>
#include <QDebug>

#define DAYS_IN_WEEK 7

typedef struct tm CTime;

class AlarmWorker : public QObject
{
    Q_OBJECT

public:
    AlarmWorker(int index, int hour, int minute);

private:
    static CTime getCurrentTime();
    static int getCurrentWeekDay();
    static time_t tomorrowTime();

private:
    int mIndex;
    CTime mTime;
    bool mDays[DAYS_IN_WEEK];

public slots:
    void start();

public:
    void updateTime(int hour, int minute);
    void updateDays(bool days[]);
    bool isProperDay(int currentWeekDay);
    bool isRepeatable();

signals:
    void alarmDone(int index, bool isRepeatable);
};

#endif // ALARMTHREAD_H
