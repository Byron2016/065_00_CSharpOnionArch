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
- package MediatR --version 10.0.1; 
- package MediatR.Extensions.Microsoft.DependencyInjection --version 10.0.1
- package AutoMapper --version 11.0.1
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