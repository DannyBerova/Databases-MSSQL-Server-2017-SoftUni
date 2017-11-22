namespace BookShop
{
    using BookShop.Data;
    using BookShop.Initializer;
    using BookShop.Models;

    using System;
    using System.Linq;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Globalization;
    using Microsoft.EntityFrameworkCore;
    using System.Collections.Generic;

    public class StartUp
    {
        public static void Main()
        {
            using (var db = new BookShopContext())
            {
                //DbInitializer.ResetDatabase(db);

                var command = Console.ReadLine();
                //var input = Console.ReadLine();
                //var date = Console.ReadLine();
                //var year = int.Parse(Console.ReadLine());
                //int lenghtCheck = int.Parse(Console.ReadLine());

                Console.WriteLine(GetBooksByAgeRestriction(db, command));
                //Console.WriteLine(GetGoldenBooks(db));
                //Console.WriteLine(GetBooksByPrice(db));
                //Console.WriteLine(GetBooksNotRealeasedIn(db, year));
                //Console.WriteLine(GetBooksByCategory(db, input));
                //Console.WriteLine(GetBooksReleasedBefore(db, date));
                //Console.WriteLine(GetBooksByAuthor(db, input));
                //Console.WriteLine(GetAuthorNamesEndingIn(db, input));
                //Console.WriteLine(GetBookTitlesContaining(db, input));
                //Console.WriteLine(CountBooks(db, lenghtCheck));
                //Console.WriteLine(CountCopiesByAuthor(db));
                //Console.WriteLine(GetTotalProfitByCategory(db));
                //Console.WriteLine(GetMostRecentBooks(db));
                //IncreasePrices(db);
                //Console.WriteLine(RemoveBooks(db));

            }
        }

        public static string GetBooksByAgeRestriction(BookShopContext db, string command)
        {
            var titles = db.Books
                .OrderBy(b => b.Title)
                .Where(b => b.AgeRestriction
                             .ToString()
                             .Equals(command, StringComparison.InvariantCultureIgnoreCase))
                .Select(b => b.Title)
                //.OrderBy(t => t)
                .ToList();
            var result = String.Join(Environment.NewLine, titles);
            return result;
        }

        public static string GetGoldenBooks(BookShopContext db)
        {
            var titles = db.Books
                .OrderBy(b => b.BookId)
                .Where(b => b.EditionType == EditionType.Gold && b.Copies < 5000)
                .Select(b => b.Title)
                //.OrderBy(t => t)
                .ToList();
            var result = String.Join(Environment.NewLine, titles);
            return result;
        }

        public static string GetBooksByPrice(BookShopContext db)
        {
            var booksByPrice = db.Books
                .OrderByDescending(b => b.Price)
                .Where(b => b.Price > 40)
                .Select(b => $"{b.Title} - ${b.Price:f2}")
                .ToList();

            var result = String.Join(Environment.NewLine, booksByPrice);
            return result;
        }

        public static string GetBooksNotRealeasedIn(BookShopContext db, int year)
        {
            var titles = db.Books
                .OrderBy(b => b.BookId)
                .Where(b => b.ReleaseDate.Value.Year != year)
                .Select(b => b.Title)
                //.OrderBy(t => t)
                .ToList();
            var result = String.Join(Environment.NewLine, titles);
            return result;
        }

        public static string GetBooksByCategory(BookShopContext db, string input)
        {
            string[] categories = input
                .ToLower()
                .Split(new[] { " ", Environment.NewLine, "\t" }, StringSplitOptions.RemoveEmptyEntries);

            string[] titles = db.Books
                .Where(b => b.BookCategories.Any(bc => categories.Contains(bc.Category.Name.ToLower())))
                .Select(b => b.Title)
                .OrderBy(t => t)
                .ToArray();

            var result = String.Join(Environment.NewLine, titles);
            int count = result.Count();
            return result;
        }

        public static string GetBooksReleasedBefore(BookShopContext db, string date)
        {
            DateTime checkDate = DateTime.ParseExact(date, "dd-MM-yyyy", null);

            var books = db.Books
                .Where(b => b.ReleaseDate < checkDate)
                .OrderByDescending(b => b.ReleaseDate)
                .Select(b => $"{b.Title} - {b.EditionType} - ${b.Price:f2}")
                .ToList();

            var result = String.Join(Environment.NewLine, books);
            return result;
        }

        public static string GetAuthorNamesEndingIn(BookShopContext db, string input)
        {
            var pattern = $@"^.*{input.ToLower()}$";

            var authors = db.Authors
                .Where(a => Regex.Match(a.FirstName.ToLower(), pattern).Success)
                .Select(a => $"{a.FirstName} {a.LastName}")
                .OrderBy(n => n)
                .ToList();

            var result = String.Join(Environment.NewLine, authors);
            return result;
        }

        public static string GetBookTitlesContaining(BookShopContext db, string input)
        {
            var pattern = $@"^.*{input.ToLower()}.*$";

            var books = db.Books
                .Where(b => Regex.Match(b.Title.ToLower(), pattern).Success)
                .Select(b => b.Title)
                .OrderBy(t => t)
                .ToList();

            var result = String.Join(Environment.NewLine, books);
            return result;
        }

        public static string GetBooksByAuthor(BookShopContext db, string input)
        {
            var pattern = $@"^{input.ToLower()}.*$";

            var books = db.Books
                .Where(b => Regex.Match(b.Author.LastName.ToLower(), pattern).Success)
                .OrderBy(b => b.BookId)
                .Select(b => $"{b.Title} ({b.Author.FirstName} {b.Author.LastName})")
                .ToList();

            var result = String.Join(Environment.NewLine, books);
            return result;
        }

        public static int CountBooks(BookShopContext db, int lengthCheck)
        {
            var books = db.Books
                .Where(b => b.Title.Length > lengthCheck)
                .ToList();

            int countOfBooks = books.Count();
            return countOfBooks;
        }

        public static string CountCopiesByAuthor(BookShopContext db)
        {
            var copiesByAuthor = db.Authors
                .Select(a => new
                {
                    Name = $"{a.FirstName} {a.LastName}",
                    CountOfCopies = a.Books.Select(b => b.Copies).Sum()
                })
                .OrderByDescending(c => c.CountOfCopies)
                .ToList();

            var builder = new StringBuilder();

            foreach (var author in copiesByAuthor)
            {
                var info = $"{author.Name} - {author.CountOfCopies}";
                builder.AppendLine(info);
            }

            return builder.ToString().TrimEnd();
        }

        public static string GetTotalProfitByCategory(BookShopContext db)
        {
            var categories = db.Categories
                .Select(c => new
                {
                    Name = c.Name,
                    BooksProfit = c.CategoryBooks.Sum(b => b.Book.Price * b.Book.Copies)
                })
                .OrderByDescending(c => c.BooksProfit)
                .ThenBy(c => c.Name)
                .ToList();

            var builder = new StringBuilder();

            foreach (var category in categories.OrderByDescending(c => c.BooksProfit))
            {
                
                var info = $"{category.Name} ${category.BooksProfit:f2}";
                builder.AppendLine(info);
            }

            return builder.ToString().TrimEnd();
        }

        public static string GetMostRecentBooks(BookShopContext db)
        {
            var categories = db.Categories
                .OrderBy(c => c.Name)
                .Select(c => new
                {
                    c.Name,
                    Books = c.CategoryBooks.Select(cb => cb.Book)
                            .OrderByDescending(b => b.ReleaseDate).Take(3)
                })
                .ToList();

            var builder = new StringBuilder();

            foreach (var category in categories)
            {
                builder.AppendLine($"--{category.Name}");

                foreach (var book in category.Books)
                {
                    builder.AppendLine($"{book.Title} ({book.ReleaseDate.Value.Year})");
                }
            }
            return builder.ToString().TrimEnd();
        }

        public static void IncreasePrices(BookShopContext db)
        {
            var books = db.Books
                .Where(b => b.ReleaseDate.Value.Year < 2010);

            foreach (var b in books)
            {
                b.Price += 5m;
            }

            db.SaveChanges();
        }

        public static int RemoveBooks(BookShopContext db)
        {
            var books = db.Books
                .Where(b => b.Copies < 4200);
            int result = books.Count();

            db.Books.RemoveRange(books);
            db.SaveChanges();

            return result;
        }
    }
}
