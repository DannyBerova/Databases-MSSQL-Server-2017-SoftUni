using P02_DatabaseFirst.Data;
using P02_DatabaseFirst.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace P06_AddingNewAddressAndUpdating
{
    public class StartUp
    {
        static void Main()
        {
            using (var db = new SoftUniContext())
            {
                var newAdress = new Address()
                {
                AddressText = "Vitoshka 15",
                TownId = 4
                };

                db.Addresses.Add(newAdress);

                var nakov = db.Employees.Where(e => e.LastName == "Nakov").FirstOrDefault();

                nakov.Address = newAdress;
                db.SaveChanges();

                var addresses = db.Employees
                    .OrderByDescending(e => e.AddressId)
                    .Take(10)
                    .Select(e => e.Address.AddressText);

                foreach (var address in addresses)
                {
                    Console.WriteLine(address);
                }

               

            }
        }
    }
}
