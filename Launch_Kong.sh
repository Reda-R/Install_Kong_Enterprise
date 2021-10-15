cd /Applications
open Docker.app
echo "<--- Starting Docker --->"
sleep 20s
echo "<--- Starting Containers --->"
sleep 5s
docker start kong-ee-database
sleep 2s
docker start kong-ee 
sleep 2s
echo "<--- Dev Portal on --->"
echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
    | docker exec -i kong-ee /bin/sh
sleep 2s
echo "<--- Kong is running --->"
open http://localhost:8002/
echo "<--- Kong Manager is open --->"
sleep 2s
open http://localhost:8003/
echo "<--- Kong Portal is open --->"