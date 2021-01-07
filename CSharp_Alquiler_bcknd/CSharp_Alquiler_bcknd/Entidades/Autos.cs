using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace CSharp_Alquiler_bcknd.Entidades
{
    public class Autos
    {
        [Key]
        public string  id_auto { get; set; }

        public string marca_auto { get; set; }

        public string modelo_auto { get; set; }

        public int year_auto { get; set; }

        public string tipo_estado { get; set; }
        

    }
}
