using System;
using System.Collections.Generic;
using System.Text;

namespace Instagraph.DataProcessor.Dto.Export
{
    public class UserMostCommentedPostDto
    {
        public string Username { get; set; }

        public int MostComments { get; set; }
    }
}
