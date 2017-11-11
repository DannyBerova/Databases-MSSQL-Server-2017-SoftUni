using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace P07_EmployeesAndProjects
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var emps = db.Employees
                    .Where(e => e.EmployeesProjects.Any(
                        ep => ep.Project.StartDate.Year >= 2001 &&
                              ep.Project.StartDate.Year <= 2003))
                    .Take(30)
                    .Select(e => new
                    {
                        Name = $"{e.FirstName} {e.LastName}",
                        ManagerName = $"{e.Manager.FirstName} {e.Manager.LastName}",
                        Projects = e.EmployeesProjects.Select(ep => new {
                            ep.Project.Name,
                            ep.Project.StartDate,
                            ep.Project.EndDate})
                    })
                    .ToList();

                foreach (var emp in emps)
                {
                    Console.WriteLine($"{emp.Name} - Manager: {emp.ManagerName}");

                    foreach (var pr in emp.Projects)
                    {
                        Console.Write($"--{pr.Name} - {pr.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture)} - ");
                        if (pr.EndDate == null)
                        {
                            Console.WriteLine("not finished");
                        }
                        else
                        {
                            Console.WriteLine(pr.EndDate.Value.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture));
                        }
                    }
                }
            }

        }
    }
}
