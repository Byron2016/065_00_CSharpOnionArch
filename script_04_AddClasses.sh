#! /bin/bash
# To run:  bash script_04_AddClasses.sh BancoCursoRESTFull


echo "***********************************************************************";
echo "                        Add classes                                   *";
echo "***********************************************************************";
echo "";

currendDir=$(pwd);
echo "Current dir is: $currendDir";
#echo "El parametro es: $1/WebAPI";

nuevoDir=$1/Application;
echo "Moving to $nuevoDir";
cd $nuevoDir;
echo $(pwd);

echo '' >> DTOs/Test.cs
echo '' >> Behavior/Test.cs
echo '' >> Features/Test.cs
echo '' >> Filters/Test.cs
echo '' >> Interfaces/Test.cs
echo '' >> Mappings/Test.cs
echo '' >> Wrappers/Test.cs
echo $(pwd);

nuevoDir=$1/Application;
echo "Moving to $nuevoDir";
cd $nuevoDir;

echo "***********************************************************************";
echo "                     Add class ServiceExtensions.cs                   *";
echo "***********************************************************************";
echo "";

echo "using FluentValidation;"                                                          >> ServiceExtensions.cs
echo "using MediatR;"                                                                   >> ServiceExtensions.cs
echo "using Microsoft.Extensions.DependencyInjection;"                                  >> ServiceExtensions.cs
echo "using System.Reflection;"                                                         >> ServiceExtensions.cs
echo ""                                                                                 >> ServiceExtensions.cs
echo "namespace Application"                                                            >> ServiceExtensions.cs
echo "{"                                                                                >> ServiceExtensions.cs
echo "    public static class ServiceExtensions"                                        >> ServiceExtensions.cs
echo "    {"                                                                            >> ServiceExtensions.cs
echo "        public static void AddApplicationLayer(this IServiceCollection services)" >> ServiceExtensions.cs
echo "        {"                                                                        >> ServiceExtensions.cs
echo "            services.AddAutoMapper(Assembly.GetExecutingAssembly());"             >> ServiceExtensions.cs
echo "            services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());" >> ServiceExtensions.cs
echo "            services.AddMediatR(Assembly.GetExecutingAssembly());"                >> ServiceExtensions.cs
echo ""                                                                                 >> ServiceExtensions.cs
echo "        }"                                                                        >> ServiceExtensions.cs
echo "    }"                                                                            >> ServiceExtensions.cs
echo "}"                                                                                >> ServiceExtensions.cs

echo "Add classes done";




