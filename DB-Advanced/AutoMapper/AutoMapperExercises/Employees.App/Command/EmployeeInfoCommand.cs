namespace Employees.App.Command
{
    using Employees.DtoModels;
    using Employees.Services;
    using System;
    using System.Linq;

    class EmployeeInfoCommand : ICommand
    {
        private readonly EmployeeService employeeService;

        public EmployeeInfoCommand(EmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        //<employeeId> 
        public string Execute(params string[] args)
        {
            int employeeId = int.Parse(args[0]);
            var emp = employeeService.ById(employeeId);

            return $"ID: {emp.Id} - {emp.FirstName} {emp.LastName} - ${emp.Salary:f2}"; 
        }
    }
}
