#ifndef ALARMMODEL_H
#define ALARMMODEL_H
#include <QObject>
#include <QAbstractListModel>
#include <QVector>
#include <QDebug>

struct AlarmData
{
    int hour;
    int minute;
    bool isEnabled;
    QString description;
};

class AlarmModel : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_INVOKABLE void add();
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE QString getDescription(int index);

    enum
    {
        TimeRole = Qt::UserRole + 1,
        IsEnabledRole,
        DescriptionRole
    };

public:
    AlarmModel(QObject *parent = 0);

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<AlarmData> mAlarmsData;

};

#endif // ALARMMODEL_H
