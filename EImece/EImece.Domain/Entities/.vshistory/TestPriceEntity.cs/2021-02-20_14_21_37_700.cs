﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EImece.Domain.Entities
{
    public class TestPriceEntity
    {
        [Key]
        private int Id { set; get; }
        private decimal Price { set; get; }
        private decimal Discount { set; get; }
    }
}
