CREATE ROLE root superuser;
ALTER ROLE root WITH LOGIN;
CREATE DATABASE root;

CREATE DATABASE prefect;
CREATE USER prefect WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE prefect to prefect;

CREATE DATABASE juicefs;
CREATE USER juicefs WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE juicefs to juicefs;