using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P10_DepartmenstWithMoreThan5Emps
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var departments = db.Departments
                    .Where(d => d.Employees.Count() > 5)
                    .Select(d => new
                    {
                        EmpCount = d.Employees.Count(),
                        DepartmentName = d.Name,
                        ManagerId = d.ManagerId,
                        ManagerName = $"{d.Manager.FirstName} {d.Manager.LastName}",
                        Employees = d.Employees.Select(e => new
                        {
                            FirstName = e.FirstName,
                            LastName = e.LastName,
                            e.JobTitle,
                        })

                    })
                    .OrderBy(dep => dep.EmpCount)
                    .ThenBy(dep => dep.DepartmentName)
                    .ToList();

                foreach (var de in departments)
                {
                    Console.WriteLine($"{de.DepartmentName} - {de.ManagerName}");

                    var sorted = de.Employees.OrderBy(e => e.FirstName).ThenBy(e => e.LastName).ToList();

                    foreach (var emp in sorted)
                    {
                        //if (de.ManagerName == $"{emp.FirstName} {emp.LastName}")
                        //{
                        //    continue;
                        //}
                        //else
                        //{
                            Console.WriteLine($"{emp.FirstName} {emp.LastName} - {emp.JobTitle}");
                        //}
                    }
                    Console.WriteLine("----------");
                }
            }
        }
    }
}
