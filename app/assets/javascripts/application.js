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
//= require_tree .

propublica.views.stateSelect = propublica.View.extend({

  cssClass : "state-select",
  tag: "select",

  render : function() {
  	$(".state-select").change(function () {
      var val = this.value;
      window.location = RAILS_ROOT + "?state=" + val;
    });
  }

})


propublica.views.filterPoliticians = propublica.View.extend({

  cssClass : "politician-select",
  tag: "select",

  render : function() {
      $(".politician-select").change(function () {                                                                                                                                                               
          var params = $(".politician-select").map(function()
                                              { return this.name+"="+this.value; }
                                             ).toArray();                                             
          params = params.join("&");
          window.location = POLITICIANS_PATH + "?" + params;
    });
  }

})
