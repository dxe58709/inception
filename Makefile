NAME=inception
FILE=srcs/docker-compose.yml

all:
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/www
	mkdir -p /home/${USER}/data/ssl
	docker compose -f $(FILE) -p $(NAME) --project-directory . --env-file srcs/.env up -d --build

down:
	docker compose -f $(FILE) -p $(NAME) down

re: down all

clean: down
	docker rmi $(NAME)-mariadb $(NAME)-php $(NAME)-nginx; \
	docker volume rm $(NAME)-mariadb $(NAME)-www $(NAME)-ssl; \
	sudo rm -rf /home/${USER}/data/mariadb; \
	sudo rm -rf /home/${USER}/data/www;
	sudo rm -rf /home/${USER}/data/ssl;

fclean: clean
	yes | docker system prune --all

.PHONY: all re down clean