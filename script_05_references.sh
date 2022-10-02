#! /bin/bash
# To run:  bash script_05_references.sh BancoCursoRESTFull


echo "***********************************************************************";
echo "                     Add projects references                          *";
echo "***********************************************************************";
echo "";

echo "***********************************************************************";
echo "                     Add references to WebAPI                         *";
echo "***********************************************************************";
echo "";

dotnet add $1/WebAPI/WebAPI.csproj reference $1/Application/Application.csproj

echo "Add references done";

