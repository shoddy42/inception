DIR = /home/wkonings
ENV_FILE = ./srcs/.env

# Load .env file to access DOMAIN_NAME variable
ifneq ("$(wildcard $(ENV_FILE))","")
	include $(ENV_FILE)
endif

all: check_domain_name
	echo "Incepting Inception"
	@if [ -d "$(DIR)/data/wordpress" ]; then \
		echo "$(DIR)/data/wordpress already exists"; \
	else \
		sudo mkdir -p $(DIR)/data/wordpress; \
		echo "wordpress directory created successfully"; \
	fi

	@if [ -d "$(DIR)/data/mariadb" ]; then \
		echo "$(DIR)/data/mariadb already exists"; \
	else \
		sudo mkdir -p $(DIR)/data/mariadb; \
		echo "mariadb directory created successfully"; \
	fi

	@if ! grep -q "127.0.0.1 $(DOMAIN_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts > /dev/null && \
		echo "Added $(DOMAIN_NAME) to /etc/hosts"; \
	else \
		echo "$(DOMAIN_NAME) is already in /etc/hosts"; \
	fi; \

	sudo docker compose -f ./srcs/docker-compose.yml up -d --build

check_domain_name:
	@if [ -z "$(DOMAIN_NAME)" ]; then \
		echo "DOMAIN_NAME is not set in the .env file!" \
		"\nPlease run 'make env' to create it. Don't forget to set values!"; \
		exit 1; \
	fi

down:
	sudo docker compose -f ./srcs/docker-compose.yml down

reset:
	if [ -d "$(DIR)/data/wordpress" ]; then \
		sudo rm -rf $(DIR)/data/wordpress && \
		echo "successfully removed all contents from $(DIR)/data/wordpress/"; \
	fi;

	if [ -d "$(DIR)/data/mariadb" ]; then \
		sudo rm -rf $(DIR)/data/mariadb && \
		echo "successfully removed all contents from $(DIR)/data/mariadb/"; \
	fi;
	
fclean:
	sudo docker compose -f ./srcs/docker-compose.yml down --rmi all -v
	if [ -d "$(DIR)/data/wordpress" ]; then \
		sudo rm -rf $(DIR)/data/wordpress && \
		echo "successfully removed all contents from $(DIR)/data/wordpress/"; \
	fi;

	if [ -d "$(DIR)/data/mariadb" ]; then \
		sudo rm -rf $(DIR)/data/mariadb && \
		echo "successfully removed all contents from $(DIR)/data/mariadb/"; \
	fi;

	@if grep -q "127.0.0.1 $(DOMAIN_NAME)" /etc/hosts; then \
		sudo sed -i "/127.0.0.1 $(DOMAIN_NAME)/d" /etc/hosts && \
		echo "Removed 127.0.0.1 $(DOMAIN_NAME) from /etc/hosts"; \
	else \
		echo "127.0.0.1 $(DOMAIN_NAME) not found in /etc/hosts to remove. \
		If you changed DOMAIN_NAME before running fclean, its still there."; \
	fi

re: fclean all

ls:
	sudo docker image ls
	sudo docker ps

env:
	@echo "Creating .env file..."
	@echo "Make sure to change AT LEAST all 'default' values, for security reasons"
	@echo "#MariaDB" > $(ENV_FILE)
	@echo "DB_NAME=mariadb" >> $(ENV_FILE)
	@echo "DB_HOST=mariadb" >> $(ENV_FILE)
	@echo "DB_USER=default" >> $(ENV_FILE)
	@echo "DB_PASS=default" >> $(ENV_FILE)
	@echo "DB_ROOT_PASS=default" >> $(ENV_FILE)
	@echo "" >> $(ENV_FILE)
	@echo "#WordPress" >> $(ENV_FILE)
	@echo "WP_TITLE=Inception_42" >> $(ENV_FILE)
	@echo "DOMAIN_NAME=wkonings.42.fr" >> $(ENV_FILE)
	@echo "" >> $(ENV_FILE)
	@echo "#WordPress Admin" >> $(ENV_FILE)
	@echo "WP_ADMIN_USER=default_admin" >> $(ENV_FILE)
	@echo "WP_ADMIN_PASS=default_admin" >> $(ENV_FILE)
	@echo "WP_ADMIN_EMAIL=default_admin" >> $(ENV_FILE)
	@echo "" >> $(ENV_FILE)
	@echo "#WordPress User" >> $(ENV_FILE)
	@echo "WP_USER_NAME=default_user" >> $(ENV_FILE)
	@echo "WP_USER_PASS=default_user" >> $(ENV_FILE)
	@echo "WP_USER_EMAIL=default_user" >> $(ENV_FILE)
	@echo "WP_USER_ROLE=editor" >> $(ENV_FILE)
	@echo ".env file created successfully! Remember to set the variables..."

.PHONY: all, clean, fclean, re, ls
