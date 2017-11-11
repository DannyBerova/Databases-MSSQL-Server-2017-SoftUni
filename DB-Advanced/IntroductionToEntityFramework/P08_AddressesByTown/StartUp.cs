using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P08_AddressesByTown
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var addresses = db.Addresses
                    .Select(a => new { EmpCount = a.Employees.Count(),
                                       TownName = a.Town.Name,
                                       AddressText = a.AddressText})
                    .OrderByDescending(a => a.EmpCount)
                    .ThenBy(a => a.TownName)
                    .ThenBy(a => a.AddressText)
                    .Take(10);

                foreach (var address in addresses)
                {
                    Console.WriteLine($"{address.AddressText}, {address.TownName} - {address.EmpCount} employees");
                }

            }
           
        }
    }
}
