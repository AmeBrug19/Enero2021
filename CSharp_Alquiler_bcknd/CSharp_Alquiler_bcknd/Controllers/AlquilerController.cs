using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using CSharp_Alquiler_bcknd.Entidades;
using CSharp_Alquiler_bcknd.Entidades.context;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSharp_Alquiler_bcknd.Controllers
{
    [Route("api/[controller]")]
    public class AlquilerController : Controller
    {

        private readonly appDBContext context;

        public AlquilerController(appDBContext context)
        {
            this.context = context;
        }


        [HttpGet] //GET consulta registros
        public IEnumerable<Alquiler> Get()
        {
            return context.ALQUILER_TB.ToList();
        }


        [HttpGet("{id}")] //realizar consulta por ID Cliente
        public Alquiler Get(string id)
        {
            var Cliente = context.ALQUILER_TB.FirstOrDefault(p => p.id_cliente == id);
            return Cliente;
        }



        // POST api/<controller>
        [HttpPost] //REGISTRAR Alquiler (Proc. Almacenado)
        public ActionResult Post([FromBody]Alquiler alquiler)
        {
            try
            {
                context.ALQUILER_TB.Add(alquiler);
                context.SaveChanges();
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest();
            }

        }



        /*// PUT api/<controller>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }*/
    }
}
