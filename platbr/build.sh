cd ..
docker build -f platbr/Dockerfile .  -t platbr/jackett:latest
docker push platbr/jackett:latest
cd -
