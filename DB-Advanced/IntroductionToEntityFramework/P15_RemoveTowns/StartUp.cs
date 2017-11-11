using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P15_RemoveTowns
{
    public class StartUp
    {
        static void Main()
        {
            string town = Console.ReadLine();

            using (var db = new SoftUniContext())
            {
                var townToDelete = db.Towns.Where(t => t.Name == town).SingleOrDefault();

                var addresses = db.Addresses.Where(a => a.TownId == townToDelete.TownId).ToList();

                foreach (var address in addresses)
                {
                    var addressEmps = db.Employees
                        .Where(e => e.AddressId == address.AddressId)
                        .ToList();

                    foreach (var emp in addressEmps)
                    {
                        emp.AddressId = null;
                    }
                }

                db.Addresses.RemoveRange(addresses);
                db.Towns.Remove(townToDelete);
                db.SaveChanges();
            }
        }
    }
}
