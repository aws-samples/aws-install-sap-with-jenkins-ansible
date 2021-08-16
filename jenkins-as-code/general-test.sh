checkStatus=$(curl http://localhost:8080/)

if [[ -z "$checkStatus" ]]; then
    echo "Service is unavailable!"
else
    echo "Service is up and running!"
fi