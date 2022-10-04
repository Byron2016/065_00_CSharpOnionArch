#! /bin/bash
# To run:  bash Script_06_CreateClass.sh BancoCursoRESTFull
# Params: 
#      1: class name
#      2: namespace
#      3: path

echo " el directorio es: $3";
cd $3;
echo $(pwd);
echo "using System;"                                      >> $1.cs
echo "using System.Collections.Generic;"                  >> $1.cs
echo "using System.Linq;"                                 >> $1.cs
echo "using System.Text;"                                 >> $1.cs
echo "using System.Threading.Tasks;"                      >> $1.cs
echo ""                                                   >> $1.cs
echo "namespace $2"   >> $1.cs
echo "{"                                                  >> $1.cs
echo "    public class $1"                                >> $1.cs
echo "    {"                                              >> $1.cs
echo "    }"                                              >> $1.cs
echo "}"                                                  >> $1.cs

echo "****** Se ha creado $3 / $1";