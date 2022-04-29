﻿using System;
using System.Globalization;

namespace EImece.Domain.Helpers
{
    public static class CurrencyHelper
    {
        private const string CulturaInfoName = "tr-TR";

        public static string CurrencySign(this decimal price)
        {
            var cultureInfo = new CultureInfo(CulturaInfoName);
            //return price.ToString("C");
            var price2 = decimal.Round(price, 2, MidpointRounding.AwayFromZero);
            decimal v = System.Convert.ToDecimal(price2);
            if (v > 0)
            {
                return string.Format("{0} TL", v.ToString("#,##", cultureInfo));
            }
            else
            {
                return  "0 TL";
            }
        }

        public static string CurrencySign(this double price)
        {
            var cultureInfo = new CultureInfo(CulturaInfoName);
            decimal v = System.Convert.ToDecimal(price); 
            if (v > 0)
                return string.Format("{0} TL", v.ToString("#,##", cultureInfo));
            else
                return "0 TL";
        }

        public static string CurrencySign(this int price)
        {
            var cultureInfo = new CultureInfo(CulturaInfoName);
            decimal v = System.Convert.ToDecimal(price);

            if (v > 0)
            return string.Format("{0} TL", v.ToString("#,##", cultureInfo));
            else
                return "0 TL";
        }
    }
}