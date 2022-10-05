using Application.Interfaces;
using Domain.Common;
using Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace Persistence
{
    public class ApplicationDBContext : DbContext
    {
        private readonly IDateTimeService _dateTimeService;

        public ApplicationDBContext(DbContextOptions<ApplicationDBContext> options, IDateTimeService dateTimeService) : base(options)
        {
            //Buena práctica V.8 5.43
            //El comportamiento de seguimiento de este Tracking behavior controlla que entity framework core va a mantener toda la información sobre una instancia de entidad en su restaurador de cambios si se rastrea una entidad cualquier cambio detectado en esa entidad se mantendrá en la base de datos durante el save changes.
            //El EF Core también va a arrelgar las propiedades de navegación entre las entidades en el resultado de una consulta y las entidades que están en el registrador de cambios.
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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
        }
    }
}
