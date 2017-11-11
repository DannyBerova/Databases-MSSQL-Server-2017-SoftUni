using P02_DatabaseFirst.Data;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P05_EmpsFromResearchAndDevelopment
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var emps = db.Employees
                    .Where(e => e.Department.Name == "Research and Development")
                    .OrderBy(e => e.Salary)
                    .ThenByDescending(e => e.FirstName)
                    .Select(e => new { e.FirstName, e.LastName, DepartmentName = e.Department.Name, e.Salary })
                    .ToList();

                foreach (var em in emps)
                {
                    Console.WriteLine($"{em.FirstName} {em.LastName} from {em.DepartmentName} - ${em.Salary:f2}");
                }
            }

        }
    }
}
