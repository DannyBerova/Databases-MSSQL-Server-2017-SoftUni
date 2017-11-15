using P03_FootballBetting.Data;
using System;

namespace P03_FootballBetting
{
    class StartUp
    {
        static void Main(string[] args)
        {
            var db = new FootballBettingContext();

            using (db)
            {
                db.Database.EnsureDeleted();

                db.Database.EnsureCreated();
            }


        }
    }
}
