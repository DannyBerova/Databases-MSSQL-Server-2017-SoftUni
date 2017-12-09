using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Instagraph.DataProcessor.Dto.Import
{
    [XmlType("post")]
    public class PostCommentDto
    {
        [Required]
        [XmlAttribute("id")]
        public int Id { get; set; }
    }
}
