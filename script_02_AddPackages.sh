#! /bin/bash
# To run: bash script_02_AddPackages.sh BancoCursoRESTFull
echo "***********************************************************************";
echo "                       Add NuGet packages                             *";
echo "***********************************************************************";
echo "";

echo "***********************************************************************";
echo "                 AddNuGet packages to WebAPI project                  *";
echo "***********************************************************************";
echo "";

currendDir=pwd;
dotnet add $1/WebAPI package MediatR --version 11.0.0; 

echo "***********************************************************************";
echo "           AddNuGet packages to Application class library             *";
echo "***********************************************************************";
echo "";

dotnet add $1/Application package MediatR.Extensions.Microsoft.DependencyInjection --version 11.0.0

dotnet add $1/Application package AutoMapper.Extensions.Microsoft.DependencyInjection --version 12.0.0
dotnet add $1/Application package AutoMapper --version 12.0.0

dotnet add $1/Application package FluentValidation --version 11.2.2
dotnet add $1/Application package FluentValidation.DependencyInjectionExtensions --version 11.2.2


dotnet list package

echo "Add packages done";


