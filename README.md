<div>
	<div>
		<img src=https://raw.githubusercontent.com/Byron2016/00_forImages/main/images/Logo_01_00.png align=left alt=MyLogo width=200>
	</div>
	&nbsp;
	<div>
		<h1>065_00_CSharpOnionArch</h1>
	</div>
</div>

&nbsp;

## Project Description

**BancoCursoRESTFull** is a practice ot the using of an **Onion Clean Architecture**. following Fernando Ventura's tutorial [Curso .NET Core RESTful API](https://www.youtube.com/watch?v=NbxRLpdbRbE&list=PLOnQtvVd3KITZzHS8Va1UuhNU85qSWNmn).
&nbsp;

We use these packages
- package MediatR --version 11.0.0; 
- package MediatR.Extensions.Microsoft.DependencyInjection --version 11.0.0
- package AutoMapper --version 12.0.0
- package AutoMapper.Extensions.Microsoft.DependencyInjection --version 12.0.0
- package FluentValidation --version 11.2.2
- package FluentValidation.DependencyInjectionExtensions --version 11.2.2

## Stepts

1. Create a new **Blanck Solution** project with these caracteristics:
	- Solution Name: BancoCursoRESTFull

2. Inside solution create this structure of **Solution folders**

```
src
└───Core
│
└───Infrastructure
│   
└───Presentation
```

3. Create these new **Class Library** projects with these caracteristics:
	- Projects Name: 
		- Inside Core folder solution:
			- Application
				- Framework: .NET 6.0 (Long-term support) 
			- Domain
				- Framework: .NET 6.0 (Long-term support)  
		- Inside Infrastructure folder solution:
			- Persistence
				- Framework: .NET 6.0 (Long-term support) 
			- Shared
				- Framework: .NET 6.0 (Long-term support)  
		- Inside Presentation folder solution:
			- WebAPI
				- Type: ASP.NET Core Web API

```
src
└───Core
│   └───Application
│   └───Domain  
│
└───Infrastructure
│   └───Persistence
│   └───Shared
│   
└───Presentation
    └───WebAPI
```

4. Add packages:
	- Into projects WebAPI: 
	```c#
	dotnet add package MediatR --version 11.0.0; 
	```

	- Into projects Application: 
	```c#
	dotnet add package MediatR.Extensions.Microsoft.DependencyInjection --version 11.0.0

	dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection --version 12.0.0
	dotnet add package AutoMapper --version 12.0.0

	dotnet add package FluentValidation --version 11.2.2
	dotnet add package FluentValidation.DependencyInjectionExtensions --version 11.2.2
	```

5. Add inside **Application** project this folder structure with a Test.cs file inside each folder.
Note: We add a Test.cs file to force Visual Studio to link new folder with the project.

```
src
└───Core
│   └───Application
│       └───DTOs
│       │
│       └───Exceptions
│       │
│       └───Behavior
│       │
│       └───Features
│       │
│       └───Filters 
│       │
│       └───Interfaces
│       │
│       └───Mappings
│       │
│       └───Wrappers
```

6. Add to root's **Application** project a new class ServiceExtensions.cs
	```c#
	using FluentValidation;
	using MediatR;
	using Microsoft.Extensions.DependencyInjection;
	using System.Reflection;
	
	namespace Application
	{
		public static class ServiceExtensions
		{
			public static void AddApplicationLayer(this IServiceCollection services)
			{
				services.AddAutoMapper(Assembly.GetExecutingAssembly());
				services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
				services.AddMediatR(Assembly.GetExecutingAssembly());
	
			}
		}
	}
	```
7. Into WebAPI project 
	- Add to WebAPI project a reference to application project
	```c#
	dotnet add WebAPI/WebAPI.csproj reference Application/Application.csproj
	```
	- Add a AddApplicationLayer like a new service
	```c#
	using Application;
	
	namespace WebAPI
	{
		public class Program
		{
			public static void Main(string[] args)
			{
				var builder = WebApplication.CreateBuilder(args);
	
				builder.Services.AddApplicationLayer();
	
				....
			}
		}
	}
	```

8. Handling Exceptions via Pipeline
	- Add to Application/Wrappers a new class **Response** 

	```c#	
	namespace Application.Wrappers
	{
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public List<string> Errors { get; set; }
        public T Data { get; set; }

        public Response()
        {

        }

        public Response(T data, string message = null)
        {
            Succeeded = true;
            Message = message;
            Data = data;
        }

        public Response(string message)
        {
            Succeeded = false;
            Message = message;
        }
	}
	```

	- Add to Applications/Behavior a new class **ValidationBehavior** 
	```c#
	using FluentValidation;
	using MediatR;
	
	namespace Application.Behavior
	{
		//v6
		public class ValidationBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse> where TRequest : IRequest<TResponse>
		{
			private readonly IEnumerable<IValidator<TRequest>> _validators;
	
			public ValidationBehavior(IEnumerable<IValidator<TRequest>> validators)
			{
				_validators = validators;
			}
	
			public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
			{
				if (_validators.Any()){
					var context = new FluentValidation.ValidationContext<TRequest>(request);
					var validationResults = await Task.WhenAll(_validators.Select(v => v.ValidateAsync(context, cancellationToken)));
					var failures = validationResults.SelectMany(r => r.Errors).Where(f => f != null).ToList();
	
					if(failures.Count() != 0)
					{
						throw new Exceptions.ValidationException(failures);
					}
					
				}
				return await next();
			}
		}
	}
	```

	- Add to Applications/Exceptions a new class **ValidationException** 

	```c#
	using FluentValidation.Results;
	
	namespace Application.Exceptions
	{
		public class ValidationException: Exception
		{
			public List<string> Errors { get; }
			public ValidationException() : base("One or more validation errors have occurred")
			{
				Errors = new List<string>();
			}
	
			public ValidationException(IEnumerable<ValidationFailure> failures) : this()
			{
				foreach(var failure in failures)
				{
					Errors.Add(failure.ErrorMessage);
				}
			}
		}
	}
	```
9. Domain Entities 
	- Create Domain Entities
		- Add to Domain/Common a new class **AuditableBaseEntity** 
	
		```c#
		namespace Domain.Common
		{
			public class AuditableBaseEntity
			{
				public virtual int Id { get; set; }
				public string CreatedBy { get; set; }
				public DateTime Created { get; set; }
				public string LastModifiedBy { get; set; }
				public DateTime? LastModified { get; set; }
			}
		}
		```
	
		- Add to Domain/ComEntities a new class **Cliente** 
	
		```c#
		using Domain.Common;
		
		namespace Domain.Entities
		{
			public class Cliente : AuditableBaseEntity
			{
				private int _edad;
				public string Nombre { get; set; }
				public string Apellido { get; set; }
				public DateTime FechaNacimiento { get; set; }
				public string Telefono { get; set; }
				public string Email { get; set; }
				public string Direccion { get; set; }
		
				public int Edad
				{
					get
					{
						if(this._edad <= 0)
						{
							this._edad = new DateTime(DateTime.Now.Subtract(this.FechaNacimiento).Ticks).Year - 1;
						}
		
						return this._edad;
					}
				}
			}
		}
		```

10. Work on **CQRS** 
	- Add **CQRS** structure for client entity.

	```
	src
	└───Core
	│   └───Application
	│       │
	│       └───Features
	│           │
	│           └───Clientes 
	│              │
	│              └───Commands
	│              │   │
	│              │   └───CreateClienteCommand
	│              │   │
	│              │   └───DeleteClienteCommand
	│              │   │
	│              │   └───UpdateClienteCommand
	│              │
	│              └───Queries
	│              │   │
	│              │   └───GetAllClientes
	│              │   │
	│              │   └───GetClienteById
	│              │
	│              └───Handlers
	```

	- Add **CQRS** classes.

	```
	│
	└───Clientes 
	   │
	   └───Commands
	   │   │
	   │   └───CreateClienteCommand
	   │   │   │
	   │   │   └───CreateClienteCommand.cs
	   │   │
	   │   └───DeleteClienteCommand
	   │   │   │
	   │   │   └───DeleteClienteCommand.cs
	   │   │
	   │   └───UpdateClienteCommand
	   │       │
	   │       └───UpdateClienteCommand.cs
	   │   
	   └───Queries
	   │   │
	   │   └───GetAllClientes
	   │   │   │
	   │   │   └───GetAllClientes.cs
	   │   │
	   │   └───GetClienteById
	   │       │
	   │       └───GetClienteById.cs
	   │   
	   └───Handlers
	        │	   
	        └───CreateClienteCommandHandler.cs
	        │
	        └───DeleteClienteCommandHandler.cs
	        │
	        └───UpdateClienteCommandHandler.cs
	        │				
	        └───GetAllClientesQueryHandler.cs
	        │
	        └───GetClienteByIdQueryHandler.cs
	```

