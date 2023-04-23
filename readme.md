# Run a cosmos node

`sudo docker build -t cosmos-default-img:latest .`

`sudo docker run -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 9090:9090 --name cosmos-node cosmos-pruned-img:latest`
