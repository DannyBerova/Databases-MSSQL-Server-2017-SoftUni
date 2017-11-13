using System;
using System.Collections.Generic;
using System.Text;

namespace P03_SalesDatabase.Data
{
   
        public class Configuration
        {
            public static string ConnectionString { get; set; } =
            @"Server=DESKTOP-32FEOB6\SQLEXPRESS;Database=Sales;Integrated Security=True";
        }
    
}
