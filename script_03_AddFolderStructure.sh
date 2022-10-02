#! /bin/bash
# To run:  bash script_03_AddFolderStructure.sh BancoCursoRESTFull


echo "***********************************************************************";
echo "                     Add folders and classes                          *";
echo "***********************************************************************";
echo "";

currendDir=$(pwd);
echo "Current dir is: $currendDir";
#echo "El parametro es: $1/WebAPI";

nuevoDir=$1/Application;
echo "Moving to $nuevoDir";
cd $nuevoDir;
echo $(pwd);

mkdir DTOs;
mkdir Behavior;
mkdir Features;
mkdir Filters;
mkdir Interfaces;
mkdir Mappings;
mkdir Wrappers;

echo "Add folders done";