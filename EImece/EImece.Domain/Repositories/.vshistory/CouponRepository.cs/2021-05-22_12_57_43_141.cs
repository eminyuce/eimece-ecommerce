﻿using EImece.Domain.DbContext;
using EImece.Domain.Entities;
using EImece.Domain.Repositories.IRepositories;
using NLog;
using System;
using System.Linq;

namespace EImece.Domain.Repositories
{
   public class CouponRepository : BaseEntityRepository<Coupon>, ICouponRepository
    {
        protected static readonly Logger Logger = LogManager.GetCurrentClassLogger();

        public CouponRepository(IEImeceContext dbContext) : base(dbContext)
        {
        }
        public Coupon GetCouponByCode(string code)
        {
            throw new NotImplementedException();
        }
    }
}
