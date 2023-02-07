#!/bin/bash

microservices=("ms-configserver" "ms-eurekaserver" "ms-gateway" "ms-customer" "ms-movement" "ms-credit" "ms-bankaccount" "ms-statusaccount")
cd ..

# Profile

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
  cd ./service-configuration
  docker-compose up --build
else
  echo "Exiting without starting Docker containers"
fi
