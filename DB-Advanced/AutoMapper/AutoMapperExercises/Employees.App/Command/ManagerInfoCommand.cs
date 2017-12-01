namespace Employees.App.Command
{
    using Employees.Services;
    using System;
    using System.Collections.Generic;
    using System.Text;

    class ManagerInfoCommand : ICommand
    {
        private readonly EmployeeService employeeService;

        public ManagerInfoCommand(EmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        //<employeeId>
        public string Execute(params string[] args)
        {
            int managerId = int.Parse(args[0]);

            var managerDto = employeeService.GetManager(managerId);

            var result = new StringBuilder();

            result.AppendLine($"{managerDto.FirstName} {managerDto.LastName} | employees: {managerDto.EmployeeManagedEmployeesCount}");

            foreach (var e in managerDto.ManagedEmployees)
            {
                result.AppendLine($"    - {e.FirstName} {e.LastName} - ${e.Salary:f2}");
            }

            return result.ToString().TrimEnd();
        }
    }
}
