#! /bin/bash
# To run: bash script_01_CreateProject.sh SolutionName 
# Example to run: bash script_01_CreateProject.sh BancoCursoRESTFull 
echo "********************************************";
echo "*           Building solution $1           *";
echo "********************************************";
echo "";
dotnet new sln --name $1 --output $1;

echo "********************************************";
echo "*          Building class libraries        *";
echo "********************************************";
echo "";
dotnet new classlib --output $1/Application; 
dotnet new classlib --output $1/Domain; 
dotnet new classlib --output $1/Persistence; 
dotnet new classlib --output $1/Shared; 
dotnet new webapi --output $1/WebAPI --use-program-main; 

echo "********************************************";
echo "*    Linking projects with solution  $1    *";
echo "********************************************";
echo "";
dotnet sln $1/$1.sln add --solution-folder src/Presentation $1/WebAPI; 
dotnet sln $1/$1.sln add --solution-folder src/Core $1/Application $1/Domain; 
dotnet sln $1/$1.sln add --solution-folder src/Infrastructure $1/Persistence $1/Shared; 

echo "***********************************************************************";
echo "        Deleting Class1.cs files from each class library              *";
echo "***********************************************************************";
echo "";
rm $1/Application/Class1.cs
rm $1/Domain/Class1.cs
rm $1/Persistence/Class1.cs
rm $1/Shared/Class1.cs

#echo "***********************************************************************";
#echo "                   Calling script script_02                           *";
#echo "***********************************************************************";
#echo "";

#bash script_02_AddPackages.sh $1

#echo "***********************************************************************";
#echo "                   Calling script script_03                           *";
#echo "***********************************************************************";
#echo "";

#bash script_03_AddFolderStructure.sh $1

if [ $2 = "todo" ]; then
   echo "Add project done";
   bash script_02_AddPackages.sh $1
   bash script_03_AddFolderStructure.sh $1
   bash script_04_AddClasses.sh $1
   bash script_05_references.sh $1
else
  echo "Add project done";
fi



