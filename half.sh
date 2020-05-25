cd /home/$USER/blockchain/RemoteInstallation/generated/cas/
chmod +x script.sh
sudo ./script.sh
docker swarm init
docker network create --driver overlay --subnet=10.200.1.0/24 --attachable fabric-network
docker-compose -f docker-compose-cas.yaml up -d
sudo docker exec -it cas_rootCA_1 bash -c "cd /var/certs/ ; chmod +x generate_certs.sh ; sh generate_certs.sh ; exit"
cd /home/$USER/blockchain/RemoteInstallation/
rm -rf channel-artifacts
mkdir channel-artifacts
configtxgen -profile OrdererGenesis -outputBlock channel-artifacts/genesis.block
configtxgen -profile defaultChannel -outputCreateChannelTx channel-artifacts/mychannel.tx -channelID mychannel

sudo rm -rf r.sh
sudo cp /home/$USER/r.sh /home/$USER/blockchain/RemoteInstallation/
sudo cp /home/$USER/devops.pem /home/$USER/blockchain/RemoteInstallation/generated/
sudo chmod +x r.sh
sudo ./r.sh
ORDERER_NODE=10.2.21.120
ORDERER_PEER1=10.2.20.231
ORDERER_PEER2=10.2.21.212

sudo ssh -i "devops.pem" ubuntu@$ORDERER_PEER1 'cd orderer1/ && chmod +x script.sh && sudo sh script.sh && cd ../peer1_org1/ && chmod +x script.sh && sudo sh script.sh && sudo mv ~/channel-artifacts/ /var/ && sudo chmod 666 /var/run/docker.sock && exit'
sudo ssh -i "devops.pem" ubuntu@$ORDERER_PEER2 'cd orderer2/ && chmod +x script.sh && sudo sh script.sh && cd ../peer1_org2/ && chmod +x script.sh && sudo sh script.sh && sudo mv ~/channel-artifacts/ /var/ && sudo chmod 666 /var/run/docker.sock && exit'
sudo ssh -i "devops.pem" ubuntu@$ORDERER_NODE 'cd orderer3/ && chmod +x script.sh && sudo sh script.sh && sudo mv ~/channel-artifacts/ /var/ && sudo chmod 666 /var/run/docker.sock && exit'

cd generated/
sudo docker swarm join-token worker > token
sed '1d' token > join-token.sh
sudo scp -i "devops.pem" -r ~/blockchain/RemoteInstallation/generated/join-token.sh ubuntu@$ORDERER_PEER1:~/join-token.sh
sudo ssh -i "devops.pem" ubuntu@$ORDERER_PEER1 'cd ~/ && sudo chmod +x join-token.sh && sudo ./join-token.sh && exit'
sudo scp -i "devops.pem" -r ~/blockchain/RemoteInstallation/generated/join-token.sh ubuntu@$ORDERER_PEER2:~/join-token.sh
sudo ssh -i "devops.pem" ubuntu@$ORDERER_PEER2 'cd ~/ && sudo chmod +x join-token.sh && sudo ./join-token.sh && exit'
sudo scp -i "devops.pem" -r ~/blockchain/RemoteInstallation/generated/join-token.sh ubuntu@$ORDERER_NODE:~/join-token.sh
sudo ssh -i "devops.pem" ubuntu@$ORDERER_NODE 'cd ~/ && sudo chmod +x join-token.sh && sudo ./join-token.sh && exit'
docker stack deploy -c docker-compose.yaml blockchain
docker stack services blockchain
cd /home/$USER/blockchain/RemoteInstallation/adminCert/server/
sudo rm -rf IssuerPublicKey  IssuerRevocationPublicKey admin fabric-ca-server.db msp server.*

cd /home/$USER/blockchain/RemoteInstallation/adminCert/
docker stop $(docker ps -q)
cp /home/$USER/blockchain/RemoteInstallation/generated/cas/rootca/server.* ./server/
cd /home/$USER/blockchain/RemoteInstallation/adminCert/server/
nohup fabric-ca-server start  -b admin:adminw 2> /dev/null &
#sh generateAdmin.sh

