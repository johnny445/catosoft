sudo rm -rf /var/lib/dpkg/lock && sudo rm -rf /var/lib/apt/lists/lock && sudo rm -rf /var/lib/dpkg/lock-frontend
sudo apt-get update -y
sudo apt install curl -y
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install libtool libltdl-dev

go version
if [ "$?" = "127" ]
then
     sudo curl -O  https://storage.googleapis.com/golang/go1.11.13.linux-amd64.tar.gz
     sudo tar -xvf go1.11.13.linux-amd64.tar.gz
     sudo mv go /usr/local
     echo "export GOPATH=$HOME/go" >> "$HOME"/.bashrc
     echo "export GOROOT=/usr/local/go" >> "$HOME"/.bashrc
     echo "export PATH=$PATH:/usr/local/go/bin" >> "$HOME"/.bashrc

fi

sudo apt-get install \
    sudo apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update -y

docker --version
if [ "$?" = "127" ]
then
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
fi

docker-compose --version
if [ "$?" = "127" ]
then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

node --version
if [ "$?" = "127" ]
then
    sudo curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh && sudo bash nodesource_setup.sh
    sudo apt install nodejs -y
fi


sudo -s source ~/.bashrc

sudo apt-get install build-essential -y
sudo apt-get install make -y

sudo curl https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s -- 1.4.4 1.4.4 -d -s –
mkdir -p $HOME/go/src/github.com/hyperledger/fabric
#sudo git clone -b master https://github.com/hyperledger/fabric-samples.git
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
git clone -b 'v1.4.4' --single-branch --depth 1 https://github.com/hyperledger/fabric.git $GOPATH/src/github.com/hyperledger/fabric
make -C $GOPATH/src/github.com/hyperledger/fabric orderer
make -C $GOPATH/src/github.com/hyperledger/fabric peer
go get github.com/hyperledger/fabric/protos/peer
go get github.com/hyperledger/fabric/core/chaincode/shim
export PATH=$PATH:$GOPATH/src/github.com/hyperledger/fabric/core/chaincode/shim  >> "$HOME/.bashrc"
export PATH=$PATH:$GOROOT/src/github.com/hyperledger/fabric/core/chaincode/shim >> "$HOME/.bashrc"
export PATH="$HOME/go/src/github.com/hyperledger/fabric/.build/bin:$PATH" >> "$HOME/.bashrc"
#sudo curl https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s -- 1.4.4 1.4.4 -d -s –
make -C $GOPATH/src/github.com/hyperledger/fabric configtxgen
export PATH=$PATH:$GOPATH/src/github.com/hyperledger/fabric/build/bin
echo "export PATH=$PATH:$GOPATH/src/github.com/hyperledger/fabric/.build/bin" >> "$HOME/.bashrc"
sudo -s source ~/.bashrc
git clone -b 'v1.4.4' --single-branch --depth 1 https://github.com/hyperledger/fabric-ca.git $GOPATH/src/github.com/hyperledger/fabric-ca
make -C $GOPATH/src/github.com/hyperledger/fabric-ca fabric-ca-client fabric-ca-server
go get -u github.com/hyperledger/fabric-ca/cmd/...
sudo cp $HOME/go/bin/fabric-ca-server /usr/local/bin/
sudo cp $HOME/go/bin/fabric-ca-client /usr/local/bin/
sudo -s source ~/.bashrc
#. .bashrc

sudo -s source ~/.bashrc
sudo chmod 666 /var/run/docker.sock
git clone ssh://RemoteInstallation@bitbucket.org/RemoteInstallation/blockchain.git
cd /home/$USER/blockchain/RemoteInstallation/
sudo cp /home/$USER/devops.pem /home/$USER/blockchain/RemoteInstallation/
sudo chmod 400 devops.pem
#cp ~/.env ~/remoteinstallation/
sudo rm -rf generated/
node generateRootCAs.js
chmod +x setup.js
node setup.js
cd generated/
sudo chmod +x generate_certs.sh
#sudo ./generate_certs.sh
cd /home/$USER/blockchain/RemoteInstallation/
sudo chown ubuntu -R .

