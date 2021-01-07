using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSharp_Alquiler_bcknd.Entidades.context
{
    public class appDBContext : DbContext
    {
        public appDBContext(DbContextOptions<appDBContext> options) : base(options)
        {
        }


        public DbSet<Autos> AUTOS_TB { get; set; }

        public DbSet<Alquiler> ALQUILER_TB { get; set; }

    }
}
