﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

public class StartUp1
    {
        static void Main(string[] args)
        {
        Type boxType = typeof(Box);
        FieldInfo[] fields = boxType.GetFields(BindingFlags.NonPublic | BindingFlags.Instance);
        Console.WriteLine(fields.Count());

        double lenght = double.Parse(Console.ReadLine());
        double width = double.Parse(Console.ReadLine());
        double height = double.Parse(Console.ReadLine());

        Box box = new Box(lenght,width, height);

        double surfaceArea = box.SurfaceArea();
        double lateralSurfaceArea = box.LateralSurfaceArea();
        double volume = box.Volume();

        Console.WriteLine($"Surface Area - {surfaceArea:f2}");
        Console.WriteLine($"Lateral Surface Area - {lateralSurfaceArea:f2}");
        Console.WriteLine($"Volume - {volume:f2}");

    }
}

