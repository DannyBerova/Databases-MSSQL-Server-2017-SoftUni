using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace Stations.DataProcessor.Dto.ExportDto
{
    [XmlType("Card")]
    public class CardExportDto
    {
        [XmlAttribute("name")]
        public string Name { get; set; }

        [XmlAttribute("type")]
        public string Type { get; set; }

        public TicketExportDto[] Tickets { get; set; }
    }
}
