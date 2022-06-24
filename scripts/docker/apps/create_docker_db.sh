#!/bin/bash
# Utility script that inits user names used in scripts.

printUsage() {
  printf "Usage:
     [-i <name of to image> e.g. eex-mysql-8]
     [-c <name of docker container> e.g. mysql-1]
     [-n <name of database> e.g. financial-services ]
     [-p <port to use. The port must be unique!> e.g. 33036]
     [-d <docker image> e.g. mysql:8]" >&2
  exit 2
}

NR_OF_ARGS=10
if [ "$#" -ne "$NR_OF_ARGS" ]; then
  echo "Got $# arguments expecting $NR_OF_ARGS!" >&2
  printUsage
  exit 1
fi

DB_NAME=
DB_PORT=
IMAGE_NAME=
CONTAINER_NAME=
DOCKER_IMAGE=
DB_PASSWORD=herron1
HOST="herron@docker"
while getopts 'i:c:n:p:d:h' OPTION; do
  case $OPTION in
  i)
    IMAGE_NAME="${OPTARG}"
    ;;
  c)
    CONTAINER_NAME="${OPTARG}"
    ;;
  n)
    DB_NAME="${OPTARG}"
    ;;
  p)
    DB_PORT="${OPTARG}"
    ;;
  d)
    DOCKER_IMAGE="${OPTARG}"
    ;;
  h | *)
    printUsage
    exit 1
    ;;
  esac
done

# Check port is available
USED_PORTS=$(ssh "$HOST" 'docker ps --all --format "table {{.Ports}}" | sed -r "s/.*:(.*)->.*/\1/" | grep -v -e "^$" | grep -E -o "[0-9]+"')
if [[ "$USED_PORTS" == *"$DB_PORT"* ]]; then
  echo "Port $DB_PORT is already used."
  echo "Select port not in:\n $USED_PORTS"
  exit 1
fi

# Create local tmp dir
TEMP_DIR="tmp_$(date '+%Y-%m-%d')"
mkdir "$TEMP_DIR"

# Create init.sql
SQL_FILE="$TEMP_DIR/init.sql"
if test -f "${SQL_FILE}"; then
  echo "Removing old sql file and creating new one."
  rm -rf "${SQL_FILE}"
fi
echo "CREATE DATABASE ${DB_NAME} character set utf8 collate utf8_general_ci;
     CREATE USER 'herron'@'%' IDENTIFIED BY '$DB_PASSWORD';
     GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO 'herron'@'%' WITH GRANT OPTION;
     FLUSH PRIVILEGES;" >> "$SQL_FILE"

# Create Dockerfile
DOCKER_FILE="$TEMP_DIR/Dockerfile"
if test -f "${DOCKER_FILE}"; then
  echo "Removing old docker file and creating new one."
  rm -rf "${DOCKER_FILE}"
fi
echo "FROM $DOCKER_IMAGE
      ADD init.sql /docker-entrypoint-initdb.d" >>"$DOCKER_FILE"

# Move Files to remote
rsync -P -r "$TEMP_DIR" "$HOST":

# Create Image
ssh "$HOST" "cd $TEMP_DIR && docker build -t $IMAGE_NAME ./"

# Start Container
ssh "$HOST" "cd $TEMP_DIR && docker run --detach -p $DB_PORT:3306 -e MYSQL_ROOT_PASSWORD=$DB_PASSWORD --name $CONTAINER_NAME $IMAGE_NAME"

# Remove local and remote tmp dir
rm -r "$TEMP_DIR"
ssh "$HOST" "rm -r $TEMP_DIR"