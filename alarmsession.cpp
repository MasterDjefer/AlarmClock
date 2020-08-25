#include "alarmsession.h"

AlarmSession::AlarmSession()
{
}

void AlarmSession::addThread(int alarmIndex, int hour, int minute)
{
    QThread *thread = new QThread;
    AlarmWorker *worker = new AlarmWorker(alarmIndex, hour, minute);
    mWorkersMap.insert(alarmIndex, std::make_pair(worker, thread));
    worker->moveToThread(thread);

    QObject::connect(thread, &QThread::started, worker, &AlarmWorker::start);
    QObject::connect(worker, &AlarmWorker::alarmDone, this, &AlarmSession::onAlarmDone);
    QObject::connect(worker, &AlarmWorker::alarmStoped, this, &AlarmSession::onAlarmStoped);

    QObject::connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    QObject::connect(worker, &AlarmWorker::alarmDone, worker, &AlarmWorker::deleteLater);
    QObject::connect(worker, &AlarmWorker::alarmStoped, worker, &AlarmWorker::deleteLater);

    thread->start();
}

void AlarmSession::removeThread(int alarmIndex)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex].first->stop();
        mWorkersMap.remove(alarmIndex);
    }
}

void AlarmSession::updateTime(int alarmIndex, int hour, int minute)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex].first->updateTime(hour, minute);
    }
}

void AlarmSession::onAlarmDone(int index)
{
    mWorkersMap.remove(index);

    emit alarmRingTime(index);
}

void AlarmSession::onAlarmStoped(int index)
{
    mWorkersMap.remove(index);
}
