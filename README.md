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
- package Microsoft.EntityFrameworkCore --version 6.0.9
- package Microsoft.EntityFrameworkCore.SqlServer --version 6.0.9
- package Microsoft.Extensions.Options.ConfigurationExtensions --version 6.0.0
- package Ardalis.Specification --version 6.1.0
- package Ardalis.Specification.EntityFrameworkCore --version 6.1.0

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
	
	dotnet add package Ardalis.Specification --version 6.1.0
	```
	
	- Into projects Persistance: 
	```c#
	dotnet add package Microsoft.EntityFrameworkCore --version 6.0.9
	dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 6.0.9
	dotnet add package Microsoft.Extensions.Options.ConfigurationExtensions --version 6.0.0
	dotnet add package Ardalis.Specification.EntityFrameworkCore --version 6.1.0
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
7. Projects references
		- Into WebAPI project 
			- Add to WebAPI project a reference to Application project
			```c#
			dotnet add WebAPI/WebAPI.csproj reference Application/Application.csproj
			```
			
			- Add to WebAPI project a reference to Persistance project
			```c#
			dotnet add WebAPI/WebAPI.csproj reference Persistance/Persistance.csproj
			```
		
		- Add an AddApplicationLayer like a new service
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
		
		- Into Persistence class library
			- Add a reference to application project
			```c#
			dotnet add Persistence/Persistence.csproj reference Application/Application.csproj
			```
			- Add a reference to Domain project
			```c#
			dotnet add Persistence/Persistence.csproj reference Domain/Domain.csproj
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

11. Persistence 
	- Add packages
		- Into projects Persistance: 
		```c#
		dotnet add package Microsoft.EntityFrameworkCore --version 6.0.9
		dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 6.0.9
		dotnet add package Microsoft.Extensions.Options.ConfigurationExtensions --version 6.0.0
		```
		
	- References
		- Add to Persistence project a reference to Application project
		```c#
		dotnet add Persistence/Persistence.csproj reference Application/Application.csproj
		```
		- Add to Persistence project a reference to Domain project
		```c#
		dotnet add Persistence/Persistence.csproj reference Domain/Domain.csproj
		```
	
	- Add into Application/Interfaces a new interface **IDateTimeService** 
	```c#
	namespace Application.Interfaces
	{
		public interface IDateTimeService
		{
			DateTime NowUtc { get;  }
		}
	}
	```
	
	- Add DBContext
	```c#
	using Application.Interfaces;
	using Domain.Common;
	using Domain.Entities;
	using Microsoft.EntityFrameworkCore;
	
	namespace Persistence
	{
		public class ApplicationDBContext : DbContext
		{
			private readonly IDateTimeService _dateTimeService;
	
			public ApplicationDBContext(DbContextOptions<ApplicationDBContext> options, IDateTimeService dateTimeService) : base(options)
			{
				//good practice V.8 5.43
				//The tracking behavior of this Tracking behavior controls that the entity framework core will keep all the information about an entity instance in its change restorer if an entity is tracked any change detected in that entity will be kept in the database during the save changes.
				//The EF Core will also fix the navigation properties between the entities in the result of a query and the entities that are in the change logger.
				ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
	
				_dateTimeService = dateTimeService;
			}
	
			public DbSet<Cliente> Clientes { get; set; }
	
			public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = new CancellationToken())
			{
				foreach(var entry in ChangeTracker.Entries<AuditableBaseEntity>())
				{
					switch (entry.State)
					{
						case EntityState.Added:
							entry.Entity.Created = _dateTimeService.NowUtc;
							break;
						case EntityState.Modified:
							entry.Entity.LastModified = _dateTimeService.NowUtc;
							break;
					}
				}
	
				return base.SaveChangesAsync(cancellationToken);
	
			}
		}
	}
	```

12. Implement Repository Pattern
	- Add into Appliation project package Ardalis.Specivications.
		```c#
		dotnet add package Ardalis.Specification --version 6.1.0
		```
		
	- Add into Persistance project package Ardalis.Specivications.
		```c#
		dotnet add package Ardalis.Specification.EntityFrameworkCore --version 6.1.0
		```
		
	- Add into Application/Interfaces a new interface
		```c#
		using Ardalis.Specification;
		
		namespace Application.Interfaces
		{
			public interface IRepositoryAsync<T> : IRepositoryBase<T> where T : class
			{
			}
		
			public interface IReadRepositoryAsync<T> : IReadRepositoryBase<T> where T : class
			{
			}
		}
		```
	- Add connection string
	```c#
	{
	"ConnectionStrings": {
		"DefaultConnection": "Server=localhost;Database=db_bancoOnion_00;User Id=sa;Password=123456;"
	},
	....
	}
	```
	
	- Add to WebAPI project a reference to Persistance project
	```c#
	dotnet add WebAPI/WebAPI.csproj reference Persistance/Persistance.csproj
	```
	
	- Add ServiceExtensions: AddPersistenceInfraestructure methods.
	```c#
	using Application.Interfaces;
	using Microsoft.EntityFrameworkCore;
	using Microsoft.Extensions.Configuration;
	using Microsoft.Extensions.DependencyInjection;
	using Persistence.Repository;
	
	namespace Persistence
	{
		public static class ServiceExtensions
		{
			public static void AddPersistenceInfraestructure(this IServiceCollection services, IConfiguration configuration)
			{
				services.AddDbContext<ApplicationDBContext>(options => options.UseSqlServer(
					configuration.GetConnectionString("DefaultConnection"), b => b.MigrationsAssembly(typeof(ApplicationDBContext).Assembly.FullName)));
	
				#region Repositories
				services.AddTransient(typeof(IRepositoryAsync<>), typeof(MyRepositoryAsync<>));
				#endregion
	
	
			}
		}
	}
	```