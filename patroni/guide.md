# Инструкция по управлению кластером

## Определение лидера кластера

1. Определим лидера кластера, выполнив следующую команду:

    ```bash
    docker exec -it demo-patroni1 patronictl list
    ```
#### ex:
>docker exec -it demo-patroni1 patronictl list
+ Cluster: demo (7383026034948030487)--------+----+-----------+
| Member   | Host       | Role    | State     | TL | Lag in MB |
+----------+------------+---------+-----------+----+-----------+
| patroni1 | 172.28.0.6 | Replica | streaming |  1 |         0 |
| patroni2 | 172.28.0.3 | Replica | streaming |  1 |         0 |
| patroni3 | 172.28.0.4 | Leader  | running   |  1 |           |
+----------+------------+---------+-----------+----+-----------+

> demo-patroni3 лидер (далее demo-patroni-leader)

## Создание пользователей и базы данных
Можно сразу накатить бэкап, созданный через pg_dumpall (см. след. пункт),
а также можно создать вручную:

1. Роль "user" с паролем "password":

    ```bash
    docker exec -it demo-patroni-leader psql -U postgres -c "CREATE ROLE \"user\" WITH LOGIN PASSWORD 'password';"
    ```

2. База данных с владельцем "user":

    ```bash
    docker exec -it demo-patroni-leader psql -U postgres -c "CREATE DATABASE patroni OWNER \"user\";"
    ```

3. Роли "reader", "writer" и "no_login_group":

    ```bash
    docker exec -it demo-patroni-leader psql -U postgres -c "CREATE ROLE reader;"
    docker exec -it demo-patroni-leader psql -U postgres -c "CREATE ROLE writer;"
    docker exec -it demo-patroni-leader psql -U postgres -c "CREATE ROLE no_login_group;"
    ```


## Восстановление резервной копии

1. Копируем файл с бэкапом с основной бд локально (dump.sql)

2. Копируем файл резервной копии из локальной машины в контейнер "demo-patroni-leader":

    ```bash
    docker cp dump.sql demo-patroni-leader:/dump.sql
    ```

3. Восстановливаем данные:

    ```bash
    docker exec -it demo-patroni-leader bash
    ~$ psql -U postgres -f /dump.sql
    ```

## Проверка

1. Выполняем следующую команду, чтобы проверить таблицы в реплике (у меня таблица "aoty"):
    ```bash
    docker exec -it demo-patroni-leader psql -U postgres -d aoty -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';"
    ```
