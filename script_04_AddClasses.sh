#! /bin/bash
# To run:  bash script_04_AddClasses.sh BancoCursoRESTFull

echo "////////////////////////////////////////////////////////////////////////";
echo "                        script_04_AddClasses                            ";
echo "////////////////////////////////////////////////////////////////////////";
echo "";

echo "***********************************************************************";
echo "                        Add class to Application folder               *";
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

echo '' >> DTOs/Test.cs;
echo '' >> Exceptions/ValidationException.cs;
echo '' >> Behavior/ValidationBehavior.cs;
#echo '' >> Features/Test.cs;
echo '' >> Filters/Test.cs;
echo '' >> Interfaces/Test.cs;
echo '' >> Mappings/Test.cs;
echo '' >> Wrappers/Response.cs;

cd $pathOriginal;
#echo "llamando a Script_06_CreateClass.sh"
bash Script_06_CreateClass.sh CreateClienteCommand Application.Features.Clientes.Commands.CreateClienteCommand $1/Application/Features/Clientes/Commands/CreateClienteCommand
bash Script_06_CreateClass.sh DeleteClienteCommand Application.Features.Clientes.Commands.DeleteClienteCommand $1/Application/Features/Clientes/Commands/DeleteClienteCommand
bash Script_06_CreateClass.sh UpdateClienteCommand Application.Features.Clientes.Commands.UpdateClienteCommand $1/Application/Features/Clientes/Commands/UpdateClienteCommand

bash Script_06_CreateClass.sh GetAllClientes Application.Features.Clientes.Queries.GetAllClientes $1/Application/Features/Clientes/Queries/GetAllClientes
bash Script_06_CreateClass.sh GetClienteById Application.Features.Clientes.Queries.GetClienteById $1/Application/Features/Clientes/Queries/GetClienteById

bash Script_06_CreateClass.sh CreateClienteCommandHandler Application.Features.Clientes.Handlers $1/Application/Features/Clientes/Handlers
bash Script_06_CreateClass.sh DeleteClienteCommandHandler Application.Features.Clientes.Handlers $1/Application/Features/Clientes/Handlers
bash Script_06_CreateClass.sh UpdateClienteCommandHandler Application.Features.Clientes.Handlers $1/Application/Features/Clientes/Handlers

bash Script_06_CreateClass.sh GetAllClientesQueryHandler Application.Features.Clientes.Handlers $1/Application/Features/Clientes/Handlers
bash Script_06_CreateClass.sh GetClienteByIdQueryHandler Application.Features.Clientes.Handlers $1/Application/Features/Clientes/Handlers

echo "FIN 1llamando a Script_06_CreateClass.sh"


echo $(pwd);
echo "***********************************************************************";
echo "                     Add class to Domain folder                       *";
echo "***********************************************************************";
echo "";
cd $pathOriginal;
nuevoDir=$1/Domain;
echo "Moving to $nuevoDir";
cd $nuevoDir;
echo '' >> Entities/Test.cs
echo '' >> Common/Test.cs


cd $pathOriginal;
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

cd $pathOriginal;
nuevoDir=$1/Application/Behavior;
echo "Moving to $nuevoDir";
cd $nuevoDir;


echo "***********************************************************************";
echo "                    Add class ValidationBehavior.cs                   *";
echo "***********************************************************************";
echo "";

echo "using FluentValidation;"                                                                               >> ValidationBehavior.cs
echo "using MediatR;"                                                                                        >> ValidationBehavior.cs
echo ""                                                                                                      >> ValidationBehavior.cs
echo "namespace Application.Behavior"                                                                        >> ValidationBehavior.cs
echo "{"                                                                                                     >> ValidationBehavior.cs
echo "    //v6"                                                                                              >> ValidationBehavior.cs
echo "    public class ValidationBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>"     >> ValidationBehavior.cs
echo "        where TRequest : IRequest<TResponse>"                                                          >> ValidationBehavior.cs
echo "    {"                                                                                                 >> ValidationBehavior.cs
echo "        private readonly IEnumerable<IValidator<TRequest>> _validators;"                               >> ValidationBehavior.cs
echo ""                                                                                                      >> ValidationBehavior.cs
echo "        public ValidationBehavior(IEnumerable<IValidator<TRequest>> validators)"                       >> ValidationBehavior.cs
echo "        {"                                                                                             >> ValidationBehavior.cs
echo "            _validators = validators;"                                                                 >> ValidationBehavior.cs
echo "        }"                                                                                             >> ValidationBehavior.cs
echo ""                                                                                                      >> ValidationBehavior.cs
echo "        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next," >> ValidationBehavior.cs 
echo "                                            CancellationToken cancellationToken)"                      >> ValidationBehavior.cs
echo "        {"                                                                                             >> ValidationBehavior.cs
echo "            if (_validators.Any()){"                                                                   >> ValidationBehavior.cs
echo "                var context = new FluentValidation.ValidationContext<TRequest>(request);"              >> ValidationBehavior.cs
echo "                var validationResults = await Task.WhenAll(_validators.Select(v => v.ValidateAsync(context, cancellationToken)));" >> ValidationBehavior.cs
echo "                var failures = validationResults.SelectMany(r => r.Errors).Where(f => f != null).ToList();" >> ValidationBehavior.cs
echo ""                                                                           >> ValidationBehavior.cs
echo "                if(failures.Count() != 0)"                                  >> ValidationBehavior.cs
echo "                {"                                                          >> ValidationBehavior.cs
echo "                    throw new Exceptions.ValidationException(failures);"    >> ValidationBehavior.cs
echo "                }"                                                          >> ValidationBehavior.cs
echo ""                                                                           >> ValidationBehavior.cs                
echo "            }"                                                              >> ValidationBehavior.cs
echo "            return await next();"                                           >> ValidationBehavior.cs
echo "        }"                                                                  >> ValidationBehavior.cs
echo "    }"                                                                      >> ValidationBehavior.cs
echo "}"                                                                          >> ValidationBehavior.cs

echo "Add classes done";

cd $pathOriginal; 
nuevoDir=$1/Application/Exceptions;
echo "Moving to $nuevoDir";
cd $nuevoDir;

echo "***********************************************************************";
echo "                   Add class ValidationException.cs                   *";
echo "***********************************************************************";
echo "";

echo "using FluentValidation.Results;"                                                            >> ValidationException.cs
echo ""                                                                                           >> ValidationException.cs
echo "namespace Application.Exceptions"                                                           >> ValidationException.cs
echo "{"                                                                                          >> ValidationException.cs
echo "    public class ValidationException: Exception"                                            >> ValidationException.cs
echo "    {"                                                                                      >> ValidationException.cs
echo "        public List<string> Errors { get; }"                                                >> ValidationException.cs
echo "        public ValidationException() : base(\"One or more validation errors have occurred\")" >> ValidationException.cs
echo "        {"                                                                                  >> ValidationException.cs
echo "            Errors = new List<string>();"                                                   >> ValidationException.cs
echo "        }"                                                                                  >> ValidationException.cs
echo ""                                                                                           >> ValidationException.cs
echo "        public ValidationException(IEnumerable<ValidationFailure> failures) : this()"       >> ValidationException.cs
echo "        {"                                                                                  >> ValidationException.cs
echo "            foreach(var failure in failures)"                                               >> ValidationException.cs
echo "            {"                                                                              >> ValidationException.cs
echo "                Errors.Add(failure.ErrorMessage);"                                          >> ValidationException.cs
echo "            }"                                                                              >> ValidationException.cs
echo "        }"                                                                                  >> ValidationException.cs
echo ""                                                                                           >> ValidationException.cs
echo ""                                                                                           >> ValidationException.cs
echo "    }"                                                                                      >> ValidationException.cs
echo "}"                                                                                          >> ValidationException.cs

cd $pathOriginal; 
nuevoDir=$1/Application/Wrappers;
echo "Moving to $nuevoDir";
cd $nuevoDir;

echo "***********************************************************************";
echo "                     Add class Response.cs                            *";
echo "***********************************************************************";
echo "";

echo "using System;"                                           >> Response.cs
echo "using System.Collections.Generic;"                       >> Response.cs
echo "using System.Linq;"                                      >> Response.cs
echo "using System.Text;"                                      >> Response.cs
echo "using System.Threading.Tasks;"                           >> Response.cs
echo ""                                                        >> Response.cs
echo "namespace Application.Wrappers"                          >> Response.cs
echo "{"                                                       >> Response.cs
echo "    public class Response<T>"                            >> Response.cs
echo "    {"                                                   >> Response.cs
echo "        public bool Succeeded { get; set; }"             >> Response.cs
echo "        public string Message { get; set; }"             >> Response.cs
echo "        public List<string> Errors { get; set; }"        >> Response.cs
echo "        public T Data { get; set; }"                     >> Response.cs
echo ""                                                        >> Response.cs
echo "        public Response()"                               >> Response.cs
echo "        {"                                               >> Response.cs
echo ""                                                        >> Response.cs
echo "        }"                                               >> Response.cs
echo ""                                                        >> Response.cs
echo "        public Response(T data, string message = null)"  >> Response.cs
echo "        {"                                               >> Response.cs
echo "            Succeeded = true;"                           >> Response.cs
echo "            Message = message;"                          >> Response.cs
echo "            Data = data;"                                >> Response.cs
echo "        }"                                               >> Response.cs
echo ""                                                        >> Response.cs
echo "        public Response(string message)"                 >> Response.cs
echo "        {"                                               >> Response.cs
echo "            Succeeded = false;"                          >> Response.cs
echo "            Message = message;"                          >> Response.cs
echo "        }"                                               >> Response.cs
echo "    }"                                                   >> Response.cs
echo "}"                                                       >> Response.cs





