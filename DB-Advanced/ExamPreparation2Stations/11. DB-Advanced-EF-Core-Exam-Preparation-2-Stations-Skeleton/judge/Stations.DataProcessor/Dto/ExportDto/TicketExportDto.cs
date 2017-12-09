using System.Xml.Serialization;

namespace Stations.DataProcessor.Dto.ExportDto
{
    [XmlType("Ticket")]
    public class TicketExportDto
    {
        public string OriginStation { get; set; }

        public string DestinationStation { get; set; }

        public string DepartureTime { get; set; }
    }
}
