#ifndef ALARMMODEL_H
#define ALARMMODEL_H
#include <QObject>
#include <QAbstractListModel>
#include <QVector>
#include <QDebug>
#include <QDateTime>

struct AlarmData
{
    int hour;
    int minute;
    bool isEnabled;
    QString description;
    QString createDate;
};

class AlarmModel : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_INVOKABLE void add(const QString& hour, const QString& minute);
    Q_INVOKABLE void updateTime(int index, const QString& hour, const QString& minute);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE QString getDescription(int index);

    enum
    {
        TimeRole = Qt::UserRole + 1,
        IsEnabledRole,
        DescriptionRole,
        CreateDateRole
    };

public:
    AlarmModel(QObject *parent = 0);

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    static QString formatTime(int hour, int minute);
    static QString currentDate();

private:
    QVector<AlarmData> mAlarmsData;

};

#endif // ALARMMODEL_H
