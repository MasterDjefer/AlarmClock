#ifndef ALARMSESSION_H
#define ALARMSESSION_H

#include <QObject>
#include <QThread>
#include <QMap>
#include <QTimer>
#include <QMediaPlayer>

#include "alarmworker.h"

class AlarmSessionData
{
private:
    AlarmWorker* mWorker;
    QTimer* mTimer;
    QMediaPlayer* mPlayer;

public:
    AlarmSessionData() : mWorker(nullptr), mTimer(nullptr), mPlayer(nullptr) {}
    AlarmSessionData(AlarmWorker* w, QTimer* t, QMediaPlayer* p) : mWorker(w), mTimer(t), mPlayer(p) {}
    ~AlarmSessionData()
    {
        if (mWorker)
            delete mWorker;
        if (mTimer)
            delete mTimer;
        if (mPlayer)
            delete mPlayer;
    }

    void updateSong(const QString& songPath)
    {
        if (mPlayer && !songPath.isEmpty())
        {
            mPlayer->setMedia(QUrl::fromLocalFile(songPath));
        }
    }
    void stopTimer()
    {
        if (mTimer)
        {
            mTimer->stop();
        }
    }

    void updateTime(int hour, int min)
    {
        if (mWorker)
        {
            mWorker->updateTime(hour, min);
        }
    }

    void updateDays(bool days[])
    {
        if (mWorker)
        {
            mWorker->updateDays(days);
        }
    }

    void playSong()
    {
        if (mPlayer && !mPlayer->media().isNull())
        {
            mPlayer->play();
        }
    }
    void stopSong()
    {
        if (mPlayer && !mPlayer->media().isNull())
        {
            mPlayer->stop();
        }
    }
};

class AlarmSession : public QObject
{
    Q_OBJECT
public:
    AlarmSession();
    void addTimer(int alarmIndex, int hour, int minute);
    void removeTimer(int alarmIndex);
    void updateTime(int alarmIndex, int hour, int minute);
    void updateSong(int alarmIndex, const QString& songPath);
    void updateDays(int alarmIndex, bool days[]);

    Q_INVOKABLE void stopSong(int index);

private:
    QMap<int, AlarmSessionData*> mWorkersMap;
    QMediaPlayer* mPlayer;

private:
    void clearTimer(int index);

public slots:
    void onAlarmDone(int index, bool isRepeatable);

signals:
    void alarmRingTime(int id, bool isRepeatable);
};

#endif // ALARMSESSION_H
