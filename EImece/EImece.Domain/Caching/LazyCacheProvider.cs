﻿using LazyCache;
using Microsoft.Extensions.Caching.Memory;
using NLog;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;

namespace EImece.Domain.Caching
{
    public class LazyCacheProvider  : IEimeceCacheProvider
    {
        protected static readonly Logger Logger = LogManager.GetCurrentClassLogger();
        private readonly IAppCache _lazyCache = new CachingService();
        private static List<string> allCacheKeys = new List<string>();
        public void Clear(string key)
        {
            _lazyCache.Remove(key);
        }

        public void ClearAll()
        {
            foreach (var key in allCacheKeys)
            {
                _lazyCache.Remove(key);
            }
        }

        public bool Get<T>(string key, out T value)
        {
            if (AppConfig.IsCacheActive)
            {
                var keyNew = "Memory:" + key;
                T t = _lazyCache.Get<T>(keyNew);
                if (t == null)
                {
                    value = default(T);
                    return false;
                }
                value = t;
                return true;
            }
            else
            {
                value = default(T);
                return false;
            }
        }
       
        public void Set<T>(string key, T value, int duration)
        {
            if (AppConfig.IsCacheActive)
            {
                var keyNew = "Memory:" + key;
                MemoryCacheEntryOptions options = new MemoryCacheEntryOptions();
                options.AbsoluteExpiration = DateTime.Now.AddSeconds(duration);
                options.SlidingExpiration = TimeSpan.FromSeconds(duration);
                _lazyCache.Add(keyNew, value, options);
                allCacheKeys.Add(keyNew);
            }
        }
    }
}