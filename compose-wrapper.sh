#!/bin/bash
# hhj, 13.9.2016

case $1 in
	hot|dev|stage|prod)
		PHASE=$1
		shift
		CONFIG_DIR="$(realpath .docker/${PHASE})"
		;;
	*)
		PHASE="dev"
		CONFIG_DIR="$(realpath .)"
esac

export CONFIG_DIR

# if not defined, set COMPOSE_PROJECT_NAME to parent directory name:
COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-"$(pwd |xargs basename)-${PHASE}"}"
#COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-"$(dirname "$(pwd)" | xargs basename)"}"

SPECIFIC_CONFIG_FILE="${CONFIG_DIR}/docker-compose.specific.yml"
SECRET_CONFIG_FILE="${CONFIG_DIR}/docker-compose.secret.yml"

# detect config files
if [ -f $SPECIFIC_CONFIG_FILE ]; then
	SPECIFIC_CONFIG="-f $SPECIFIC_CONFIG_FILE"
fi;
if [ -f $SECRET_CONFIG_FILE ]; then
	SECRET_CONFIG="-f $SECRET_CONFIG_FILE"
fi;

# main docker-compose executable:
DOCKER_COMPOSE="docker-compose -p ${COMPOSE_PROJECT_NAME} -f docker-compose.common.yml ${SPECIFIC_CONFIG} ${SECRET_CONFIG}"
echo "Running $DOCKER_COMPOSE"

compose_start ()
{
	${DOCKER_COMPOSE} up -d $@
}

compose_stop ()
{
	${DOCKER_COMPOSE} stop
}

compose_down ()
{
	${DOCKER_COMPOSE} down
}

compose_status()
{
	${DOCKER_COMPOSE} ps
}

cd "$(dirname "$0")"

case $1 in
	up|start|UP|START)
		shift
		compose_start $@
		;;
	stop|STOP)
		compose_stop
		;;
	down)
		compose_down
		;;
	status)
		compose_status
		;;
	*)
		echo running: ${DOCKER_COMPOSE} $@
		${DOCKER_COMPOSE} $@
#        echo "Usage:"
#        echo "  $0 start|up|stop|down|status"
esac
