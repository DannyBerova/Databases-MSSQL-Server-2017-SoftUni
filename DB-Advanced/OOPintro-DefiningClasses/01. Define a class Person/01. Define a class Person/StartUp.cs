using System;
using System.Reflection;

public class StartUp
{
    static void Main(string[] args)
    {
        Type personType = typeof(Person);
        PropertyInfo[] properties = personType.GetProperties
            (BindingFlags.Public | BindingFlags.Instance);
        Console.WriteLine(properties.Length);
    }

}

