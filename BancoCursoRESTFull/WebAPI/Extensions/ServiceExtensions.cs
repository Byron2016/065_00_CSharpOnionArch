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
