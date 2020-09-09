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
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/kdab/training/MyService",
                                                  "startMyService",
                                                  "(Landroid/content/Context;)V",
                                                  QtAndroid::androidActivity().object());
#endif

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

void AlarmSession::updateDays(int alarmIndex, bool days[])
{
    if (mWorkersMap.find(alarmIndex) != mWorkersMap.end())
    {
        mWorkersMap[alarmIndex]->updateDays(days);
    }
}

void AlarmSession::stopSong(int index)
{
    if (mWorkersMap.find(index) != mWorkersMap.end())
    {
        mWorkersMap[index]->stopSong();
    }
}

void AlarmSession::clearTimer(int index)
{
    delete mWorkersMap[index];
    mWorkersMap.remove(index);
}

void AlarmSession::onAlarmDone(int index, bool isRepeatable)
{
    if (!isRepeatable)
        mWorkersMap[index]->stopTimer();
    mWorkersMap[index]->playSong();
    emit alarmRingTime(index, isRepeatable);
}
