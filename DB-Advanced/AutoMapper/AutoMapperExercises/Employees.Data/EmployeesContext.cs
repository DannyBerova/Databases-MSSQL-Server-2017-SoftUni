namespace Employees.Data
{
    using System;

    using Microsoft.EntityFrameworkCore;

    using Employees.Models;

    public class EmployeesContext : DbContext
    {
        public EmployeesContext() {}

        public EmployeesContext(DbContextOptions options)
            :base(options) { }

        public DbSet<Employee> Employees { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(Configuration.ConnectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Employee>(entity =>
            {
                entity.HasKey(e => e.Id);

                entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(50);

                entity.Property(e => e.LastName)
                .IsRequired()
                .HasMaxLength(50);

                entity.Property(e => e.Address)
                .IsRequired(false)
                .HasMaxLength(250);

                entity.HasOne(e => e.Manager)
                .WithMany(e => e.ManagedEmployees)
                .HasForeignKey(e => e.ManagerId);
            });
        }
    }
}
