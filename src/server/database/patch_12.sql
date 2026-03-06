PRAGMA writable_schema = 1;
UPDATE SQLITE_MASTER SET SQL = 'CREATE TABLE user_ ( user_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , user_name TEXT NOT NULL , user_password TEXT , CONSTRAINT unq_user_name UNIQUE ( user_name ) )
' WHERE NAME = 'user_';
PRAGMA writable_schema = 0;
