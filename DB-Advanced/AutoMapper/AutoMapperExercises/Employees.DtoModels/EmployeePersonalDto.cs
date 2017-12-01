namespace Employees.DtoModels
{
    using System;
    using System.Collections.Generic;

    public class EmployeePersonalDto
    {
        public int Id { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public decimal Salary { get; set; }

        public DateTime? Birthday { get; set; }

        public string Address { get; set; }

        public EmployeePersonalDto Manager { get; set; }

        public ICollection<EmployeeDto> ManagedEmployees { get; set; }

        public int ManagedEmpsCount { get; set; }
    }
}
