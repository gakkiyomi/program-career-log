# Mongo

### mongo 数据导入导出

>mongodb数据备份和恢复主要分为二种：一种是针对库的mongodump和mongorestore，一种是针对库中表的mongoexport和mongoimport

~~~shell
#导出指定数据库

mongodump -d nap -o /data/mongobak/nap/

#导入指定数据库
use db_name;
db.dropDatabase()
mongorestore -d nap /data/mongobak/nap/

#导出指定文档
mongoexport -d nap -c cisco_hit_count_config_t2 -o cisco_hit_count.json

#导入指定文档
mongoimport -d nap -c cisco_hit_count_config_t2 cisco_hit_count.json
~~~

**mongodump**和**mongorestore** 不需要重新构建索引,**mongoexport**和**mongoimport**则需要重新构建索引

