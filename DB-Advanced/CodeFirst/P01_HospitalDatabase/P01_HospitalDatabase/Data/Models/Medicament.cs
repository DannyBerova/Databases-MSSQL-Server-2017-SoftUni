
namespace P01_HospitalDatabase.Data.Models
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    public class Medicament
    {
        public Medicament()
        {
            Prescriptions = new List<PatientMedicament>();
        }
        public int MedicamentId { get; set; }

        public string Name { get; set; }

        public int MyProperty { get; set; }

        public ICollection<PatientMedicament> Prescriptions { get; set; }
    }
}
