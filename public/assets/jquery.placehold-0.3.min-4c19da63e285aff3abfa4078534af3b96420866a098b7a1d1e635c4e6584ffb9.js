/************************************************************************************
** jQuery Placehold version 0.3
** (cc) Jason Garber (http://sixtwothree.org and http://www.viget.com)
** Licensed under the CC-GNU GPL (http://creativecommons.org/licenses/GPL/2.0/)
*************************************************************************************/


(function(A){A.fn.placehold=function(D){var D=D||"placeholder",C=A.fn.placehold.is_supported();function B(){for(i=0;i<arguments.length;i++){arguments[i].toggle();}}return C?this:this.each(function(){var F=A(this),E=F.attr("placeholder");if(E){if(!F.val()||F.val()==E){F.addClass(D).val(E);}if(F.attr("type")=="password"){var G=A("<input />",{"class":F.attr("class")+" "+D,value:E});G.bind("focus.placehold",function(){B(F,G);F.focus();});F.bind("blur.placehold",function(){if(!F.val()){B(F,G);}});F.hide().after(G);}F.bind({"focus.placehold":function(){if(F.val()==E){F.removeClass(D).val("");}},"blur.placehold":function(){if(!F.val()){F.addClass(D).val(E);}}});F.closest("form").bind("submit.placehold",function(){if(F.val()==E){F.val("");}return true;});}});};A.fn.placehold.is_supported=function(){return"placeholder" in document.createElement("input");};})(jQuery);
