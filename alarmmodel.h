#ifndef ALARMMODEL_H
#define ALARMMODEL_H
#include <QObject>
#include <QAbstractListModel>
#include <QVector>
#include <QDebug>
#include <QDateTime>
#include <QMap>

#include "alarmsession.h"

#define DAYS_IN_WEEK 7

struct AlarmData
{
    int hour;
    int minute;
    bool isEnabled;
    QString description;
    QString createDate;
    bool isSelected;
    bool repeatOnDays[DAYS_IN_WEEK];
};

class AlarmModel : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_INVOKABLE void add(int hour, int minute);
    Q_INVOKABLE void updateTime(int index, int hour, int minute);
    Q_INVOKABLE void updateDescription(int index, const QString& description);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void unselectItems();
    Q_INVOKABLE int selectedItemIndex();
    Q_INVOKABLE void setSession(AlarmSession* session);
    Q_INVOKABLE QString getTime(int index);
    Q_INVOKABLE QString getDescription(int index);
    Q_INVOKABLE void updateRepeatOnDays(int index, int day, bool value);

    enum
    {
        TimeRole = Qt::UserRole + 1,
        IsEnabledRole,
        DescriptionRole,
        CreateDateRole,
        IsSelectedRole,
        HourRole,
        MinuteRole,
        RepeatOnDaysRole
    };

public:
    AlarmModel(QObject *parent = 0);

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex &index) const;
    QHash<int, QByteArray> roleNames() const;

    static QString formatTime(int hour, int minute);
    static QString currentDate();

private:
    QVector<AlarmData> mAlarmsData;
    AlarmSession* mSession;
};

#endif // ALARMMODEL_H
