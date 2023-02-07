#!/bin/bash

microservices=("config-server" "eureka-server" "gateway" "customer-microservice" "movement-microservice" "passive-microservice")
cd ..

# Profile
read -p "Do you want to change the active profile? (Y/N) " answer

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
  read -p "Enter the value for the active profile (dev, prod, or docker): " value
  if [ "$value" == "dev" ] || [ "$value" == "prod" ] || [ "$value" == "docker" ]; then
    for microservice in "${microservices[@]}"; do
      if [ -d "$microservice" ]; then
        bootstrap_file="$microservice/src/main/resources/bootstrap.yml"
        if [ -f "$bootstrap_file" ]; then
          sed -i "5s/active:.*/active: $value/" "$bootstrap_file"
        fi
      fi
    done
  else
    echo "Invalid value entered. Exiting script."
    exit 1
  fi
fi

#Jar
read -p "Do you want to generate the jar files? (Y/N) " answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
  # Compile JARs for each microservice in parallel
  for microservice in "${microservices[@]}"; do
    if [ -d "$microservice" ]; then
      (
        cd "$microservice"
        mvn clean install
      ) &
    fi
  done

  wait
fi

#Containers
read -p "Do you want to start the Docker containers? (Y/N) " answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
  # Start the Docker containers
  cd ./config-server-directory
  docker-compose up --build
else
  echo "Exiting without starting Docker containers"
fi
