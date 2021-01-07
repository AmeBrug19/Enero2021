using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Configuration;
using System.Net.Http;

using System.Threading.Tasks;
using CSharp_Alquiler_bcknd.Entidades;
using CSharp_Alquiler_bcknd.Entidades.context;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Protocols;
using System.Net;
using Microsoft.AspNetCore.Http;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSharp_Alquiler_bcknd.Controllers
{
    [Route("api/[controller]")]
    public class AutosController : Controller
    {
        private readonly appDBContext context;        

        public AutosController(appDBContext context)
        {
            this.context = context;
        }


        // GET: api/<controller>
        [HttpGet] //CONSULTA datos de la BD
        public IEnumerable<Autos> Get()
        {
            return context.AUTOS_TB.ToList();
        }


        [HttpGet("{estado}")] // realizar consulta por ESTADO Auto
            public Autos GetByID(string estado)
            {
                int cant = context.AUTOS_TB.Count(p => p.tipo_estado == estado);
                for (int i = 0; i < cant; i++)
                {
                    var Auto = context.AUTOS_TB.FirstOrDefault(p => p.tipo_estado == estado);   
                    return Auto;
                }
                return null;


                //var auto = context.AUTOS_TB.Find<Autos>(p => p.tipo_estado == estado).FirstOrDefault();
                // return context.AUTOS_TB.Find<Autos>(p => p.tipo_estado == estado);
            }
            
    


        // POST api/<controller>
        [HttpPost] //REGISTRA autos en la BD
        public ActionResult Post([FromBody]Autos autos)
        {
            try
            {
                context.AUTOS_TB.Add(autos);
                context.SaveChanges();
                return Ok();
            }
            catch(Exception ex)
            {
                return BadRequest();
            }
            
        }

        // PUT api/<controller>/5
        [HttpPut("{id}")] //ACTUALIZA datos en la BD
        public ActionResult Put(string id, [FromBody]Autos autos)
        {
            if (autos.id_auto == id)
            {
                context.Entry(autos).State = EntityState.Modified;
                context.SaveChanges();
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }

        // DELETE api/<controller>/5
        [HttpDelete("{id}")] //DELETE elimina datos en la BD
        public void Delete(int id)
        {
        }
    }
}
