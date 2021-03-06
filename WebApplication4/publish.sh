#! /bin/bash
player1=xiaoming # define a player1
player2=ken 
appname=webapp4
echo "**************** $appname publish start... ****************" 
echo "git pull"
echo "dotnet build"
echo "docker build"
#docker build -t img-webapp0 .
docker build -t img-$appname /home/kting/$appname
echo "docker run"
docker rm -f doc-$appname 
#docker run --name doc-webapp0 -p 8588:8587 -d img-webapp0 
docker run -it --name doc-$appname -p 8588:8587 --mount type=bind,source=/opt/data,target=/home/kting -d img-$appname:latest
echo "**************** $appname publish end... ****************"




#! /bin/bash
appname="webapp4"
echo "${appname} publish start..." 
echo "delete project folder: /home/kting/$appname ..."
#rm -rf /home/kting/$appname
echo "create project folder: /home/kting/$appname ..."
#mkdir /home/kting/$appname
echo "pull project code from  ..."
#git svn  clone https:/home/admin/my/code/gas
#git svn clone  https://www./home/admin/my/code
#cd /home/admin/my/code
#git svn rebase
echo " run dotnet build ..."
#dotnet restore /home/admin/my/code
#dotnet build /home/admin/my/code
echo " run dotnet publish ..."
#dotnet publish /home/admin/my/code  -o /home/admin/my/code/publish
echo "get old container id ..."
CID=$(docker ps |grep "doc-$appname" |awk '{print $1}')
echo $CID
echo "stop $CID container ..."
if [ "$CID" != "" ];then
docker stop $CID
echo "delete $CID container ..."
docker rm -f $CID
fi

echo "get old images id ..."
IID=$(docker images |grep "img-$appname" |awk '{print $3}')
echo $IID
if [ "$IID" != "" ];then
echo "delete $IID images ..."
docker rmi -f $IID
fi

echo "create docker images ..."
#docker build -t img-webapp0 .
docker build -t img-$appname /home/kting/$appname 

sleep 10
echo "create docker container ..."
#docker rm -f doc-$appname 
#docker run -d -p 5002:5002 --name dotnetapigas dotnetapi
docker run -it --name doc-$appname -p 8588:8587 --mount type=bind,source=/opt/data,target=/home/kting -d img-$appname:latest

echo "$appname publish end... "