using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace P11_FindLatest10Projects
{
   public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var projects = db.Projects
                    .OrderByDescending(p => p.StartDate)
                    .Take(10)
                    .OrderBy(p => p.Name)
                    .Select(p => new
                    {
                        p.Name,
                        p.Description,
                        StartDate = p.StartDate
                                     .ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture)
                    })
                    .ToList();

                foreach (var pr in projects)
                {
                    Console.WriteLine(pr.Name);
                    Console.WriteLine(pr.Description);
                    Console.WriteLine(pr.StartDate);
                }
            }
        }
    }
}
