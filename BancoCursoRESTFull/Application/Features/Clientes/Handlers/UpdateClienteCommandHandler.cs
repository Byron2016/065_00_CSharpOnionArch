using Application.Features.Clientes.Commands.UpdateClienteCommand;
using Application.Interfaces;
using Application.Wrappers;
using Domain.Entities;
using MediatR;

namespace Application.Features.Clientes.Handlers
{
    public class UpdateClienteCommandHandler : IRequestHandler<UpdateClienteCommand, Response<int>>
    {
        private readonly IRepositoryAsync<Cliente> _repositoryAsync;

        public UpdateClienteCommandHandler(IRepositoryAsync<Cliente> repositoryAsync)
        {
            _repositoryAsync = repositoryAsync;
        }


        public async Task<Response<int>> Handle(UpdateClienteCommand request, CancellationToken cancellationToken)
        {
            //V.14
            var cliente = await _repositoryAsync.GetByIdAsync(request.Id);

            if(cliente == null)
            {
                throw new KeyNotFoundException($"Registro no encontrado con el id {request.Id}");
            }
            else
            {
                // no se usa automapper x q EF necesita distinguir cambios en la entidad. Si hago automapper me va a fallar.
                cliente.Nombre = request.Nombre;
                cliente.Apellido = request.Apellido;
                cliente.FechaNacimiento = request.FechaNacimiento;
                cliente.Telefono = request.Telefono;
                cliente.Email = request.Email;
                cliente.Direccion = request.Direccion;

                await _repositoryAsync.UpdateAsync(cliente);

                return new Response<int>(cliente.Id);

            }
        }

    }
}
