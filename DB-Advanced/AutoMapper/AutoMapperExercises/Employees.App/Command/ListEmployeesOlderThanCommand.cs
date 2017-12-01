namespace Employees.App.Command
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    using Employees.Services;
    using Employees.DtoModels;

    class ListEmployeesOlderThanCommand : ICommand
    {
        private readonly EmployeeService employeeService;

        public ListEmployeesOlderThanCommand(EmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        //<age>
        public string Execute(params string[] args)
        {
            int age = int.Parse(args[0]);

            var employees = employeeService.OlderThanAge(age);

            if (employees == null)
            {
                throw new ArgumentException($"No employees older than {age} years.");
            }

            var result = new StringBuilder();

            foreach (var emp in employees.OrderByDescending(e => e.Salary))
            {
                result.Append($"{emp.FirstName} {emp.LastName} - ${emp.Salary:F2} - Manager: ");

                if (emp.Manager == null)
                {
                    result.Append("[no manager]");
                }
                else
                {
                    result.Append(emp.Manager.LastName);
                }
                result.AppendLine();
            }

            return result.ToString().TrimEnd();
        }
    }
}
