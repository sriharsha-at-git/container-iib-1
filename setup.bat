echo "ubuntu base image with updates & kernal settings"
cd ubuntu_base
docker build --tag ubuntu:base .
pause
echo "ubuntu with iib10 software installed"
cd ..\ubuntu_iib10
docker build -t ubuntu:iibv10 .
pause
echo "ubuntu with iib applications deployed"
cd ..\ubuntu_iib10_app-1
docker build -t ubuntu:iib10.app1 .
pause
echo "iib apps running as container"
docker run -d --name iibserver_app_1 -e LICENSE=accept -e NODENAME=IIB10NODE -P ubuntu:iib10.app1
pause
echo "IIB apps exposed on port numbers..."
docker port iibserver_app_1
echo "connect to iib node by using docker's ipaddress & port exposed by above output 4414->xxxxx"
echo "use iibwebadmin & <suffix>pwd"
echo "test apps..."

