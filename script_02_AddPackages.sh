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
dotnet add $1/WebAPI package Microsoft.EntityFrameworkCore.Tools --version 6.0.9

echo "***********************************************************************";
echo "           AddNuGet packages to Application class library             *";
echo "***********************************************************************";
echo "";

dotnet add $1/Application package MediatR.Extensions.Microsoft.DependencyInjection --version 11.0.0

dotnet add $1/Application package AutoMapper.Extensions.Microsoft.DependencyInjection --version 12.0.0
dotnet add $1/Application package AutoMapper --version 12.0.0

dotnet add $1/Application package FluentValidation --version 11.2.2
dotnet add $1/Application package FluentValidation.DependencyInjectionExtensions --version 11.2.2

dotnet add $1/Application package Ardalis.Specification --version 6.1.0

echo "***********************************************************************";
echo "           AddNuGet packages to Persistence class library             *";
echo "***********************************************************************";
echo "";
dotnet add $1/Persistance package Microsoft.EntityFrameworkCore --version 6.0.9
dotnet add $1/Persistance package Microsoft.EntityFrameworkCore.SqlServer --version 6.0.9
dotnet add $1/Persistance package Microsoft.Extensions.Options.ConfigurationExtensions --version 6.0.0
dotnet add $1/Persistance package Ardalis.Specification.EntityFrameworkCore --version 6.1.0

dotnet list package

echo "Add packages done";


