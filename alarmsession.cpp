#include "alarmsession.h"

AlarmSession::AlarmSession()
{
}

void AlarmSession::addTimer(int alarmIndex, int hour, int minute)
{
    AlarmWorker *worker = new AlarmWorker(alarmIndex, hour, minute);
    QTimer *timer = new QTimer;
    mWorkersMap.insert(alarmIndex, std::make_pair(worker, timer));

    timer->setInterval(1000);

    QObject::connect(timer, &QTimer::timeout, worker, &AlarmWorker::start);
    QObject::connect(worker, &AlarmWorker::alarmDone, this, &AlarmSession::onAlarmDone);

    timer->start();
}

void AlarmSession::removeTimer(int alarmIndex)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex].second->stop();
        clearTimer(alarmIndex);
    }
}

void AlarmSession::updateTime(int alarmIndex, int hour, int minute)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex].first->updateTime(hour, minute);
    }
}

void AlarmSession::clearTimer(int index)
{
    delete mWorkersMap[index].first;
    delete mWorkersMap[index].second;
    mWorkersMap.remove(index);
}

void AlarmSession::onAlarmDone(int index)
{
    clearTimer(index);
    emit alarmRingTime(index);
}
