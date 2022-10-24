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
dotnet add $1/WebAPI/WebAPI.csproj reference $1/Persistence/Persistence.csproj
dotnet add $1/WebAPI/WebAPI.csproj reference $1/Shared/Shared.csproj

echo "";
echo "***********************************************************************";
echo "                  Add references to Application                       *";
echo "***********************************************************************";
echo "";

dotnet add $1/Application/Application.csproj reference $1/Domain/Domain.csproj
		
echo "";
echo "***********************************************************************";
echo "                  Add references to Persistence                       *";
echo "***********************************************************************";
echo "";

dotnet add $1/Persistence/Persistence.csproj reference $1/Application/Application.csproj
dotnet add $1/Persistence/Persistence.csproj reference $1/Domain/Domain.csproj

echo "";
echo "***********************************************************************";
echo "                  Add references to Shared                            *";
echo "***********************************************************************";
echo "";

dotnet add $1/Shared/Shared.csproj reference $1/Application/Application.csproj

echo "Add references done";

