#Clone repo
cd /tmp
FOLDER_SRC=$PWD
echo $FOLDER_SRC
git clone https://github.com/accelerat-ai/asterisk-unimrcp
cd asterisk-unimrcp

# Build docker images
cd docker/build-ubuntu && docker build -t asterisk-unimrcp-build:Asterisk-13.18.1 --build-arg ASTERISK_VER=13.18.1 --build-arg ASTERISK_MRCP_BRANCH=master .

cd ../exec-ubuntu && docker build -t asterisk-unimrcp-exec:Asterisk-13.18.1 --build-arg BASE_IMAGE=asterisk-unimrcp-build:Asterisk-13.18.1 .

# Install unimrcp install
docker run --rm -v $FOLDER_SRC/asterisk-unimrcp:/src --name asterisk-build asterisk-unimrcp-build:Asterisk-13.18.1 /src/install/make_asterisk_unimrcp_install.sh install_asterisk_unimrcp 13.18.1

# Run test
cd $FOLDER_SRC/asterisk-unimrcp/docker/tests/
docker-compose --profile test up