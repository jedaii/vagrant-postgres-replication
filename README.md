Vagrant поднимает несколько виртуальных машин с установленным и настроенным софтом:
- `master`  - мастер-нода postgresql
- `replica` - реплика-нода postgresql
- `wp`      - nginx + php-fpm + wordpress

## Параметры:
- `name`    - Имя виртуальной машины
- `nics`    - Описание сетевых интерфейсов
  - `type`  - Тип сети может быть `private_network` или `public_network`
  - `ip`    - IP адрес
- `ram`     - объем оперативной памяти
- `files`   - Файлы, которые будут помещены внутрь виртуальной машины (файлы копируются в каталог `/tmp`)
  - `source`- Путь к файлу
- `scripts` - Скрипты для провижнинга
  - `path`  - Путь к скрипту
- `dbuser`  - Пользователь базы данных postgresql
- `dbpassword` - Пароль пользователя `dbuser`
- `dbname`  - Имя базы данных postgresql

## Использование:
`git clone https://github.com/jedaii/vagrant-postgres-replication.git`
`cd vagrant-postgres-replication`
`vagrant up`