# YouPHPTube

This is a docker implementation of [YouPHPTube](https://github.com/DanielnetoDotCom/YouPHPTube). It includes the encoder at your.host.name/encoder. Follow the encoder setup [here](https://tutorials.youphptube.com/video/streamer-and-encoder), otherwise you won't be able to upload any of your videos or transcode them.

## Database

This implementation requires a separate container for the MySQL database. I use mariadb. Follow these steps to set it up:

Start a new instance by executing the following (obviously set a real password and map an external location so that your database is preserved when the container is removed): 

`docker run --name mariadb-utube --rm -e MYSQL_ROOT_PASSWORD='yourPASSWDhere' -v /some/external/location:/var/lib/mysql -d mariadb:latest`


#### Note: by default, no connections to the db are allowed except from localhost. Since you are running it in a separate container, you MUST change that!

With the mariadb container running, execute the following commands to set privileges on the database container and allow outside connections:
```
docker exec -it mariadb-utube bash
mysql
show databases;
Grant All Privileges ON *.* to 'root'@'%' Identified By 'yourPASSWDhere';
flush privileges;
```

## Running

Execute this command to get a new instance of youphptube stood up. Obviously replace `/some/external/location/` with an appropriate place where you will keep the videos.
```
docker run --name=youphptube \
--rm \
--link mariadb-utube:mariadb-utube \
-p 9988:80 \
-v /some/external/location/videos:/var/www/html/videos \
-v /some/external/location/encoder/videos:/var/www/html/encoder/videos \
-d achaiah/youphptube
```

### Description of parameters

#### Name
```--name=youphptube```

This is the name that identifies your docker container - you can choose any name.

#### Link
```--link mariadb-utube:mariadb-utube```

The first "mariadb-utube" before the colon is the name of your already running mariadb container.  The second "mariadb-utube" after the colon is the database hostname that you will use during the install process.

#### Detatch
```-d```

This will cause the docker container to run in the background

#### Port
```-p 9988:80```

This will map port 80 inside the container to port 9988 on your docker host server. Feel free to change the docker host port to whatever you want.

#### Volume
```-v /some/external/location/videos:/var/www/html/videos```

This parameter is important.  This will provide a way for the container to save all videos on your docker host machine so they are available when this docker container is restarted.  YouPHPTube also stores its configuration in this directory.

## Installing

Once you have the container running as described in the "running" step above, you will browse to your host server at the port you specified.  This should take you to the install screen for YouPHPTube.  Fill in all of the parameters.  For the Database host, make sure to fill in what you used in the --link paremeter for your container.  If you followed the above example, the Database host will be "mariadb-utube".

You will also need to set up the encoder information as well. Watch the video linked at the beginning of this README and follow the instructions. The encoder is reachable at `your.docker.host:9988/encoder`


## Notes

### Videos directory

If you get a note on the install page that your videos directory must be writable, this is because you should be running the application in docker, but mounting a directory from your host into the application container.  Make sure the directory on your host has open permissions by using the following command (on your docker host machine):

```
chmod 777 /path/to/videos
```

