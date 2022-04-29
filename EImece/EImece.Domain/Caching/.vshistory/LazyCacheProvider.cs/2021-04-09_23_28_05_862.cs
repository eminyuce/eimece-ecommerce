﻿using LazyCache;
using NLog;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;

namespace EImece.Domain.Caching
{
    public class MemoryCacheProvider<T> 
    {
        protected static readonly Logger Logger = LogManager.GetCurrentClassLogger();
        private readonly IAppCache _lazyCache = new CachingService();
    

        public bool Get<T>(string key, out T value)
        {
            if (AppConfig.IsCacheActive)
            {
                key = "Memory:" + key;
                value = default;
                return true;
            }
            else
            {
                value = default(T);
                return false;
            }
        }

        public override void Set<T>(string key, T value)
        {
            if (AppConfig.IsCacheActive)
            {
                key = "Memory:" + key;
                    Set<T>(key, value, CacheDuration);
            }
        }

        public override void Set<T>(string key, T value, int duration)
        {
            if (AppConfig.IsCacheActive)
            {
                key = "Memory:" + key;
                if (value != null)
                {
                    _cache.(key, value, policy);
                }
            }
        }

        public override void Clear(string key)
        {
            _cache.Remove(key, CacheEntryRemovedReason.Removed);
        }

        public override IEnumerable<KeyValuePair<string, object>> GetAll()
        {
            List<string> cacheKeys = _cache.Select(kvp => kvp.Key).ToList();
            foreach (String key in cacheKeys)
            {
                yield return new KeyValuePair<string, object>(key, _cache[key]);
            }
        }

        public override void ClearAll()
        {
            List<string> cacheKeys = _cache.Select(kvp => kvp.Key).ToList();
            foreach (String key in cacheKeys)
            {
                Clear(key);
            }

            List<string> keys = new List<string>();

            IDictionaryEnumerator enumerator = System.Web.HttpRuntime.Cache.GetEnumerator();
            while (enumerator.MoveNext())
            {
                string key = (string)enumerator.Key;
                keys.Add(key);
            }

            foreach (string key in keys)
            {
                System.Web.HttpRuntime.Cache.Remove(key);
            }
        }
    }
}