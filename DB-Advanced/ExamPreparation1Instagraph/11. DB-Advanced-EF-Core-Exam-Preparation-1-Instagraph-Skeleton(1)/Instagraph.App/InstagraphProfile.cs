using AutoMapper;
using Instagraph.DataProcessor.Dto.Export;
using Instagraph.DataProcessor.Dto.Import;
using Instagraph.Models;

namespace Instagraph.App
{
    public class InstagraphProfile : Profile
    {
        public InstagraphProfile()
        {
            CreateMap<PictureDto, Picture>();

            CreateMap<Post, UncommentedPostDto>()
                .ForMember(dto => dto.Picture, pp => pp.MapFrom(p => p.Picture.Path))
                .ForMember(dto => dto.User, u => u.MapFrom(p => p.User.Username));

            CreateMap<User, PopularUserDto>()
                .ForMember(dto => dto.Followers, f => f.MapFrom(u => u.Followers.Count));


        }
    }
}
