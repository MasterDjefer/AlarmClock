#include "alarmsession.h"

AlarmSession::AlarmSession()
{
    const QString songPath = "/home/predator/Music/Brati_Gadjukini-Fajne_misto_Ternopil-spaces.im.mp3";
    mPlayer = new QMediaPlayer;
    mPlayer->setMedia(QUrl::fromLocalFile(songPath));
    mPlayer->setVolume(100);
}

void AlarmSession::addTimer(int alarmIndex, int hour, int minute)
{
    AlarmWorker *worker = new AlarmWorker(alarmIndex, hour, minute);
    QTimer *timer = new QTimer;
    mWorkersMap.insert(alarmIndex, new AlarmSessionData(worker, timer, new QMediaPlayer));

    timer->setInterval(1000);

    QObject::connect(timer, &QTimer::timeout, worker, &AlarmWorker::start);
    QObject::connect(worker, &AlarmWorker::alarmDone, this, &AlarmSession::onAlarmDone);

    timer->start();
}

void AlarmSession::removeTimer(int alarmIndex)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex]->stopTimer();
        clearTimer(alarmIndex);
    }
}

void AlarmSession::updateTime(int alarmIndex, int hour, int minute)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex]->updateTime(hour, minute);
    }
}

void AlarmSession::updateSong(int alarmIndex, const QString &songPath)
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex]->updateSong(songPath);
    }
}

void AlarmSession::stopSong(int index)
{
    if (mWorkersMap.find(index) != mWorkersMap.end())
    {
        mWorkersMap[index]->stopSong();
        clearTimer(index);
    }
}

void AlarmSession::clearTimer(int index)
{
    delete mWorkersMap[index];
    mWorkersMap.remove(index);
}

void AlarmSession::onAlarmDone(int index)
{
    mWorkersMap[index]->stopTimer();
    mWorkersMap[index]->playSong();
    emit alarmRingTime(index);
}
