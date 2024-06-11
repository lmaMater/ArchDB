DO
$$
DECLARE
    table_record RECORD;
    enum_record RECORD;
BEGIN
    -- Удаляем все таблицы
    FOR table_record IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(table_record.table_name) || ' CASCADE;';
    END LOOP;

    -- Удаляем все перечисления (типы)
    FOR enum_record IN
        SELECT typname
        FROM pg_type
        WHERE typcategory = 'E' AND typnamespace = 'public'::regnamespace
    LOOP
        EXECUTE 'DROP TYPE IF EXISTS ' || quote_ident(enum_record.typname) || ';';
    END LOOP;
END
$$;
