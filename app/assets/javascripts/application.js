// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//
//= require best_in_place
//= require best_in_place.purr
//
//= require_tree .
//

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

	$('.js-like').on('ajax:success', function (data) {
		$(this).parent().hide();
		$(this).parent().siblings('.js-dislike').show();

		return false;
	})

	$('.js-dislike').on('ajax:success', function (data) {
		$(this).parent().hide();
		$(this).parent().siblings('.js-like').show();
		return false;
	})

	$('.js-bookmark').on('ajax:success', function (data) {
		$(this).parent().hide();
		$(this).parent().siblings('.js-remove-bookmark').show();
		return false;
	})
	
	$('.js-remove-bookmark').on('ajax:success', function (data) {
		$(this).parent().hide();
		$(this).parent().siblings('.js-bookmark').show();
		return false;
	})
});
