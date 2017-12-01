namespace Employees.App.Command
{
    using Employees.DtoModels;
    using Employees.Services;

    class EmployeePersonalInfoCommand : ICommand
    {
        private readonly EmployeeService employeeService;

        public EmployeePersonalInfoCommand(EmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        //<employeeId>
        public string Execute(params string[] args)
        {
            int employeeId = int.Parse(args[0]);
            var emp = employeeService.PersonalById(employeeId);

            string birthday = "no information available";

            if (emp.Birthday != null)
            {
                birthday = emp.Birthday.Value.ToString("dd-MM-yyyy");
            }

            string address = "no information available";

            if (emp.Address != null)
            {
                address = emp.Address;
            }
            string result = $@"ID: {emp.Id} - {emp.FirstName} {emp.LastName} - ${emp.Salary:f2}
Birthday: {birthday}
Address: {address}
";

            return result;
        }
    }
}
