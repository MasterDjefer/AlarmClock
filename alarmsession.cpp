#include "alarmsession.h"

AlarmSession::AlarmSession()
{

}

void AlarmSession::addThread(int alarmIndex, int hour, int minute)
{
    QThread *thread = new QThread;
    AlarmWorker *worker = new AlarmWorker(alarmIndex, hour, minute);
    mWorkersMap.insert(alarmIndex, worker);
    worker->moveToThread(thread);

    QObject::connect(thread, &QThread::started, worker, &AlarmWorker::start);
    QObject::connect(worker, &AlarmWorker::finished, thread, &QThread::quit);
    QObject::connect(worker, &AlarmWorker::finished, this, &AlarmSession::onAlarmFinished);

    QObject::connect(thread, &QThread::finished, thread, &AlarmWorker::deleteLater);
    QObject::connect(worker, &AlarmWorker::finished, worker, &AlarmWorker::deleteLater);

    thread->start();
}

void AlarmSession::removeThread(int alarmIndex)
{
    mWorkersMap[alarmIndex]->stop();
    mWorkersMap.remove(alarmIndex);
}

void AlarmSession::updateTime(int alarmIndex, int hour, int minute)
{
    mWorkersMap[alarmIndex]->updateTime(hour, minute);
}

void AlarmSession::onAlarmFinished(int index)
{
    emit alarmRingTime(index);
}
