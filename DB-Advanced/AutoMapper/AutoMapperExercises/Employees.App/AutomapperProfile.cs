namespace Employees.App
{
    using AutoMapper;

    using Employees.Models;
    using Employees.DtoModels;

    class AutomapperProfile : Profile
    {
        public AutomapperProfile()
        {
            CreateMap<Employee, EmployeeDto>();
            CreateMap<EmployeeDto, Employee>();

            CreateMap<Employee, EmployeePersonalDto>();
            CreateMap<EmployeePersonalDto, Employee>();

            CreateMap<Employee, ManagerDto>()
                .ForMember(
                ManagerDto => ManagerDto.EmployeeManagedEmployeesCount,
                opt => opt.MapFrom(employee => employee.ManagedEmployees.Count));

            CreateMap<Employee, EmployeePersonalDto>();

        }
    }
}
