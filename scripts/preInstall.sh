#set env vars
#set -o allexport; source .env; set +o allexport;

mkdir -p ./neko-data
chown -R 1000:1000 ./neko-data

docker pull m1k1o/neko:firefox;
docker pull m1k1o/neko:chromium;
docker pull m1k1o/neko:google-chrome;
docker pull m1k1o/neko:ungoogled-chromium;
docker pull m1k1o/neko:brave;
docker pull m1k1o/neko:tor-browser;
docker pull m1k1o/neko:vlc;
docker pull m1k1o/neko:vncviewer;
docker pull m1k1o/neko:xfce;
