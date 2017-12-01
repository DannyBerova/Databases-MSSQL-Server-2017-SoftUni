namespace Employees.App.Command
{
    using Employees.Services;
    using System;

    class SetManagerCommand : ICommand
    {
        private readonly EmployeeService employeeService;

        public SetManagerCommand(EmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        //<employeeId> <managerId>
        public string Execute(params string[] args)
        {
            var employeeId = int.Parse(args[0]);
            var managerId = int.Parse(args[1]);

            var empPersonalDto = employeeService.SetManager(employeeId, managerId);

            return $"{empPersonalDto.Manager.FirstName} {empPersonalDto.Manager.LastName} is successfuly set as a manager to {empPersonalDto.FirstName} {empPersonalDto.LastName}";
        }
    }
}
