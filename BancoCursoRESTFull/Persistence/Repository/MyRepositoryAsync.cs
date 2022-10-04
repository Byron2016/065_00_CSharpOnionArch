using Application.Interfaces;
using Ardalis.Specification.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Repository
{
    public class MyRepositoryAsync<T> : RepositoryBase<T>, IRepositoryAsync<T> where T: class
    {
        private readonly ApplicationDBContext _dBContext;

        public MyRepositoryAsync(ApplicationDBContext dBContext) : base(dBContext)
        {
            _dBContext = dBContext;
        }
    }
}
