﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace EImece.Controllers
{
    public class UnderConstructionController : Controller
    {
        // GET: UnderConstruction
        public ActionResult Index()
        {
            var response = filterContext.HttpContext.Response;
            response.StatusCode = (int)HttpStatusCode.ServiceUnavailable;
            response.TrySkipIisCustomErrors = true;
            return View();
        }
    }
}