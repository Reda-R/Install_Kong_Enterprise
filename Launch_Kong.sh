cd /Applications
open Docker.app
echo "<--- Starting Docker --->"
sleep 20
echo "<--- Starting Containers --->"
sleep 5
docker start kong-ee-database
sleep 2
docker start kong-ee
sleep 2
echo "<--- Dev Portal on --->"
echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
    | docker exec -i kong-ee /bin/sh
sleep 3
echo "KONG_ENFORCE_RBAC=on \
KONG_ADMIN_GUI_AUTH=basic-auth \
KONG_ADMIN_GUI_SESSION_CONF='{\"secret\":\"secret\",\"storage\":\"kong\",\"cookie_secure\":false}' \
kong reload exit" | docker exec -i kong-ee /bin/sh
sleep 3
echo "<--- Kong is running --->"
open http://localhost:8002/
echo "<--- Kong Manager is open --->"
