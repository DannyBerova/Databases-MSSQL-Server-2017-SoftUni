using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P14_DeleteProjectById
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var project2 = db.Projects.Where(e => e.ProjectId == 2).SingleOrDefault();

                var empProjects = db.EmployeesProjects.Where(ep => ep.ProjectId == 2);

                db.EmployeesProjects.RemoveRange(empProjects);
                db.Projects.Remove(project2);

                db.SaveChanges();

                var updatedProjects = db.Projects.Take(10).ToList();

                foreach (var pr in updatedProjects)
                {
                    Console.WriteLine(pr.Name);
                }
            }
        }
    }
}
