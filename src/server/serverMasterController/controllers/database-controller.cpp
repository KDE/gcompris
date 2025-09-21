#include "database-controller.h"

#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

#include <QtCrypto>

#include "models/GroupData.h"
#include "models/UserData.h"

#include "config/ServerSettings.h"

#define CREATE_TABLE_USERS                                              \
    "CREATE TABLE IF NOT EXISTS users (user_name TEXT PRIMARY KEY NOT NULL, dateOfBirth TEXT, password TEXT); "
#define CREATE_TABLE_GROUPS                                             \
    "CREATE TABLE IF NOT EXISTS groups (group_name TEXT PRIMARY KEY NOT NULL, description TEXT); "
#define CREATE_TABLE_USERGROUP                                          \
    "CREATE TABLE IF NOT EXISTS group_users(user_id INT NOT NULL, group_id INT NOT NULL, PRIMARY KEY (user_id, group_id));"
#define CREATE_TABLE_ACTIVITY_DATA                                      \
    "CREATE TABLE IF NOT EXISTS activity_data(user_id INT NOT NULL, activity_name TEXT NOT NULL, " \
    "date BIGINT NOT NULL,data TEXT NOT NULL,PRIMARY KEY(user_id,activity_name,date))"
#define CREATE_TABLE_TEACHERS                                              \
    "CREATE TABLE IF NOT EXISTS teachers (login TEXT PRIMARY KEY NOT NULL, password TEXT); "


static const char *AES_ALGORITHM = "aes128";
static const char *AES_ENCRYPTION = "aes128-cbc-pkcs7";
static const char *INITIALIZATION_VECTOR = "gcomprisInitialisationVector";

namespace controllers {

    class DatabaseController::Implementation
    {
    public:
        Implementation(const QString& databaseFile, DatabaseController *_databaseController) :
            databaseController(_databaseController)
        {
            if (initialise(databaseFile)) {
                qDebug() << "Database created using Sqlite version: " + sqliteVersion();
                if (createTables()) {
                    qDebug() << "Database tables created";
                }
                else {
                    qDebug() << "ERROR: Unable to create database tables";
                }
            }
            else {
                qDebug() << "ERROR: Unable to open database";
            }
        }

        bool isDatabaseLoaded()
        {
            return QSqlDatabase::contains("gcompris");
        }

        void unloadDatabase()
        {
            if (QSqlDatabase::contains("gcompris")) {
               database.close();
               database = QSqlDatabase();
               QSqlDatabase::removeDatabase("gcompris");
           }
        }

        void setKey(const QString &teacherKey) {
            teacherPasswordKey = teacherKey;
            QString test = "testé";
            QString dec = decryptText(encryptText(test));
            printf("Decrypt %s = %s\n",
                   qPrintable(QCA::arrayToHex(test.toUtf8())),
                   qPrintable(dec.toUtf8()));
        }

        QSqlDatabase database;

    private:

        DatabaseController *databaseController { nullptr };
        QString teacherPasswordKey;

        bool initialise(const QString& databaseFile)
        {
            database = QSqlDatabase::addDatabase("QSQLITE", "gcompris");
            database.setDatabaseName(databaseFile);
            if (!database.open()) {
                qDebug() << "Error: connection with database fail";
            }
            createTables();

            return database.open();
        }

        bool createTables()
        {
            bool res = createTable(CREATE_TABLE_USERS, "users");
            res &= createTable(CREATE_TABLE_GROUPS, "groups");
            res &= createTable(CREATE_TABLE_USERGROUP, "userGroups");
            res &= createTable(CREATE_TABLE_ACTIVITY_DATA, "activityData");
            res &= createTable(CREATE_TABLE_TEACHERS, "teachers");
            return res;
        }

        bool createTable(const QString &sqlStatement, const QString &table) const
        {
            QSqlQuery query(database);

            if (!query.prepare(sqlStatement))
                return false;
            if (!query.exec()) {
                qDebug() << "Unable to create table " << table;
            }
            return true;
        }

        QString sqliteVersion() const
        {
            QSqlQuery query(database);

            query.exec("SELECT sqlite_version()");

            if (query.next())
                return query.value(0).toString();

            return QString::number(-1);
        }

        QString decryptText(const QString &value) {
            // AES128 testing
            if (!QCA::isSupported(AES_ENCRYPTION)) {
                printf("AES128-CBC not supported!\n");
                return "";
            }
            else {
                qDebug() << "JJ" << teacherPasswordKey.toUtf8();
                QCA::SymmetricKey key(teacherPasswordKey.toUtf8());
 
                // Create a random initialisation vector - you need this
                // value to decrypt the resulting cipher text, but it
                // need not be kept secret (unlike the key).
                QCA::InitializationVector iv(QByteArray{INITIALIZATION_VECTOR});

                // create a 128 bit AES cipher object using Cipher Block Chaining (CBC) mode
                QCA::Cipher cipher(AES_ALGORITHM,
                                   QCA::Cipher::CBC,
                                   // use Default padding, which is equivalent to PKCS7 for CBC
                                   QCA::Cipher::DefaultPadding,
                                   // this object will decrypt
                                   QCA::Decode,
                                   key,
                                   iv);

                QCA::SecureArray encryptedData = QCA::SecureArray(QCA::hexToArray(value));
                QCA::SecureArray decryptedData = cipher.process(encryptedData);
 
                // check if the update() call worked
                if (!cipher.ok()) {
                    printf("Update failed\n");
                }

                return QString(decryptedData.data());
            }
        }

            QString encryptText(const QString &value) {
                // AES128 testing
                if (!QCA::isSupported(AES_ENCRYPTION)) {
                    printf("AES128-CBC not supported!\n");
                    return "";
                }
                else {
                    QCA::SymmetricKey key(teacherPasswordKey.toUtf8());
 
                    // Create a random initialisation vector - you need this
                    // value to decrypt the resulting cipher text, but it
                    // need not be kept secret (unlike the key).
                    QCA::InitializationVector iv(QByteArray{INITIALIZATION_VECTOR});

                    // create a 128 bit AES cipher object using Cipher Block Chaining (CBC) mode
                    QCA::Cipher cipher(AES_ALGORITHM,
                                       QCA::Cipher::CBC,
                                       // use Default padding, which is equivalent to PKCS7 for CBC
                                       QCA::Cipher::DefaultPadding,
                                       // this object will encrypt
                                       QCA::Encode,
                                       key,
                                       iv);
                    QCA::SecureArray secureData = value.toUtf8();
                    QCA::SecureArray encryptedData = cipher.process(secureData);

                    return QString(qPrintable(QCA::arrayToHex(encryptedData.toByteArray())));
                }
            }
        };
}

namespace controllers {

DatabaseController::DatabaseController(QObject *parent) :
    QObject(parent)
{
}

DatabaseController::~DatabaseController()
{
}

bool DatabaseController::isDatabaseLoaded()
{
    return implementation->isDatabaseLoaded();
}

void DatabaseController::unloadDatabase()
{
    implementation->unloadDatabase();
}

void DatabaseController::loadDatabase(const QString &databaseFile)
{
    implementation.reset(new Implementation(databaseFile, this));
}

bool DatabaseController::createTeacher(const QString &login, const QString &password) {
    QString encryptedPassword;
    if(!QCA::isSupported("sha256")) {
        qDebug() << "SHA256 not supported!";
    }
    else {
        QByteArray hashResult = QCA::Hash("sha256").hash(password.toUtf8()).toByteArray();
        encryptedPassword = QString(qPrintable(QCA::arrayToHex(hashResult)));
    }

    QSqlQuery query(implementation->database);
    query.prepare("SELECT ROWID, * FROM teachers WHERE login=:login");
    query.bindValue(":login", login);
    query.exec();
    if (query.next()) {
        qDebug() << "login" << login << "does already exist";
        return false;
    }
    query.prepare("INSERT INTO teachers (login, password) VALUES(:login, :password)");
    query.bindValue(":login", login);
    query.bindValue(":password", encryptedPassword);
    int teacherId;
    if (!query.exec()) {
        qDebug() << query.lastError();
        return teacherId;
    }
    teacherId = query.lastInsertId().toInt();

    return teacherId;
}

bool DatabaseController::checkTeacher(const QString &login, const QString &password) {
    QString encryptedPassword;
    if(!QCA::isSupported("sha256")) {
        qDebug() << "SHA256 not supported!";
    }
    else {
        QByteArray hashResult = QCA::Hash("sha256").hash(password.toUtf8()).toByteArray();
        encryptedPassword = QString(qPrintable(QCA::arrayToHex(hashResult)));
    }

    QSqlQuery query(implementation->database);
    query.prepare("SELECT ROWID, * FROM teachers WHERE login=:login AND password=:password");
    query.bindValue(":login", login);
    query.bindValue(":password", encryptedPassword);
    query.exec();
    if (!query.next()) {
        qDebug() << "login " << login << " does not already exist or incorrect password";
        implementation->setKey("");
        return false;
    }
    else {
        // We successfully logged as 'login', we use 'password' as key
        implementation->setKey(password);
        return true;
    }
}

void DatabaseController::retrieveAllExistingGroups(QList<GroupData *> &allGroups)
{
    // Don't add twice the same login
    QSqlQuery query(implementation->database);
    query.prepare("SELECT ROWID, * FROM groups");
    query.exec();
    const int groupId = query.record().indexOf("ROWID");
    const int nameIndex = query.record().indexOf("group_name");
    const int descriptionIndex = query.record().indexOf("description");
    while (query.next()) {
        GroupData *g = new GroupData();
        g->setPrimaryKey(query.value(groupId).toInt());
        g->setName(query.value(nameIndex).toString());
        g->setDescription(query.value(descriptionIndex).toString());
        allGroups.push_back(g);
    }
}

int DatabaseController::addGroup(const QString &groupName, const QString &description, const QStringList &users)
{
    int groupId = -1;
    QSqlQuery query(implementation->database);
    // add group to db only if it has not been added before
    query.prepare("SELECT group_name FROM groups WHERE group_name=:groupName");
    query.bindValue(":groupName", groupName);
    query.exec();
    if (query.next()) {
        qDebug() << "group " << groupName << " already exists";
        return groupId;
    }
    // since the group does not exist, create the new group and add description and users to it
    query.prepare("INSERT INTO groups (group_name, description) VALUES (:groupName,:description)");
    query.bindValue(":groupName", groupName);
    query.bindValue(":description", description);
    bool groupAdded = query.exec();
    if (groupAdded) {
        //add users to the group
        for (const auto &user: users) {
            //addUserToGroup(groupName, user);
        }
    }
    else
        qDebug() << "group could not be added " << query.lastError();
    groupId = query.lastInsertId().toInt();
    return groupId;
}

int DatabaseController::updateGroup(const GroupData &oldGroup, const QString &newGroupName)
{
    bool groupUpdated = false;
    QSqlQuery query(implementation->database);

    QString sqlStatement = "UPDATE groups SET group_name=:newName WHERE ROWID=:id";

    if (!query.prepare(sqlStatement))
        return false;

    query.bindValue(":id", oldGroup.getPrimaryKey());
    query.bindValue(":newName", newGroupName);

    if (!query.exec()) {
        qDebug() << "group" << oldGroup.getName() << "could not be updated to" << newGroupName << ": " << query.lastError();
        return false;
    }

    return query.numRowsAffected() > 0;
}

bool DatabaseController::deleteGroup(const GroupData &group)
{
    bool groupDeleted = false;
    QSqlQuery query(implementation->database);
    query.prepare("DELETE FROM groups WHERE group_name=:gname");
    query.bindValue(":gname", group.getName());
    if (query.exec()) {
        query.prepare("DELETE FROM group_users WHERE group_id=:gid");
        query.bindValue(":gid", group.getPrimaryKey());
        if (query.exec())
            groupDeleted = true;
    }
    return groupDeleted;
}

void DatabaseController::retrieveAllExistingUsers(QList<UserData *> &allUsers)
{
    QSqlQuery query(implementation->database);
    query.prepare("SELECT ROWID, * FROM users");
    query.exec();
    const int rowId = query.record().indexOf("ROWID");
    const int nameIndex = query.record().indexOf("user_name");
    const int dateIndex = query.record().indexOf("dateOfBirth");
    const int passwordIndex = query.record().indexOf("password");
    while (query.next()) {
        UserData *u = new UserData();
        u->setPrimaryKey(query.value(rowId).toInt());
        u->setName(query.value(nameIndex).toString());
        u->setDateOfBirth(query.value(dateIndex).toString());
        u->setPassword(query.value(passwordIndex).toString());
        allUsers.push_back(u);
    }
}

int DatabaseController::addUser(const UserData &user)
{
    // check whether user already exists before adding to database
    int userId = -1;
    QSqlQuery query(implementation->database);
    query.prepare("SELECT user_name FROM users WHERE user_name=:name");
    query.bindValue(":name", user.getName());
    query.exec();
    if (query.next()) {
        qDebug() << "user " << user.getName() << "already exists";
        return userId;
    }
    query.prepare("INSERT INTO users (user_name, dateOfBirth, password) VALUES(:name, :dateOfBirth, :password)");
    query.bindValue(":name", user.getName());
    query.bindValue(":dateOfBirth", user.getDateOfBirth());
    query.bindValue(":password", user.getPassword());
    if (!query.exec()) {
        qDebug() << query.lastError();
        return userId;
    }
    userId = query.lastInsertId().toInt();

    return userId;
}

bool DatabaseController::deleteUser(const UserData &user)
{
    bool userDeleted = false;
    QSqlQuery query(implementation->database);
    query.prepare("DELETE FROM users WHERE user_name=:name");
    query.bindValue(":name", user.getName());
    if (query.exec()) {
        if (removeAllGroupsForUser(user)) {
            query.prepare("DELETE FROM activity_data WHERE user_name=:name");
            query.bindValue(":name", user.getName());
            if (query.exec()) {
                userDeleted = true;
            }
            else {
                qDebug() << query.executedQuery() << " failed";
            }
        }
        else {
            qDebug() << query.executedQuery() << " failed";
        }
    }
    else {
        qDebug() << query.executedQuery() << " failed";
    }
    return userDeleted;
}

void DatabaseController::recreateAllLinksBetweenGroupsAndUsers(QList<GroupData *> &groups, QList<UserData *> &users)
{
    QSqlQuery query(implementation->database);
    query.prepare("SELECT * FROM group_users");
    query.exec();
    const int userIndex = query.record().indexOf("user_id");
    const int groupIndex = query.record().indexOf("group_id");
    while (query.next()) {
        int groupId = query.value(groupIndex).toInt();
        auto groupIterator = std::find_if(std::begin(groups), std::end(groups),
                                          [&groupId](GroupData *group) {
                                              return group->getPrimaryKey() == groupId;
                                          });
        GroupData *group = *groupIterator;
        int userId = query.value(userIndex).toInt();
        auto userIterator = std::find_if(std::begin(users), std::end(users),
                                         [&userId](UserData *user) {
                                             return user->getPrimaryKey() == userId;
                                         });
        UserData *user = *userIterator;
        qDebug() << "Adding" << group->getName() << "to" << user->getName();
        user->addGroup(group);
    }
}

bool DatabaseController::removeAllGroupsForUser(const UserData &user)
{
    bool groupsRemoved = false;
    QSqlQuery query(implementation->database);
    query.prepare("DELETE FROM group_users WHERE user_id=:name");
    query.bindValue(":name", user.getPrimaryKey());
    if (query.exec()) {
        groupsRemoved = true;
    }
    else {
        qDebug() << query.executedQuery() << " failed";
    }
    return groupsRemoved;
}

bool DatabaseController::addUserToGroup(const UserData &user, const GroupData &group)
{
    // insert in table group_users
    // add (user, group) to db only if they don't exist
    bool userAdded = false;
    QSqlQuery query(implementation->database);
    query.prepare("SELECT * FROM group_users WHERE user_id=:user and group_id=:group");
    query.bindValue(":user", user.getPrimaryKey());
    query.bindValue(":group", group.getPrimaryKey());
    query.exec();
    if (query.next()) {
        qDebug() << "user " << user.getName() << "already exists in group " << group.getName();
        return -1;
    }
    query.prepare("INSERT INTO group_users (user_id, group_id) values(:user,:group)");
    query.bindValue(":user", user.getPrimaryKey());
    query.bindValue(":group", group.getPrimaryKey());
    userAdded = query.exec();
    if (!userAdded) {
        qDebug() << "user could not be added " << query.lastError();
    }
    return userAdded;
}

bool DatabaseController::removeUserToGroup(const UserData &user, const GroupData &group)
{
    bool userGroupRemoved = false;
    QSqlQuery query(implementation->database);
    query.prepare("DELETE FROM group_users WHERE user_id=:user and group_id=:group");
    query.bindValue(":user", user.getPrimaryKey());
    query.bindValue(":group", group.getPrimaryKey());
    query.exec();
    userGroupRemoved = query.exec();
    if (!userGroupRemoved) {
        qDebug() << "user-group could not be added " << query.lastError();
    }
    return userGroupRemoved;
}

bool DatabaseController::addDataToUser(const UserData &user, const QString& activity, qint64 timestamp, const QString &rawData)
{
    // insert in table activity_data
    //activity_data(user_id TEXT NOT NULL, activity_name TEXT NOT NULL, date INT NOT NULL,data TEXT NOT NULL)
    bool dataAdded = false;
    QSqlQuery query(implementation->database);
    query.prepare("INSERT INTO activity_data (user_id, activity_name, date, data) values(:user,:activity, :date, :data)");
    query.bindValue(":user", user.getPrimaryKey());
    query.bindValue(":activity", activity);
    query.bindValue(":date", timestamp);
    query.bindValue(":data", rawData);
    dataAdded = query.exec();
    if (!dataAdded) {
        qDebug() << "data could not be added " << query.lastError() << "for user" << user.getName();
    }
    return dataAdded;
}

#include <QJsonDocument>
// QMap with key the date?
QList<QVariant> DatabaseController::getActivityData(const UserData &user, const QString &activity /*, range of date*/) {
    QSqlQuery query(implementation->database);
    query.prepare("SELECT ROWID, * FROM activity_data WHERE user_id IN (:uid) AND activity_name IN (:activity)");
    query.bindValue(":uid", user.getPrimaryKey());
    query.bindValue(":activity", activity);
    query.exec();
    const int dataIndex = query.record().indexOf("data");
    const int dateIndex = query.record().indexOf("date");
    QList<QVariant> fetchedData;
    qDebug() << "Found" << query.size() << "records";
    while (query.next()) {
        QVariant data = query.value(dataIndex);
        QJsonDocument doc = QJsonDocument::fromJson(data.toByteArray());
        QJsonObject obj = doc.object();
        obj["date"] = query.value(dateIndex).toLongLong();
        doc.setObject(obj);
        QVariant dataWithDate = doc.toJson(QJsonDocument::Compact);
        fetchedData << dataWithDate;
    }
    return fetchedData;
}
/*----------------------------------------------*/
bool DatabaseController::createRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const
{
    if (tableName.isEmpty())
        return false;
    if (id.isEmpty())
        return false;
    if (jsonObject.isEmpty())
        return false;

    QSqlQuery query(implementation->database);

    QString sqlStatement = "INSERT OR REPLACE INTO " + tableName + " (id, json) VALUES (:id, :json)";

    if (!query.prepare(sqlStatement))
        return false;

    query.bindValue(":id", QVariant(id));
    query.bindValue(":json", QVariant(QJsonDocument(jsonObject).toJson(QJsonDocument::Compact)));

    if (!query.exec())
        return false;

    return query.numRowsAffected() > 0;
}

bool DatabaseController::deleteRow(const QString &tableName, const QString &id) const
{
    if (tableName.isEmpty())
        return false;
    if (id.isEmpty())
        return false;

    QSqlQuery query(implementation->database);

    QString sqlStatement = "DELETE FROM " + tableName + " WHERE id=:id";

    if (!query.prepare(sqlStatement))
        return false;

    query.bindValue(":id", QVariant(id));

    if (!query.exec())
        return false;

    return query.numRowsAffected() > 0;
}

QJsonArray DatabaseController::find(const QString &tableName, const QString &searchText) const
{
    if (tableName.isEmpty())
        return {};
    if (searchText.isEmpty())
        return {};

    QSqlQuery query(implementation->database);

    QString sqlStatement = "SELECT json FROM " + tableName + " where lower(json) like :searchText";

    if (!query.prepare(sqlStatement))
        return {};

    query.bindValue(":searchText", QVariant("%" + searchText.toLower() + "%"));

    if (!query.exec())
        return {};

    QJsonArray returnValue;

    while (query.next()) {
        auto json = query.value(0).toByteArray();
        auto jsonDocument = QJsonDocument::fromJson(json);
        if (jsonDocument.isObject()) {
            returnValue.append(jsonDocument.object());
        }
    }

    return returnValue;
}

QJsonObject DatabaseController::readRow(const QString &tableName, const QString &id) const
{
    if (tableName.isEmpty())
        return {};
    if (id.isEmpty())
        return {};

    QSqlQuery query(implementation->database);

    QString sqlStatement = "SELECT json FROM " + tableName + " WHERE id=:id";

    if (!query.prepare(sqlStatement))
        return {};

    query.bindValue(":id", QVariant(id));

    if (!query.exec())
        return {};

    if (!query.first())
        return {};

    auto json = query.value(0).toByteArray();
    auto jsonDocument = QJsonDocument::fromJson(json);

    if (!jsonDocument.isObject())
        return {};

    return jsonDocument.object();
}

bool DatabaseController::updateRow(const QString &tableName, const QString &id, const QJsonObject &jsonObject) const
{
    if (tableName.isEmpty())
        return false;
    if (id.isEmpty())
        return false;
    if (jsonObject.isEmpty())
        return false;

    QSqlQuery query(implementation->database);

    QString sqlStatement = "UPDATE " + tableName + " SET json=:json WHERE id=:id";

    if (!query.prepare(sqlStatement))
        return false;

    query.bindValue(":id", QVariant(id));
    query.bindValue(":json", QVariant(QJsonDocument(jsonObject).toJson(QJsonDocument::Compact)));

    if (!query.exec())
        return false;

    return query.numRowsAffected() > 0;
}
}
