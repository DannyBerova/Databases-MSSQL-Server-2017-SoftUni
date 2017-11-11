using P02_DatabaseFirst.Data;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P03_EmployeesFullInformation
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var employees = db.Employees
                    .Select(e => new
                    {
                        e.EmployeeId,
                        e.FirstName,
                        e.LastName,
                        e.MiddleName,
                        e.JobTitle,
                        e.Salary
                    })
                    .OrderBy(e => e.EmployeeId)
                    .ToList();

                foreach (var emp in employees)
                {
                    Console.WriteLine($"{emp.FirstName} {emp.LastName} {emp.MiddleName} {emp.JobTitle} {emp.Salary:f2}");
                }
            }
        }
    }
}
