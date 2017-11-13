using System;
using P03_SalesDatabase.Data;
using P03_SalesDatabase.Data.Models;

namespace P03_SalesDatabase
{
    class StartUp
    {
        public static void Main()
        {

            var db = new SalesContext();
            //used commands in Package Manager Console
            //
            //Install-Package Microsoft.EntityFrameworkCore.Tools
            //Add-Migration Initial
            //Update-Database
            //Uninstall-Package Microsoft.EntityFrameworkCore.Tools - to test with judge system
            //Install-Package Microsoft.EntityFrameworkCore.Tools
            //Add-Migration ProductsAddColumnDescription
            //Update-Database
            //Add-Migration SalesAddDateDefault
            //Update-Database
            //Uninstall-Package Microsoft.EntityFrameworkCore.Tools - to test with judge system

            //don't forget to build before sending to judge system
            //archive files: StartUp.cs, P03_SalesDatabase.csproj
            //  and folders: Data, Migrations




        }
    }
}
