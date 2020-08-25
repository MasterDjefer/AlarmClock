#ifndef ALARMSESSION_H
#define ALARMSESSION_H

#include <QObject>
#include <QThread>
#include <QMap>

#include "alarmworker.h"

class AlarmSession : public QObject
{
    Q_OBJECT
public:
    AlarmSession();
    void addThread(int alarmIndex, int hour, int minute);
    void removeThread(int alarmIndex);
    void updateTime(int alarmIndex, int hour, int minute);

private:
    QMap<int, AlarmWorker*> mWorkersMap;

public slots:
    void onAlarmFinished(int index);

signals:
    void alarmRingTime(int index);
};

#endif // ALARMSESSION_H
