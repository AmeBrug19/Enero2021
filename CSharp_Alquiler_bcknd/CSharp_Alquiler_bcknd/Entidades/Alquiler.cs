using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace CSharp_Alquiler_bcknd.Entidades
{
    public class Alquiler
    {
        [Key]
        public int id_alquiler { get; set; }

        public string id_cliente { get; set; }

        public string nombre_cliente { get; set; }

        public string apellido_cliente { get; set; }

        public string telefono_cliente { get; set; }

        public string id_auto { get; set; }
    }
}
