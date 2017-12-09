using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Instagraph.Models
{
    public class Picture
    {
        //        •	Id – an integer, Primary Key
        //•	Path – a string
        //•	Size – a decimal
        //•	Users – a Collection of type User
        //•	Posts – a Collection of type Post

        public Picture()
        {
            Users = new HashSet<User>();
            Posts = new HashSet<Post>();
        }

        public int Id { get; set; }

        [Required]
        public string Path { get; set; }

        [Required]
        [Range(typeof(decimal), "0", "79228162514264337593543950335")]
        public decimal Size { get; set; }

        public ICollection<User> Users { get; set; }

        public ICollection<Post> Posts { get; set; }

    }
}
