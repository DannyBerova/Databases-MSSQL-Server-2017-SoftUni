namespace ProductsShop.App
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Xml.Linq;

    using Newtonsoft.Json;

    using ProductsShop.Data;
    using ProductsShop.Models;
    using System.Collections.Generic;

    public class StartUp
    {
        public static void Main(string[] args)
        {
            using (var db = new ProductsShopContext())
            {
                db.Database.EnsureDeleted();
                db.Database.EnsureCreated();
            }

            //Console.WriteLine(ImportUsersFromJson());
            //Console.WriteLine(ImportCategoriesFromJson());
            //Console.WriteLine(ImportsProductsFromJson());
            //Console.WriteLine(SetCategoriesToProducts());
            //GetProductsInRange();
            //GetSuccessfullySoldProducts();
            //GetCategoriesByProductsCount();
            //GetUsersAndProducts();

            //Console.WriteLine(ImportUsersFromXml());
            //Console.WriteLine(ImportCategoriesFromXml());
            //Console.WriteLine(ImportCategoryProductsFromXml());
            //GetProductsInRangeXml();
            //GetSoldProducts();
            //GetCategoriesByProductsCountXml();
            //GetUsersAndProductsXml();

        }

        static void GetUsersAndProductsXml()
        {
            using (var db = new ProductsShopContext())
            {
                var users = db.Users
                    .Where(u => u.ProductsSold.Any(b => b.BuyerId != null))
                    .OrderByDescending(u => u.ProductsSold.Count())
                    .ThenBy(u => u.LastName)
                    .Select(u => new
                    {
                        firstName = u.FirstName,
                        lastName = u.LastName,
                        age = u.Age,
                        soldProducts = u.ProductsSold.Select(ps =>  new
                        {
                            count = ps.Seller.ProductsSold.Count(),
                            name = ps.Name,
                            price = ps.Price
                            })
                    }).ToList();

                XDocument xDoc = new XDocument();
                xDoc.Add(new XElement("users", new XAttribute("count", $"{users.Count}")));


                foreach (var u in users)
                {
                    xDoc.Root.Add(new XElement("user",
                        new XAttribute("first-name", $"{u.firstName}"),
                        new XAttribute("last-name", $"{u.lastName}"),
                        new XAttribute("age", $"{u.age}"),
                            new XElement("sold-products",
                            new XAttribute("count", $"{u.soldProducts.Count()}"))));

                    var element =
                        xDoc.Root.Elements()
                        .SingleOrDefault(e => e.Name == "user"
                        && e.Attribute("first-name").Value == $"{u.firstName}"
                        && e.Attribute("last-name").Value == $"{u.lastName}"
                        && e.Attribute("age").Value == $"{u.age}")
                        .Elements()
                        .SingleOrDefault(e => e.Name == "sold-products");

                    foreach (var p in u.soldProducts)
                    {
                        element.Add(new XElement("product",
                                        new XAttribute("name", $"{p.name}"),
                                        new XAttribute("price", $"{p.price}")));
                    }
                }

                xDoc.Save("OutputFiles/UsersAndProducts.xml");

            }
        }

        static void GetCategoriesByProductsCountXml()
        {
            using (var db = new ProductsShopContext())
            {
                var categories = db.Categories
                    .OrderBy(c => c.CategoryProducts.Count())
                    .Select(c => new
                    {
                        categoryName = c.Name,
                        productsCount = c.CategoryProducts.Count(),
                        averagePrice = c.CategoryProducts.Select(cp => cp.Product.Price).Average(),
                        totalRevenue = c.CategoryProducts.Select(cp => cp.Product.Price).Sum()
                    })
                    .ToArray();

                var xDoc = new XDocument();
                xDoc.Add(new XElement("categories"));

                foreach (var c in categories)
                {
                    xDoc.Root.Add(
                        new XElement("category",
                            new XAttribute("name", $"{c.categoryName}"),
                                new XElement("products-count", $"{c.productsCount}"),
                                new XElement("average-price", $"{c.averagePrice}"),
                                new XElement("total-revenue", $"{c.totalRevenue}")));
                }

                xDoc.Save("OutputFiles/CategoriesByProductsCount.xml");
            }
        }

        static void GetSoldProducts()
        {
            using (var db = new ProductsShopContext())
            {
                var users = db.Users
                    .Where(u => u.ProductsSold.Any(p => p.Buyer != null))
                    .OrderBy(u => u.LastName)
                    .ThenBy(u => u.FirstName)
                    .Select(u => new
                    {
                        u.FirstName,
                        u.LastName,
                        SoldProducts = u.ProductsSold
                                        .Where(ps => ps.BuyerId != null)
                                        .Select(p => new
                                                 {
                                                     p.Name,
                                                     p.Price,
                                                 })
                    })
                    .ToArray();

                var xDoc = new XDocument();
                xDoc.Add(new XElement("users"));

                foreach (var u in users)
                {
                    xDoc.Root.Add(
                        new XElement("user",
                            new XAttribute("first-name", $"{u.FirstName}"),
                            new XAttribute("last-name", $"{u.LastName}"),
                            new XElement("sold-products")));

                    var pElements = xDoc.Root.Elements()
                        .SingleOrDefault(e => e.Name == "user" &&
                                              e.Attribute("first-name").Value == $"{u.FirstName}" &&
                                              e.Attribute("last-name").Value == $"{u.LastName}")
                        .Element("sold-products");

                    foreach (var p in u.SoldProducts)
                    {
                        pElements.Add(new XElement("product",
                                        new XElement("name", $"{p.Name}"),
                                        new XElement("price", $"{p.Price}")));
                    }
                }

                xDoc.Save("OutputFiles/SoldProducts.xml");
            }
        }

        static void GetProductsInRangeXml()
        {
            using (var db = new ProductsShopContext())
            {
                var products = db.Products
                    .Where(p => p.Price >= 1000 && p.Price <= 2000 && p.BuyerId != null)
                    .OrderBy(p => p.Price)
                    .Select(p => new
                    {
                        productName = p.Name,
                        price = p.Price,
                        buyer = $"{p.Buyer.FirstName} {p.Buyer.LastName}"
                    }).ToArray();

                var xDoc = new XDocument();
                xDoc.Add(new XElement("products"));

                //output file - formating: one line (same as sample output)
                foreach (var p in products)
                {
                    xDoc.Root.Add(
                        new XElement("product",
                            new XAttribute("name", $"{p.productName}"),
                            new XAttribute("price", $"{p.price}"),
                            new XAttribute("buyer", $"{p.buyer}")));
                }

                //output file - formating: multiline
                //foreach (var p in products)
                //{
                //    xDoc.Root.Add(
                //        new XElement("product",
                //            new XElement("name", $"{p.productName}"),
                //            new XElement("price", $"{p.price}"),
                //            new XElement("buyer", $"{p.buyer}")));
                //}

                xDoc.Save("OutputFiles/ProductsInRange.xml");
            }
        }

        static string ImportCategoryProductsFromXml()
        {
            string xmlString = File.ReadAllText("Files/products.xml");

            var xmlDoc = XDocument.Parse(xmlString);

            var elements = xmlDoc.Root.Elements();

            var catProducts = new List<CategoryProduct>();

            using (var db = new ProductsShopContext())
            {
                var userIds = db.Users.Select(u => u.Id).ToArray();
                var categoryIds = db.Categories.Select(c => c.Id).ToArray();

                Random random = new Random();

                foreach (var e in elements)
                {
                    string name = e.Element("name").Value;
                    decimal price = decimal.Parse(e.Element("price").Value);

                    int sellIndex = random.Next(0, userIds.Length);
                    int sellerId = userIds[sellIndex];

                    int? buyerId = sellerId;
                    while (buyerId == sellerId)
                    {
                        int buyerIndex = random.Next(0, userIds.Length);
                        buyerId = userIds[buyerIndex];

                        if (buyerId % 6 == 0 || buyerId % 5 == 0 || buyerId % 13 == 0)
                        {
                            buyerId = null;
                        }
                    }

                    var product = new Product()
                    {
                        Name = name,
                        Price = price,
                        SellerId = sellerId,
                        BuyerId = buyerId
                    };

                    int catIndex = random.Next(0, categoryIds.Length);
                    int categoryId = categoryIds[catIndex];

                    var catProduct = new CategoryProduct()
                    {
                        Product = product,
                        CategoryId = categoryId
                    };

                    catProducts.Add(catProduct);
                }

                db.AddRange(catProducts);
                db.SaveChanges();
            }
            return $"{catProducts.Count} products were imported from .xml file.";
        }

        static string ImportCategoriesFromXml()
        {
            string xmLstring = File.ReadAllText("Files/categories.xml");

            var xmlDoc = XDocument.Parse(xmLstring);

            var elements = xmlDoc.Root.Elements();

            var categoriesToImport = new List<Category>();

            foreach (var category in elements)
            {
                var name = category.Element("name").Value;

                var categoryToAdd = new Category()
                {
                    Name = name
                };

                categoriesToImport.Add(categoryToAdd);
            }

            using (var db = new ProductsShopContext())
            {
                db.Categories.AddRange(categoriesToImport);

                db.SaveChanges();
            }

            return $"{categoriesToImport.Count} categories were imported from .xml file.";
        }

        static string ImportUsersFromXml()
        {
            string xmLstring = File.ReadAllText("Files/users.xml");

            var xmlDoc = XDocument.Parse(xmLstring);

            var elements = xmlDoc.Root.Elements();

            var usersToImport = new List<User>();

            foreach (var user in elements)
            {
                var firstName = user.Attribute("firstName")?.Value;
                var lastName = user.Attribute("lastName")?.Value;
                var ageAttribute = user.Attribute("age")?.Value;

                int? parsedAge = int.TryParse(ageAttribute, out int parseResult) ? parseResult : default(int?);

                var userToAdd = new User()
                {
                    FirstName = firstName,
                    LastName = lastName,
                    Age = parsedAge
                };

                usersToImport.Add(userToAdd);
            }

            using (var db = new ProductsShopContext())
            {
                db.Users.AddRange(usersToImport);

                db.SaveChanges();
            }

            return $"{usersToImport.Count} users were imported from .xml file.";
        }

        static void GetUsersAndProducts()
        {
            using (var db = new ProductsShopContext())
            {
                var users = db.Users
                    .Where(u => u.ProductsSold.Any(b => b.BuyerId != null))
                    
                    .Select(u => new
                    {
                        firstName = u.FirstName,
                        lastName = u.LastName,
                        age = u.Age,
                        soldProducts = u.ProductsSold.Select(ps => new
                        {
                            count = u.ProductsSold.Count(),
                            products = u.ProductsSold.Where(p => p.BuyerId != null)
                            .Select(p => new
                            {
                                name = p.Name,
                                price = p.Price
                            })
                        })
                    })
                    .ToArray()
                    .OrderByDescending(uu => uu.soldProducts.Count())
                    .ThenBy(u => u.lastName);

                var usersToJson = new
                {
                    usersCount = users.Count(),
                    users
                };

                var jsonString = JsonConvert.SerializeObject(usersToJson, Formatting.Indented,
                    new JsonSerializerSettings()
                    {
                        DefaultValueHandling = DefaultValueHandling.Ignore
                    });


                File.WriteAllText("OutputFiles/UsersAndProducts.json", jsonString);

            }
        }

        static void GetCategoriesByProductsCount()
        {
            using (var db = new ProductsShopContext())
            {
                var categories = db.Categories
                    .OrderBy(c => c.Name)
                    .Select(c => new
                    {
                        c.Name,
                        productsCount = c.CategoryProducts.Count(),
                        averagePrice = c.CategoryProducts.Select(cp => cp.Product.Price).Average(),
                        totalRevenue = c.CategoryProducts.Select(cp => cp.Product.Price).Sum()
                    })
                    .ToArray();

                var jsonString = JsonConvert.SerializeObject(categories, Formatting.Indented);

                File.WriteAllText("OutputFiles/CategoriesByProductsCount.json", jsonString);
            }
        }

        static void GetSuccessfullySoldProducts()
        {
            using (var db = new ProductsShopContext())
            {
                var users = db.Users
                    .Where(u => u.ProductsSold.Any(p => p.Buyer != null))
                    .OrderBy(u => u.LastName)
                    .ThenBy(u => u.FirstName)
                    .Select(u => new
                    {
                        u.FirstName,
                        u.LastName,
                        SoldProducts = u.ProductsSold.Select(p => new
                        {
                            p.Name,
                            p.Price,
                            BuyerFirstName = p.Buyer.FirstName,
                            BuyerLastName = p.Buyer.LastName
                        })
                    })
                    .ToArray();

                var jsonString = JsonConvert.SerializeObject(users, Formatting.Indented,
                    new JsonSerializerSettings()
                    {
                        DefaultValueHandling = DefaultValueHandling.Ignore
                    });

                File.WriteAllText("OutputFiles/SuccessfullySoldProducts.json", jsonString);
            }
        }

        static void GetProductsInRange()
        {
            using (var db = new ProductsShopContext())
            {
                var products = db.Products
                    .Where(p => p.Price >= 500 && p.Price <= 1000)
                    .OrderBy(p => p.Price)
                    .Select(p => new
                    {
                        p.Name,
                        p.Price,
                        Seller = $"{p.Seller.FirstName} {p.Seller.LastName}"
                    })
                    .ToArray();

                var jsonString = JsonConvert.SerializeObject(products, Formatting.Indented);

                File.WriteAllText("OutputFiles/ProductsInRange.json", jsonString);
            }
        }

        static string SetCategoriesToProducts()
        {
            int categoryProductsCount = 0;
            using (var db = new ProductsShopContext())
            {
                var productIds = db.Products.Select(p => p.Id).ToArray();
                var categoryIds = db.Categories.Select(c => c.Id).ToArray();

                Random random = new Random();

                var categoryProducts = new List<CategoryProduct>();

                foreach (var productId in productIds)
                {
                    var index = random.Next(0, categoryIds.Length);
                    var categoryId = categoryIds[index];

                    var currentCategoryProduct = new CategoryProduct()
                    {
                        ProductId = productId,
                        CategoryId = categoryId
                    };

                    categoryProducts.Add(currentCategoryProduct);
                }

                categoryProductsCount = categoryProducts.Count();

                db.CategoryProducts.AddRange(categoryProducts);
                db.SaveChanges();
            }

            return $"{categoryProductsCount} categories were added to products.";
        }

        static string ImportsProductsFromJson()
        {
            string path = "Files/products.json";

            Random random = new Random();

            Product[] products = ImportJson<Product>(path);

            using (var db = new ProductsShopContext())
            {
                int[] userIds = db.Users.Select(u => u.Id).ToArray();

                foreach (var p in products)
                {
                    var index = random.Next(0, userIds.Length);
                    var sellerId = userIds[index];

                    p.SellerId = sellerId;

                    int buyerId = sellerId;
                    while (buyerId == p.SellerId)
                    {
                        int buyerIndex = random.Next(0, userIds.Length);
                        buyerId = userIds[buyerIndex];
                        p.BuyerId = buyerId;
                    }
                }

                foreach (var pr in products)
                {
                    if (pr.BuyerId % 6 == 0 || pr.BuyerId % 5 == 0 || pr.BuyerId % 13 == 0)
                    {
                        pr.BuyerId = null;
                    }
                }

                db.Products.AddRange(products);

                db.SaveChanges();
            }

            return $"{products.Length} products were imported from file: {path}.";
        }

        static string ImportCategoriesFromJson()
        {
            string path = "Files/categories.json";

            Category[] categories = ImportJson<Category>(path);

            using (var db = new ProductsShopContext())
            {
                db.Categories.AddRange(categories);

                db.SaveChanges();
            }

            return $"{categories.Length} categories were imported from file: {path}.";
        }

        static string ImportUsersFromJson()
        {
            string path = "Files/users.json";

            User[] users = ImportJson<User>(path);

            using (var db = new ProductsShopContext())
            {
                db.Users.AddRange(users);

                db.SaveChanges();
            }

            return $"{users.Length} users were imported from file: {path}.";
        }

        static T[] ImportJson<T>(string path)
        {
            string jsonString = File.ReadAllText(path);

            T[] objects = JsonConvert.DeserializeObject<T[]>(jsonString);

            return objects;
        }
    }
}
