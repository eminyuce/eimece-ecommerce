﻿using Resources;
using System;
using System.ComponentModel.DataAnnotations;

namespace EImece.Models
{
    public class EditUserViewModel
    {
        public EditUserViewModel()
        {
        }

        // Allow Initialization with an instance of ApplicationUser:

        public string Id { get; set; }

        [Required]
        [Display(ResourceType = typeof(Resource), Name = nameof(Resource.FirstName))]
        public string FirstName { get; set; }

        [Required]
        [Display(ResourceType = typeof(Resource), Name = nameof(Resource.LastName))]
        public string LastName { get; set; }

        [Required]
        [Display(ResourceType = typeof(Resource), Name = nameof(Resource.Email))]
        public string Email { get; set; }

        public virtual String Role { get; set; }
        //you might want to implement jobs too, if you want to display them in your index view
    }
}