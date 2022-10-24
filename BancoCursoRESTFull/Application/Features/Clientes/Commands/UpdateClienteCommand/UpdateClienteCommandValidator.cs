using FluentValidation;

namespace Application.Features.Clientes.Commands.UpdateClienteCommand
{
    public class UpdateClienteCommandValidator : AbstractValidator<UpdateClienteCommand>
    {
        public UpdateClienteCommandValidator()
        {
            RuleFor(p => p.Id)
                .NotEmpty().WithMessage("{PropertyName} no puede ser vacío.");

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
                .EmailAddress().WithMessage("{PropertyName} debe ser una dirección de email válida")
                .MaximumLength(100).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");

            RuleFor(p => p.Direccion)
                .NotEmpty().WithMessage("{PropertyName} no puede ser vacío.")
                .MaximumLength(120).WithMessage("{PropertyName} no debe exceder de {MaxLenth} caracters.");
        }
    }
}
