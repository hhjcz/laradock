#!/bin/bash
# hhj, 13.9.2016

cd "$(dirname "$0")"

# if not defined, set COMPOSE_PROJECT_NAME to parent directory name:
COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-"$(dirname "$(pwd)" | xargs basename)"}"

# main docker-compose executable:
DOCKER_COMPOSE="docker-compose -p ${COMPOSE_PROJECT_NAME} -f docker-compose.common.yml -f docker-compose.specific.yml"

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