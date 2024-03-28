all:
# if [ -d "/home/wkonings/data" ]; then \
# 	echo "/home/wkonings/data already exists"; else \
# 	sudo mkdir /home/wkonings/data; \
# 	echo "data directory created successfully"; \
# fi

	@if [ -d "/home/wkonings/data/wordpress" ]; then \
		echo "/home/wkonings/data/wordpress already exists"; else \
		@sudo mkdir -p /home/wkonings/data/wordpress; \
		echo "wordpress directory created successfully"; \
	fi

	@if [ -d "/home/wkonings/data/mariadb" ]; then \
		echo "/home/wkonings/data/mariadb already exists"; else \
		@sudo mkdir -p /home/wkonings/data/mariadb; \
		echo "mariadb directory created successfully"; \
	fi
	sudo docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	sudo docker compose -f ./srcs/docker-compose.yml down -v

reset:
	if [ -d "/home/wkonings/data/wordpress" ]; then \
	sudo rm -rf /home/wkonings/data/wordpress && \
	echo "successfully removed all contents from /home/wkonings/data/wordpress/"; \
	fi;

	if [ -d "/home/wkonings/data/mariadb" ]; then \
	sudo rm -rf /home/wkonings//data/mariadb && \
	echo "successfully removed all contents from /home/wkonings/data/mariadb/"; \
	fi;
	
fclean:
	sudo docker compose -f ./srcs/docker-compose.yml down --rmi all -v
	sudo docker system prune -a --force
	if [ -d "/home/wkonings/data/wordpress" ]; then \
	sudo rm -rf /home/wkonings/data/wordpress && \
	echo "successfully removed all contents from /home/wkonings/data/wordpress/"; \
	fi;

	if [ -d "/home/wkonings/data/mariadb" ]; then \
	sudo rm -rf /home/wkonings//data/mariadb && \
	echo "successfully removed all contents from /home/wkonings/data/mariadb/"; \
	fi;

re: fclean all

ls:
	sudo docker image ls
	sudo docker ps

.PHONY: all, clean, fclean, re, ls
