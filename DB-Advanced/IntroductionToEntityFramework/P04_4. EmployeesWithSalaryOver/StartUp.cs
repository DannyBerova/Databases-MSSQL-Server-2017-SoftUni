using P02_DatabaseFirst.Data;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P04_4._EmployeesWithSalaryOver
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var emps = db.Employees
                    .Where(e => e.Salary > 50000)
                    .Select(e => e.FirstName)
                    .OrderBy(e => e)
                    .ToList();

                foreach (var em in emps)
                {
                    Console.WriteLine(em);
                }
            }
        }
    }
}
