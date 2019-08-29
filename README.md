# Docker PHP, Apache and IBM_DB2
Inspired by https://github.com/keboola/db-extractor-db2

Base configuration files to generate a Docker container with PHP, Apache and IBM_DB2 support. 

This is a proof of concept on how to install IBM_DB2 with the IBM Db2 driver.

It provides a very crude web API to which you can send SQL queries and retrieve the results in JSON format.

⚠ **WARNING: Queries are executed literally. This provides no security whatsoever.**

### Setup

You can build it yourself as follows.

1. Clone the project.

2. DS Driver is versioned through Git LFS, but if for some reason you need to donwload it manually, backup link is below. Put it into the `php_apache` directory:
    * The IBM Data Server Driver Package (DS Driver), from the IBM website (as of 2019-08-29):  
    Tested with version 11.5 for Linux AMD64 and Intel EM64 architecture.  
    https://www-01.ibm.com/marketing/iwm/iwm/web/pickUrxNew.do?source=swg-idsdpds  
    (requires login. See below.)

3. Copy `.env.dist` into `.env` and set your connection settings in that file.

>Since the IBM site is a real PITA, has changed multiple times, requires an account, and we have no guarantee that these files won't disappear overnight, here's a direct link to a working version:  
https://mega.nz/#!JU5FUKhI!YM9Rn457Qd2hUUarZVjimdsMahC6XGX8FKjR41V06fg  
And here's a link to the ibm_db2 source, just in case:  
https://mega.nz/#!UMwFkY5K!tPB4sWpLvLaMlrYT8zDt97seSenkEj0aPVE12stsdsI

### Build...

4. Build the image:  
`docker build -t phpdb2 .`

5. When containers are to be created, note that you must set the Infomix server IP:  
`docker run -d -p 80:80 -v /var/www/html:/var/www/html`.

### Or,
Run the project with docker-compose:\
`docker-compose up`

Open `localhost` in your browser to see if it's working.

You should see something like this:  
```json
[{"1":"2019-08-29"}]
```

Declare the `db2.local` domain for clarity.

You can pass URL encoded SQL queries as get parameter like this:
```
http://db2.local/?query=SELECT%20current%20date%20FROM%20sysibm.sysdummy1;
```

## Development notes

I tried to build an Alpine based image, but then PHP would always segfault.