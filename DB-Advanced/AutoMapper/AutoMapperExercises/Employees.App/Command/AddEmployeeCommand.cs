namespace Employees.App.Command
{
    using Employees.DtoModels;
    using Employees.Services;
    using System;


    class AddEmployeeCommand : ICommand
    {
        private readonly EmployeeService employeeService;

        public AddEmployeeCommand(EmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        //<firstName> <lastName> <salary> 
        public string Execute(params string[] args)
        {
            string firstName = args[0];
            string lastName = args[1];
            decimal salary = decimal.Parse(args[2]);

            var employeeDto = new EmployeeDto(firstName, lastName, salary);

            employeeService.AddEmployee(employeeDto);

            return $"Employee {firstName} {lastName} successfully added.";
        }
    }
}
