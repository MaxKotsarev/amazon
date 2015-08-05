// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require owl.carousel


var ready;
ready = function() {
  $(".owl-carousel").owlCarousel({
    navigation : true, // Show next and prev buttons
    slideSpeed : 300,
    paginationSpeed : 400,
    singleItem:true, 
    navigationText: ["<span class='glyphicon glyphicon-chevron-left'></span>","<span class='glyphicon glyphicon-chevron-right'></span>"]
  });

  if($(".checkbox-use-bill-address").is(":checked")) {
  	$(".ship-address-form-fields").addClass("hidden");
  } 

  $('.checkbox-use-bill-address').change(function() {
	$(".ship-address-form-fields").toggleClass("hidden");               
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);