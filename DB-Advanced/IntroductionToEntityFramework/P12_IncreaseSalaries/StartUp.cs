using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P12_IncreaseSalaries
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var selectedEmps = db.Employees.Where(e => e.Department.Name == "Engineering"
                || e.Department.Name == "Tool Design"
                || e.Department.Name == "Marketing "
                || e.Department.Name == "Information Services")
                .ToList();

                foreach (var emp in selectedEmps)
                {
                    emp.Salary *= 1.12m;
                }

                db.SaveChanges();

                var output = selectedEmps
                    .OrderBy(e => e.FirstName)
                    .ThenBy(e => e.LastName);

                foreach (var emp in output)
                {
                    Console.WriteLine($"{emp.FirstName} {emp.LastName} (${emp.Salary:f2})");
                }
            }
        }
    }
}
