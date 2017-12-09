using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Instagraph.Models
{
    public class User
    {
        //        •	Id – an integer, Primary Key
        //•	Username – a string with max length 30, Unique
        //•	Password – a string with max length 20
        //•	ProfilePictureId – an integer
        //•	ProfilePicture – a Picture
        //•	Followers – a Collection of type UserFollower
        //•	UsersFollowing – a Collection of type UserFollower
        //•	Posts – a Collection of type Post
        //•	Comments – a Collection of type Comment
        public User()
        {
            Followers = new HashSet<UserFollower>();
            UsersFollowing = new HashSet<UserFollower>();
            Posts = new HashSet<Post>();
            Comments = new HashSet<Comment>();
        }

        public int Id { get; set; }

        [Required]
        [MaxLength(30)]
        //unique - make alternate key with fluentApi
        public string Username { get; set; }

        [Required]
        [MaxLength(20)]
        public string Password { get; set; }

        [Required]
        public int ProfilePictureId { get; set; }
        [Required]
        public Picture ProfilePicture { get; set; }

        public ICollection<UserFollower> Followers { get; set; }

        public ICollection<UserFollower> UsersFollowing { get; set; }

        public ICollection<Post> Posts { get; set; }

        public ICollection<Comment> Comments { get; set; }




    }
}