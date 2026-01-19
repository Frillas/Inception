NAME = inception

COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop

start:
	$(COMPOSE) -f $(COMPOSE_FILE) start

restart:
	$(COMPOSE) -f $(COMPOSE_FILE) restart

logs:
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f

ps:
	$(COMPOSE) -f $(COMPOSE_FILE) ps

clean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --rmi all

fclean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans
	docker system prune -f

re: fclean up

.PHONY: all up down stop start restart logs ps clean fclean re
