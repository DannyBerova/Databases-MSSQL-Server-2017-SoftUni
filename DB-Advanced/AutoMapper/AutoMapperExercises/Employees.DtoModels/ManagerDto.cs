namespace Employees.DtoModels
{
    using Employees.Models;
    using System.Collections.Generic;

    public class ManagerDto
    {
        public int Id { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public ICollection<Employee> ManagedEmployees { get; set; }

        public int EmployeeManagedEmployeesCount { get; set; }
    }
}
