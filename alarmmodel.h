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
    bool isSelected;
};

class AlarmModel : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_INVOKABLE void add(const QString& hour, const QString& minute);
    Q_INVOKABLE void updateTime(int index, const QString& hour, const QString& minute);
    Q_INVOKABLE void updateDescription(int index, const QString& description);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void unselectItems();
    Q_INVOKABLE int selectedItemIndex();

    enum
    {
        TimeRole = Qt::UserRole + 1,
        IsEnabledRole,
        DescriptionRole,
        CreateDateRole,
        IsSelectedRole
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
};

#endif // ALARMMODEL_H
