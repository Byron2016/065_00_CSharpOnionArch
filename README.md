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
- package Microsoft.EntityFrameworkCore.Tools --version 6.0.9
- package Microsoft.AspNetCore.Mvc.Versioning --version 5.0.0

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
	dotnet add package Microsoft.EntityFrameworkCore.Tools --version 6.0.9
	dotnet add package Microsoft.AspNetCore.Mvc.Versioning --version 5.0.0
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
	
	- Into projects Shared: 
	```c#
	dotnet add package Microsoft.Extensions.Options.ConfigurationExtensions --version 6.0.0
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
			
			- Add to WebAPI project a reference to Shared project
			```c#
			dotnet add WebAPI/WebAPI.csproj reference Shared/Shared.csproj
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
		
		- Into Application project 
			- Add to Application project a reference to Domain project
			```c#
			dotnet add Application/Application.csproj reference Domain/Domain.csproj
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
			
		- Into Shared class library
			- Add a reference to application project
			```c#
			dotnet add Shared/Shared.csproj reference Application/Application.csproj
			```


8. Handling Exceptions via Pipeline
	- Add to Application/Wrappers a new class **Response** 

	```c#	
	namespace Application.Wrappers
	{
		public class Response<T>
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
	
13. Migrations
	- Override OnModelCreating method
	```c#
	using Application.Interfaces;
	using Domain.Common;
	using Domain.Entities;
	using Microsoft.EntityFrameworkCore;
	using System.Reflection;
	
	namespace Persistence
	{
		public class ApplicationDBContext : DbContext
		{
			....
	
			protected override void OnModelCreating(ModelBuilder modelBuilder)
			{
				modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
			}
		}
	}
	```
	
	- Into Persistence/Configuration create a new  **ClienteConfig**
	```c#
	using Domain.Entities;
	using Microsoft.EntityFrameworkCore;
	using Microsoft.EntityFrameworkCore.Metadata.Builders;
	
	namespace Persistence.Configuration
	{
		public class ClienteConfig : IEntityTypeConfiguration<Cliente>
		{
			public void Configure(EntityTypeBuilder<Cliente> builder)
			{
				builder.ToTable("clientes");
	
				builder.HasKey(p => p.Id);
	
				builder.Property(p => p.Nombre)
					.HasMaxLength(80)
					.IsRequired();
	
				builder.Property(p => p.Apellido)
					.HasMaxLength(80)
					.IsRequired();
	
				builder.Property(p => p.FechaNacimiento)
					.IsRequired();
	
				builder.Property(p => p.Telefono)
					.HasMaxLength(9)
					.IsRequired();
	
				builder.Property(p => p.Email)
					.HasMaxLength(100);
	
				builder.Property(p => p.Direccion)
					.HasMaxLength(120)
					.IsRequired();
	
				builder.Property(p => p.Edad);
	
				builder.Property(p => p.CreatedBy)
					.HasMaxLength(30);
	
				builder.Property(p => p.LastModifiedBy)
					.HasMaxLength(30);
			}
		}
	}
	```

	- Add ServiceExtensions: AddPersistenceInfraestructure methods.
	```c#
	using Application;
	using Persistence;
	
	namespace WebAPI
	{
		public class Program
		{
			public static void Main(string[] args)
			{
				var builder = WebApplication.CreateBuilder(args);
				
				....
				builder.Services.AddPersistenceInfraestructure(builder.Configuration);
				....
			}
		}
	}
	```

	- Into Shared project
		- Add a reference to application project
		```c#
		dotnet add Shared/Shared.csproj reference Application/Application.csproj
		```
			
		- Add into Shared/services class **DateTimeService**
		```c#
		using Application.Interfaces;
		
		namespace Shared.Services
		{
			public class DateTimeService : IDateTimeService
			{
				public DateTime NowUtc => DateTime.UtcNow;
			}
		}
		```
		
		- Add package to do inyect of IConfiguration enable: 
		```c#
		dotnet add package Microsoft.Extensions.Options.ConfigurationExtensions --version 6.0.0
		```

		- Add ServiceExtensions: AddSharedInfraestructure methods.
		```c#
		using Application.Interfaces;
		using Microsoft.Extensions.Configuration;
		using Microsoft.Extensions.DependencyInjection;
		using Shared.Services;
		
		namespace Shared
		{
			public static class ServiceExtensions
			{
				public static void AddSharedInfraestructure(this IServiceCollection services, IConfiguration configuration)
				{
					services.AddTransient<IDateTimeService, DateTimeService>();
				}
			}
		}
		```
		
		- Add ServiceExtensions: AddSharedInfraestructure methods.
		```c#
		....
		using Shared;
		
		namespace WebAPI
		{
			public class Program
			{
				public static void Main(string[] args)
				{
					var builder = WebApplication.CreateBuilder(args);
					
					....
					builder.Services.AddSharedInfraestructure(builder.Configuration);
					....
				}
			}
		}
		```
	
	- Into projects WebAPI 
		- add package: 
		```c#
		dotnet add package Microsoft.EntityFrameworkCore.Tools --version 6.0.9
		```
		
		- Add ServiceExtensions: AddSharedInfraestructure methods.
		```c#
		using Application;
		using Persistence;
		using Shared;
		
		namespace WebAPI
		{
			public class Program
			{
				public static void Main(string[] args)
				{
					var builder = WebApplication.CreateBuilder(args);
					
					....
					builder.Services.AddSharedInfraestructure(builder.Configuration);
					....
				}
			}
		}
		```
	
	- Ejecute migration
		- Go to Package Manager Console View and select Persistence project.
			- add-migration MyFirstMigration -o Migrations
			- update-database
			
14. Creating a custom error middleware
	- Add into Application/Exceptions class **ApiException**
		
		```c#
		using System.Globalization;
		
		namespace Application.Exceptions
		{
			public class ApiException : Exception
			{
				//V 10
				public ApiException():base()
				{
		
				}
		
				public ApiException(string message) : base(message)
				{
		
				}
		
				public ApiException(string message, params object[] args) : base(String.Format(CultureInfo.CurrentCulture,message , args))
				{
		
				}
			}
		}
		```
		
		- Add into WebAPI/Middleware class **ErrorHandlersMiddlewares**
		```c#
		using Application.Wrappers;
		using System.Net;
		using System.Text.Json;
		
		namespace WebAPI.Middlewares
		{
			public class ErrorHandlersMiddlewares
			{
				private readonly RequestDelegate _next;
		
				public ErrorHandlersMiddlewares(RequestDelegate next)
				{
					_next = next;
				}
		
				public async Task Invoke(HttpContext context)
				{
					try
					{
						await _next(context);
					}
					catch (Exception error)
					{
						var response = context.Response;
						response.ContentType = "application/json";
						var responseModel = new Response<string>
						{
							Succeeded = false,
							Message = error?.Message
						};
		
						switch (error)
						{
							case Application.Exceptions.ApiException e:
								//custom application error
								response.StatusCode = (int)HttpStatusCode.BadRequest;
								break;
		
							case Application.Exceptions.ValidationException e:
								//custom application error
								response.StatusCode = (int)HttpStatusCode.BadRequest;
								responseModel.Errors = e.Errors;
								break;
		
							case KeyNotFoundException e:
								//not fount error
								response.StatusCode = (int)HttpStatusCode.NotFound;
								break;
		
							default:
								// unhandled error
								response.StatusCode = (int)HttpStatusCode.InternalServerError;
								break;
						}
		
						var result = JsonSerializer.Serialize(responseModel);
		
						await response.WriteAsync(result);
					}
				}
			}
		}
		```
		
		- Create a extension method to implement middleware
		```c#
		using WebAPI.Middlewares;
		
		namespace WebAPI.Extensions
		{
			public static class AppExtensions
			{
				public static void UseErrorHandlingMiddleware(this IApplicationBuilder app)
				{
					app.UseMiddleware<ErrorHandlersMiddlewares>();
				}
			}
		}
		```
		
		- Implementar el middleware en el WebAPI
		```c#
		....
		using WebAPI.Extensions;
		
		namespace WebAPI
		{
			public class Program
			{
				public static void Main(string[] args)
				{
					....
		
					app.UseAuthorization();
		
					app.UseErrorHandlingMiddleware();
		
					....
				}
			}
		}
		```
		
15. Work with **CQRS classes**

	- Add to Application project a reference to Domain project
	```c#
	dotnet add Application/Application.csproj reference Domain/Domain.csproj
	```
	
	- Configure AutoMapper
		- Add to Application/Mappings a class **GeneralProfile**
		```c#
		using Application.Features.Clientes.Commands.CreateClienteCommand;
		using AutoMapper;
		using Domain.Entities;
		
		namespace Application.Mappings
		{
			public class GeneralProfile : Profile
			{
				public GeneralProfile()
				{
					#region Commands
					CreateMap<CreateClienteCommand, Cliente>();
					#endregion
				}
			}
		}
		```
		
	- Cliente Class **CQRS**
		- Validation with fluenValidation: Add into Application/Features/Clientes/Commands/CreateClienteCommand a class **CreateClienteCommandValidator**
		```c#
		using FluentValidation;
		
		namespace Application.Features.Clientes.Commands.CreateClienteCommand
		{
			public class CreateClienteCommandValidator : AbstractValidator<CreateClienteCommand>
			{
				public CreateClienteCommandValidator()
				{
					RuleFor(p => p.Nombre)
						.NotEmpty().WithMessage("{PropertyName} no puede ser vacío.")
						.MaximumLength(80).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");
		
					RuleFor(p => p.Apellido)
						.NotEmpty().WithMessage("{PropertyName} no puede ser vacío.")
						.MaximumLength(80).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");
		
					RuleFor(p => p.FechaNacimiento)
						.NotEmpty().WithMessage("Fecha de nacimiento no puede ser vacío.");
		
					RuleFor(p => p.Telefono)
						.NotEmpty().WithMessage("{PropertyName} no puede ser vacío.")
						.Matches(@"^\d{4}-\d{4}$").WithMessage("{PropertyName} debe cumplir el formato 0000-0000.")
						.MaximumLength(9).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");
		
					RuleFor(p => p.Email)
						.NotEmpty().WithMessage("{PropertyName} no puede ser vacío.")
						.EmailAddress().WithMessage("{PropertyName} debe ser una dirección de email válida" )
						.MaximumLength(100).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");
		
					RuleFor(p => p.Direccion)
						.NotEmpty().WithMessage("{PropertyName} no puede ser vacío.")
						.MaximumLength(120).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");
				}
			}
		}
		```
		
		- Command
		```c#
		using Application.Wrappers;
		using MediatR;
		
		namespace Application.Features.Clientes.Commands.CreateClienteCommand
		{
			public class CreateClienteCommand : IRequest<Response<int>>
			{
				private int _edad;
				public string Nombre { get; set; }
				public string Apellido { get; set; }
				public DateTime FechaNacimiento { get; set; }
				public string Telefono { get; set; }
				public string Email { get; set; }
				public string Direccion { get; set; }
		
			}
		}
		```
		
		- Handler
		```c#
		using Application.Features.Clientes.Commands.CreateClienteCommand;
		using Application.Interfaces;
		using Application.Wrappers;
		using AutoMapper;
		using Domain.Entities;
		using MediatR;
		
		namespace Application.Features.Clientes.Handlers
		{
			public class CreateClienteCommandHandler : IRequestHandler<CreateClienteCommand, Response<int>>
			{
				private readonly IRepositoryAsync<Cliente> _repositoryAsync;
				private readonly IMapper _mapper;
		
				public CreateClienteCommandHandler(IRepositoryAsync<Cliente> repositoryAsync, IMapper mapper)
				{
					_repositoryAsync = repositoryAsync;
					_mapper = mapper;
				}
		
		
				public async Task<Response<int>> Handle(CreateClienteCommand request, CancellationToken cancellationToken)
				{
					var nuevoRegistro = _mapper.Map<Cliente>(request);
					var data = await _repositoryAsync.AddAsync(nuevoRegistro);
		
					return new Response<int>(data.Id);
				}
			}
		}
		```
		
16. Controllers **CQRS classes**

	- Add to WebAPI/Controllers a new **API** controller **BaseApiController**
	```c#
	using MediatR;
	using Microsoft.AspNetCore.Http;
	using Microsoft.AspNetCore.Mvc;
	using Microsoft.Extensions.DependencyInjection;
	
	namespace WebAPI.Controllers
	{
		[ApiController]
		[Route("api/v{version:apiVersion}/[controller]")]
		public abstract class BaseApiController : ControllerBase
		{
			private IMediator _mediator;
			protected IMediator Mediator => _mediator ??= HttpContext.RequestServices.GetService<IMediator>();
		}
	}
	```
	
	- Into projects WebAPI add package 
	```c#
	dotnet add package Microsoft.AspNetCore.Mvc.Versioning --version 5.0.0
	```
	
	- Add to WebAPI/Controllers/v1 a new **API** controller **ClientesController**
	```c#
	using Application.Features.Clientes.Commands.CreateClienteCommand;
	using Microsoft.AspNetCore.Mvc;
	
	namespace WebAPI.Controllers.v1
	{
		[ApiVersion("1.0")]
		public class ClientesController : BaseApiController
		{
			//Post api/controllers
			[HttpPost]
			public async Task<IActionResult> Post(CreateClienteCommand command)
			{
				return Ok(await Mediator.Send(command));
			}
		}
	}
	```
	
	- Register our version controller.
		- Add ServiceExtensions
		```c#
		using Microsoft.AspNetCore.Mvc;
		
		namespace WebAPI.Extensions
		{
			public static class ServiceExtensions
			{
				public static void AddApiVersioningExtension(this IServiceCollection services)
				{
					services.AddApiVersioning(Config => 
					{
						Config.DefaultApiVersion = new ApiVersion(1, 0);
		
						Config.AssumeDefaultVersionWhenUnspecified = true;
		
						Config.ReportApiVersions = true;
					});
				}
			}
		}
		```
		
		- Add Service pipe line
		```c#
		using Application;
		using Persistence;
		using Shared;
		using WebAPI.Extensions;
		
		namespace WebAPI
		{
			public class Program
			{
				public static void Main(string[] args)
				{
					....
		
					builder.Services.AddControllers();
					builder.Services.AddApiVersioningExtension();
		
					// Learn more about configuring Swagger/OpenAPI at 
					....
				}
			}
		}
		```
		
		- Register ValidationBehavior like a service
		```c#
		using Application.Behavior;
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
					....
					services.AddTransient(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
		
				}
			}
		}
		```
		
		- Test with Swagger
			- Ejecute application
			- Try it out: "POST /api/v{version}/Clientes"
				- version: 1
				- Request body
					```c#
					{
					"nombre": "b1",
					"apellido": "v1",
					"fechaNacimiento": "1980-10-24",
					"telefono": "999-999",
					"email": "email1@yahoo.com",
					"direccion": "xxx1"
					}
					```