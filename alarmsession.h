#ifndef ALARMSESSION_H
#define ALARMSESSION_H

#include <QObject>
#include <QThread>
#include <QMap>
#include <QTimer>

#include "alarmworker.h"

class AlarmSession : public QObject
{
    Q_OBJECT
public:
    AlarmSession();
    void addTimer(int alarmIndex, int hour, int minute);
    void removeTimer(int alarmIndex);
    void updateTime(int alarmIndex, int hour, int minute);

private:
    QMap<int, std::pair<AlarmWorker*, QTimer*> > mWorkersMap;

private:
    void clearTimer(int index);

public slots:
    void onAlarmDone(int index);

signals:
    void alarmRingTime(int index);
};

#endif // ALARMSESSION_H
