/* GCompris - database-controller.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr> - 2023
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Schema designed with DbSchema: https://dbschema.com/
 * Documentation: https://dbschema.com/documentation/tutorial.html
 */

#ifndef DATABASECONTROLLER_H
#define DATABASECONTROLLER_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>

namespace controllers {

    class DatabaseController : public QObject
    {
        Q_OBJECT

    public:
        explicit DatabaseController(QObject *parent = nullptr);
        ~DatabaseController();

        Q_INVOKABLE bool isCrypted();
        Q_INVOKABLE bool isDatabaseLoaded();
        Q_INVOKABLE bool createTeacher(const QString &login, const QString &password, const bool crypted);
        Q_INVOKABLE bool checkTeacher(const QString &login, const QString &password);
        Q_INVOKABLE bool fileExists(const QString &databaseFile);
        Q_INVOKABLE bool isDatabaseLocked();
        Q_INVOKABLE QString selectToJson(const QString &req);
        Q_INVOKABLE int doRequest(const QString &req);

        Q_INVOKABLE void unloadDatabase();
        Q_INVOKABLE void loadDatabase(const QString &databaseFile);

        Q_INVOKABLE int addGroup(const QString &groupName, const QString &description = QString(), const QStringList &users = QStringList());
        Q_INVOKABLE int updateGroup(const int groupId, const QString &newGroupName, const QString &groupDescription);
        Q_INVOKABLE bool deleteGroup(const int groupId, const QString &groupName);

        Q_INVOKABLE int addUser(const QString &userName, const QString &userPass);
        Q_INVOKABLE bool updateUser(const int userId, const QString &userName, const QString &userPass);
        Q_INVOKABLE bool deleteUser(const int userId);

        Q_INVOKABLE bool addUserToGroup(const int userId, const int groupId);
        Q_INVOKABLE bool removeUserGroup(const int userId, const int groupId);
        Q_INVOKABLE bool removeAllGroupsForUser(const int userId);

        Q_INVOKABLE bool addDataToUser(const int userId, const QString &activityName, const QString &rawData, const bool success, const int duration);

        QList<QVariant> getActivityData(const int userId, const QString &activityName /*, range of date*/);

        Q_INVOKABLE int addDataset(const QString &datasetName, const int activityId, const QString &objective = QString(), const int difficulty = 1, const QString &content = QString());
        //Q_INVOKABLE int updateDataset(const int datasetId, const QString &datasetName,, const QString &objective = QString(), const int difficulty = 1, const QString &content = QString());
        Q_INVOKABLE bool deleteDataset(const int datasetId);

        /* ---------------------- */
        bool createRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const;
        bool deleteRow(const QString &tableName, const QString &id) const;
        QJsonArray find(const QString &tableName, const QString &searchText) const;
        QJsonObject readRow(const QString &tableName, const QString &id) const;
        bool updateRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const;

    Q_SIGNALS:
        void dbError(QStringList message);

    private:
        void triggerDBError(QSqlError sqlError, const QString &);
        bool initialise(const QString &databaseFile);
        QString sqliteVersion() const;
        bool createTable(const QString &sqlStatement, const QString &table) const;
        bool createTables();
        QString decryptText(const QString &value);
        QString encryptText(const QString &value);
        void setKey(const QString &teacherKey);
        bool sqlCommands(const QString &sqlFile);
        void checkDBVersion(int dbVersion);

    private:
        bool dbEncrypted;
        QSqlDatabase database;
        QSqlError error;
        QString teacherPasswordKey;
        QStringList cryptedFields;
        QStringList cryptedLists;
    };

}

#endif
