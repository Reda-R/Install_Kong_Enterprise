# Prerequisites

Install Docker Desktop for Mac OS with the following link :

    https://www.docker.com/get-started

Open Docker Desktop : command + space and search "Docker"

Now let's install Kong Gateway (Enterprise) using Docker.

# Install Kong Gateway (Enterprise)

Open a Terminal : command + space and search "Terminal"

Tap the following commands one by one in the Terminal :

Step 1. Pull the Kong Gateway Docker image :

    docker pull kong/kong-gateway:2.5.0.0-alpine

    docker tag kong/kong-gateway:2.5.0.0-alpine kong-ee

Step 2. Create a Docker network

    docker network create kong-ee-net

Step 3. Start a database

    docker run -d --name kong-ee-database \
      --network=kong-ee-net \
      -p 5432:5432 \
      -e "POSTGRES_USER=kong" \
      -e "POSTGRES_DB=kong" \
      -e "POSTGRES_PASSWORD=kong" \
      postgres:12.8

Step 4. Prepare the Kong database

    docker run --rm --network=kong-ee-net \
      -e "KONG_DATABASE=postgres" \
      -e "KONG_PG_HOST=kong-ee-database" \
      -e "KONG_PG_PASSWORD=kong" \
      -e "KONG_PASSWORD=kong" \
      kong-ee kong migrations bootstrap

Step 5. Start the gateway with Kong Manager

    docker run -d --name kong-ee --network=kong-ee-net \
      -e "KONG_DATABASE=postgres" \
      -e "KONG_PG_HOST=kong-ee-database" \
      -e "KONG_PG_PASSWORD=kong" \
      -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
      -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
      -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
      -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
      -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
      -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
        -p 8000:8000 \
        -p 8443:8443 \
        -p 8001:8001 \
        -p 8444:8444 \
        -p 8002:8002 \
        -p 8445:8445 \
        -p 8003:8003 \
        -p 8004:8004 \
        kong-ee

Step 6. Verify your installation

    curl -i -X GET --url http://localhost:8001/services

Verify that Kong Manager is running :

    open http://localhost:8002

Step 7. Deploy the license :

    curl -i -X POST http://localhost:8001/licenses \
    -d payload='{"license":{"version":1,"signature":"e0504a178ba541c5bbc0033cc197b1923dd2ab86f500a945890c50bcd066ee344e3a06ab67639bfb11150a8c2875dc5cdd4949964f743c292c21ca2af4c3a5fd","payload":{"customer":"Bravenn","license_creation_date":"2021-9-7","product_subscription":"Kong Enterprise Edition","support_plan":"None","admin_seats":"5","dataplanes":"0","license_expiration_date":"2022-09-07","license_key":"0011K00002RNLj2QAH_a1V1K0000084vn5UAA"}}}'

Set the Portal URL and set KONG_PORTAL to on :

    echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
        | docker exec -i kong-ee /bin/sh

Set config portal to true : 

    curl -X PATCH --url http://localhost:8001/workspaces/default \
         --data "config.portal=true"

#Access the Dev Portal for the default workspace :

    open http://localhost:8003/default

#Pull decK Docker image

    docker pull kong/deck


# How to get a license ?

The license for Kong Gateway (Enterprise) is delivered by Kong Inc.