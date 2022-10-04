#! /bin/bash
# To run:  bash script_03_AddFolderStructure.sh BancoCursoRESTFull


echo "***********************************************************************";
echo "                     Add folders and classes                          *";
echo "***********************************************************************";
echo "";

pathOriginal=$(pwd);
currendDir=$(pwd);
echo "Current dir is: $currendDir";
#echo "El parametro es: $1/WebAPI";

nuevoDir=$1/Application;
echo "Moving to $nuevoDir";
cd $nuevoDir;
echo $(pwd);

mkdir DTOs;
mkdir Exceptions;
mkdir Behavior;
mkdir Features;
mkdir Filters;
mkdir Interfaces;
mkdir Mappings;
mkdir Wrappers;

mkdir Features/Clientes;
mkdir Features/Clientes/Commands;
mkdir Features/Clientes/Queries;

mkdir Features/Clientes/Commands/CreateClienteCommand;
mkdir Features/Clientes/Commands/DeleteClienteCommand;
mkdir Features/Clientes/Commands/UpdateClienteCommand;

mkdir Features/Clientes/Queries/GetAllClientes;
mkdir Features/Clientes/Queries/GetClienteById;

echo "** $pathOriginal";
echo $(pwd);
echo "** fin";
cd $pathOriginal;
echo "***";
currendDir=$(pwd);
echo "Current dir is: $currendDir";
nuevoDir=$1/Domain;
echo "Moving to $nuevoDir";
cd $nuevoDir;
echo $(pwd);

mkdir Entities;
mkdir Common;

echo "Add folders done";