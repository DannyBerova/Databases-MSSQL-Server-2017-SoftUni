using System;

public class Product
{
    private string name;
    private decimal price;

    public Product(string name, decimal price)
    {
        this.Name = name;
        this.Price = price;
    }

    public string Name
    {
        get
        {
            return this.name;
        }
        set
        {
            if ( value == string.Empty)
            {
                throw new Exception("Name cannot be empty");
            }
            else
            {
                this.name = value;
            }
        }
    }
    public decimal Price
    {
        get
        {
            return this.price;
        }
        set
        {
            if (value <= 0)
            {
                throw new Exception("Price cannot be zero or negative");
            }
            else
            {
                this.price = value;
            }
        }
    }

    public override string ToString()
    {
        return this.Name;
    }
}

