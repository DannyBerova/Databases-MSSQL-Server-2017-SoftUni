using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Instagraph.Models
{
    public class Post
    {
        //        •	Id – an integer, Primary Key
        //•	Caption – a string
        //•	UserId – an integer
        //•	User – a User
        //•	PictureId – an integer
        //•	Picture – a Picture
        //•	Comments – a Collection of type Comment
        public Post()
        {
            Comments = new HashSet<Comment>();
        }

        public int Id { get; set; }

        [Required]
        public string Caption { get; set; }

        public int UserId { get; set; }
        [Required]
        public User User { get; set; }
       
        public int PictureId { get; set; }
        [Required]
        public Picture Picture { get; set; }

        public ICollection<Comment> Comments { get; set; }

    }
}