using System;
using System.Text;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;
using System.IO;
using ValidationContext = System.ComponentModel.DataAnnotations.ValidationContext;

using Newtonsoft.Json;
using AutoMapper;

using Instagraph.Data;
using Instagraph.Models;
using Instagraph.DataProcessor.Dto.Import;

namespace Instagraph.DataProcessor
{
    public class Deserializer
    {
        public static string ImportPictures(InstagraphContext context, string jsonString)
        {
            var sb = new StringBuilder();

            var deserializedPictures = JsonConvert.DeserializeObject<PictureDto[]>(jsonString);

            var validPictures = new List<Picture>();

            foreach (var pictureDto in deserializedPictures)
            {
                if (!IsValid(pictureDto))
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var size = pictureDto.Size;
                var path = pictureDto.Path;

                var isPathExists = validPictures.Any(p => p.Path == path);
                if (size <= 0 || isPathExists)
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var picture = Mapper.Map<Picture>(pictureDto);

                validPictures.Add(picture);
                sb.AppendLine($"Successfully imported Picture {pictureDto.Path}.");
            }

            context.Pictures.AddRange(validPictures);
            context.SaveChanges();

            var result = sb.ToString();
            return result;
        }

        public static string ImportUsers(InstagraphContext context, string jsonString)
        {
            var sb = new StringBuilder();

            var deserializedUsers = JsonConvert.DeserializeObject<UserDto[]>(jsonString);

            var validFollowers = new List<User>();

            foreach (var userDto in deserializedUsers)
            {
                if (!IsValid(userDto))
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var username = userDto.Username;
                var usernamealreadyExists = validFollowers.Any(u => u.Username == username);

                var profilePicturePath = userDto.ProfilePicture;
                var validProfilePicture = context.Pictures.Any(p => p.Path == profilePicturePath);

                if (usernamealreadyExists || !validProfilePicture)
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var password = userDto.Password;
                var profilePicture = context.Pictures.SingleOrDefault(p => p.Path == profilePicturePath);

                var user = new User
                {
                    Username = username,
                    Password = password,
                    ProfilePictureId = profilePicture.Id
                };

                validFollowers.Add(user);
                sb.AppendLine($"Successfully imported User {userDto.Username}.");
            }

            context.Users.AddRange(validFollowers);
            context.SaveChanges();

            var result = sb.ToString();
            return result;
        }

        public static string ImportFollowers(InstagraphContext context, string jsonString)
        {
            var sb = new StringBuilder();

            var deserializedUsersFollowers = JsonConvert.DeserializeObject<UserFollowerDto[]>(jsonString);

            var validFollowers = new List<UserFollower>();

            foreach (var userFollowerDto in deserializedUsersFollowers)
            {
                if (!IsValid(userFollowerDto))
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var usernameUser = userFollowerDto.User;
                var usernameFollower = userFollowerDto.Follower;
                int? userId = context.Users.FirstOrDefault(u => u.Username == usernameUser)?.Id;
                int? followerId = context.Users.FirstOrDefault(u => u.Username == usernameFollower)?.Id;

                //var userUser = context.Users.SingleOrDefault(u => u.Username == usernameUser);
                //var userFollower = context.Users.SingleOrDefault(u => u.Username == usernameFollower);

                if (userId == null || followerId == null)
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                //if (userId == followerId)
                //{
                //    sb.AppendLine("Error: Invalid data.");
                //    continue;
                //}

                bool alreadyFollowed = validFollowers.Any(f => f.UserId == userId && f.FollowerId == followerId);

                if (alreadyFollowed)
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var userFollower = new UserFollower
                {
                    UserId = userId.Value,
                    FollowerId = followerId.Value
                };

                validFollowers.Add(userFollower);
                sb.AppendLine($"Successfully imported Follower {userFollowerDto.Follower} to User {userFollowerDto.User}.");
            }

            context.UsersFollowers.AddRange(validFollowers);
            context.SaveChanges();

            var result = sb.ToString();
            return result;
        }

        public static string ImportPosts(InstagraphContext context, string xmlString)
        {
            var sb = new StringBuilder();

            var serializer = new XmlSerializer(typeof(PostDto[]), new XmlRootAttribute("posts"));
            var deserializedPosts = (PostDto[])serializer.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes(xmlString)));

            var validPosts = new List<Post>();

            foreach (var postDto in deserializedPosts)
            {
                if (!IsValid(postDto))
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var user = context.Users.SingleOrDefault(u => u.Username == postDto.Username);
                var picture = context.Pictures.SingleOrDefault(p => p.Path == postDto.PicturePath);

                if (user == null || picture == null)
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var post = new Post
                {
                    Caption = postDto.Caption,
                    User = user,
                    Picture = picture
                };

                validPosts.Add(post);
                sb.AppendLine($"Successfully imported Post {postDto.Caption}.");
            }

            context.Posts.AddRange(validPosts);
            context.SaveChanges();

            var result = sb.ToString();
            return result;
        }
        //{
        //    var sb = new StringBuilder();

        //    var xDoc = XDocument.Parse(xmlString);
        //    var xmlElements = xDoc.Root.Elements();

        //    var validPosts = new List<Post>();

        //    foreach (var el in xmlElements)
        //    {
        //        var caption = el.Element("caption")?.Value;
        //        var username = el.Element("user")?.Value;
        //        var picturePath = el.Element("picture")?.Value;

        //        var inputDataIsInvalid = String.IsNullOrWhiteSpace(caption)
        //                               || String.IsNullOrWhiteSpace(username)
        //                               || String.IsNullOrWhiteSpace(picturePath);

        //        if (inputDataIsInvalid)
        //        {
        //            sb.AppendLine("Error: Invalid data.");
        //            continue;
        //        }

        //        int? userId = context.Users.FirstOrDefault(u => u.Username == username)?.Id;
        //        int? pictureId = context.Pictures.FirstOrDefault(p => p.Path == picturePath)?.Id;

        //        if (userId == null || pictureId == null)
        //        {
        //            sb.AppendLine("Error: Invalid data.");
        //            continue;
        //        }

        //        var post = new Post
        //        {
        //            Caption = caption,
        //            UserId = userId.Value,
        //            PictureId = pictureId.Value
        //        };

        //        validPosts.Add(post);
        //        sb.AppendLine($"Successfully imported Post {caption}.");
        //    }

        //    context.Posts.AddRange(validPosts);
        //    context.SaveChanges();

        //    string result = sb.ToString();
        //    return result;
        //}

        public static string ImportComments(InstagraphContext context, string xmlString)
        {
            var sb = new StringBuilder();

            var serializer = new XmlSerializer(typeof(CommentDto[]), new XmlRootAttribute("comments"));
            var deserializedComments = (CommentDto[])serializer.Deserialize(new StringReader(xmlString));

            var validComments = new List<Comment>();

            foreach (var commentDto in deserializedComments)
            {
                if (!IsValid(commentDto))
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                //var user = context.Users.SingleOrDefault(u => u.Username == commentDto.User);
                int? userId = context.Users.SingleOrDefault(u => u.Username == commentDto.User)?.Id;
                var post = context.Posts.SingleOrDefault(p => p.Id == commentDto.Post.Id);

                if (userId == null || post == null)
                {
                    sb.AppendLine("Error: Invalid data.");
                    continue;
                }

                var comment = new Comment
                {
                    Content = commentDto.Content,
                    UserId = userId.Value,
                    Post = post
                };

                validComments.Add(comment);
                sb.AppendLine($"Successfully imported Comment {commentDto.Content}.");
            }

            context.Comments.AddRange(validComments);
            context.SaveChanges();

            var result = sb.ToString();
            return result;
        }
        //{
        //    var sb = new StringBuilder();

        //    var xDoc = XDocument.Parse(xmlString);
        //    var xmlElements = xDoc.Root.Elements();

        //    var validComments = new List<Comment>();

        //    foreach (var el in xmlElements)
        //    {
        //        var content = el.Element("content")?.Value;
        //        var userName = el.Element("user")?.Value;
        //        var postIdAsString = el.Element("post")?.Attribute("id")?.Value;

        //        var inputDataIsInvalid = String.IsNullOrWhiteSpace(content)
        //                              || String.IsNullOrWhiteSpace(userName)
        //                              || String.IsNullOrWhiteSpace(postIdAsString);

        //        if (inputDataIsInvalid)
        //        {
        //            sb.AppendLine("Error: Invalid data.");
        //            continue;
        //        }

        //        int postId = int.Parse(postIdAsString);
        //        int? userId = context.Users.SingleOrDefault(p => p.Username == userName)?.Id;
        //        var postExists = context.Posts.Any(p => p.Id == postId);

        //        if (userId == null || !postExists)
        //        {
        //            sb.AppendLine("Error: Invalid data.");
        //            continue;
        //        }

        //        var comment = new Comment
        //        {
        //            Content = content,
        //            UserId = userId.Value,
        //            PostId = postId
        //        };

        //        validComments.Add(comment);
        //        sb.AppendLine($"Successfully imported Comment {content}.");
        //    }

        //    context.Comments.AddRange(validComments);
        //    context.SaveChanges();

        //    var result = sb.ToString();
        //    return result;
        //}

        private static bool IsValid(object obj)
        {
            var validationContext = new ValidationContext(obj);
            var validationResults = new List<ValidationResult>();

            var isValid = Validator.TryValidateObject(obj, validationContext, validationResults, true);
            return isValid;
        }
    }
}
