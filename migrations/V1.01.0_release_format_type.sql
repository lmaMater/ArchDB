DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type
    WHERE typname = 'release_format'
  ) THEN
    CREATE TYPE release_format AS ENUM (
      'single',
      'ep',
      'lp'
    );
  END IF;
END $$;
