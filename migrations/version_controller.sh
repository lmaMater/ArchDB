#!/bin/bash

user="${USER}"
password="${PASSWORD}"

perform_migration() {
    local migrations_path="/docker-entrypoint-initdb.d/migrations"
    migration_version="${MIGRATION_VERSION}"

    if [[ -z "$MIGRATION_VERSION" ]]; then
        migration_version="1.21.0"
    else
        migration_version="$MIGRATION_VERSION"
    fi

    list="$(ls "$migrations_path" | sort -V)"
    for migration_file in $list; do
        export PGPASSWORD="${password}"
        psql -h db -U user -d aoty -f "$migrations_path/$migration_file" -W
        unset PGPASSWORD

        version_prefix=$(echo "$migration_file" | grep -oE "^V[0-9]+\.[0-9]+\.[0-9]+")

        if [[ "$version_prefix" == "$migration_version" ]]; then
            break
        fi
    done
}

create_roles() {
    export PGPASSWORD="${password}"
    psql -h db -U user -d aoty -c "CREATE ROLE reader WITH LOGIN;" -W
    psql -h db -U user -d aoty -c "CREATE ROLE writer WITH LOGIN;" -W
    psql -h db -U user -d aoty -c "CREATE ROLE no_access WITH NOLOGIN;" -W

    psql -h db -U user -d aoty -c "GRANT CONNECT ON DATABASE aoty TO reader, writer;" -W
    psql -h db -U user -d aoty -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;" -W
    psql -h db -U user -d aoty -c "GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO writer;" -W

    psql -h db -U user -d aoty -c "CREATE USER analytic;" -W
    psql -h db -U user -d aoty -c "GRANT SELECT on releases TO analytic;" -W

    psql -h db -U user -d aoty -c "CREATE ROLE no_login_group WITH NOLOGIN;" -W
    psql -h db -U user -d aoty -c "GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA public TO no_login_group;" -W

    psql -h db -U user -d aoty -c "CREATE USER user1 WITH PASSWORD 'user1';" -W
    psql -h db -U user -d aoty -c "GRANT CONNECT ON DATABASE aoty TO user1;" -W
    psql -h db -U user -d aoty -c "GRANT no_login_group TO user1;" -W

    psql -h db -U user -d aoty -c "CREATE USER user2 WITH PASSWORD 'user2';" -W
    psql -h db -U user -d aoty -c "GRANT CONNECT ON DATABASE aoty TO user2;" -W
    psql -h db -U user -d aoty -c "GRANT no_login_group TO user2;" -W

    psql -h db -U user -d aoty -c "CREATE USER user3 WITH PASSWORD 'user3';" -W
    psql -h db -U user -d aoty -c "GRANT CONNECT ON DATABASE aoty TO user3;" -W
    psql -h db -U user -d aoty -c "GRANT no_login_group TO user3;" -W

    unset PGPASSWORD
}


wait_for_db() {
    until pg_isready -h db -U user -d aoty; do
        echo "waiting for db"
        sleep 2
    done
    echo "DB ok!"
}

wait_for_db

perform_migration
create_roles

echo "close connection"
export PGPASSWORD="${password}"
psql -h db -U user -d aoty -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'aoty';" -W
unset PGPASSWORD

echo "migrations done + connection close"
echo "roles, users, and table access granted"