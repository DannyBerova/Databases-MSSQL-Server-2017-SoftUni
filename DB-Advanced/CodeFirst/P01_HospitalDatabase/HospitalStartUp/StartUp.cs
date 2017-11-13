namespace HospitalStartUp
{
    using P01_HospitalDatabase.Data;
    using P01_HospitalDatabase.Data.Models;
    using P01_HospitalDatabase.Initializer;
    using System;

    public class StartUp
    {
        public static void Main(string[] args)
        {
            //DatabaseInitializer.ResetDatabase();

            using (var db = new HospitalContext())
            {
                DatabaseInitializer.SeedPatients(db, 100);
            }
        }
    }
}
