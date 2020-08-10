# Postgres

### postgres 数据导入导出

```shell
#导出sql文件
pg_dump -U postgres nap > nap.sql

#导入
drop database testdb; #删除原来的库

CREATE DATABASE testdb;

psql -U postgres -d nap -f nap.sql
```

