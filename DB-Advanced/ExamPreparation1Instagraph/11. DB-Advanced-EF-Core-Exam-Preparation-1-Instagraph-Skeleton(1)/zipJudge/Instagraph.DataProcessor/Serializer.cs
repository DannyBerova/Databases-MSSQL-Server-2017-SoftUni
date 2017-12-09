using System;

using Instagraph.Data;
using System.Linq;
using AutoMapper.QueryableExtensions;
using Instagraph.DataProcessor.Dto.Export;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Xml.Linq;

namespace Instagraph.DataProcessor
{
    public class Serializer
    {
        public static string ExportUncommentedPosts(InstagraphContext context)
        {
            var posts = context.Posts
                .Where(p => p.Comments.Count() == 0)
                .OrderBy(p => p.Id)
                .ProjectTo<UncommentedPostDto>()
                .ToArray();

            var jsonString = JsonConvert.SerializeObject(posts, Formatting.Indented);
            return jsonString;
        }

        public static string ExportPopularUsers(InstagraphContext context)
        {
            var users = context.Users
                .Where(u => u.Posts
                    .Any(p => p.Comments
                        .Any(c => u.Followers
                            .Any(f => f.FollowerId == c.UserId))))
                .OrderBy(u => u.Id)
                .ProjectTo<PopularUserDto>()
                .ToArray();

            var jsonString = JsonConvert.SerializeObject(users, Formatting.Indented);
            return jsonString;
        }

        public static string ExportCommentsOnPosts(InstagraphContext context)
        {
            var users = context.Users
                .Select(u => new
                {
                    Username = u.Username,
                    PostCommentsCount = u.Posts.Select(p => p.Comments.Count).ToArray()
                });

            var userDtos = new List<UserMostCommentedPostDto>();

            var xDoc = new XDocument();
            xDoc.Add(new XElement("users"));

            foreach (var user in users)
            {
                int mostComments = 0;

                if (user.PostCommentsCount.Any())
                {
                    mostComments = user.PostCommentsCount.OrderByDescending(c => c).First();
                }

                var userDto = new UserMostCommentedPostDto()
                {
                    Username = user.Username,
                    MostComments = mostComments
                };

                userDtos.Add(userDto);
            }

            userDtos = userDtos
                .OrderByDescending(ud => ud.MostComments)
                .ThenBy(ud => ud.Username)
                .ToList();

            foreach (var ud in userDtos)
            {
                xDoc.Root.Add(new XElement("user",
                        new XElement("Username", ud.Username),
                        new XElement("MostComments", ud.MostComments)));
            }

            string result = xDoc.ToString();
            return result;
        }
    }
}

