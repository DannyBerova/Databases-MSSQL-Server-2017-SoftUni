using Microsoft.EntityFrameworkCore;
using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P09_Employee147
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var employee = db.Employees
                    .Where(e => e.EmployeeId == 147)
                    .Select(e => new
                    {
                        Name = $"{e.FirstName} {e.LastName}",
                        e.JobTitle,
                        Projects = e.EmployeesProjects.Select(ep => new {ep.Project.Name})
                    })
                    .SingleOrDefault();

                Console.WriteLine($"{employee.Name} - {employee.JobTitle}");
                foreach (var pr in employee.Projects.OrderBy(p => p.Name))
                {
                    Console.WriteLine(pr.Name);
                }
                    
            }
        }
    }
}
