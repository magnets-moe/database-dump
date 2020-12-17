# database-dump

This repository contains a dump of the Magnets.moe database. It's updated once per day.

## Loading

To load the contents of the dump into a new database, you have to use the `dump` program from https://github.com/magnets-moe/Magnets.moe. Compile it as described there.

Afterwards you can load the database as in the following example. We're assuming the database is called `magnets`:

```bash
psql -f ddl/pre-data.sql magnets postgres
dump --connection-string "host=/run/postgresql user=postgres dbname=magnets" load
psql -f ddl/post-data.sql magnets postgres
```
