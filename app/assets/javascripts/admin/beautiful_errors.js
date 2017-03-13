var errors = [], name;
name = $(".page-errors").data("name");
errors = $(".page-errors").data("errors");
//$(".page-errors").remove();

function create_error(val){
	return "<li class='parsley-required'>" + val + "</li>";
}

function how_many_errors_user_did(value){
	allErrors = "";
	$.each(value, function(index, val){
		allErrors += create_error(val);
	});
	return allErrors;
}

function add_error(){
	$.each(errors, function(key, value) {
		if(value.length > 0){
			finder = "[name='" + name + "[" + key + "]']"
		    inpt = $(":input" + finder);

		    par = inpt.parents(".col-sm-9");
		    if(!par.length) { par = inpt.closest(".row")}
		    console.log(inpt)
			console.log(par)
		    inpt.parents(".form-group").addClass("has-error has-feedback");
			// HTML starts here
			// Test if element exists and it's not a hidden element
			if(inpt.length && inpt.attr("type") != "hidden"){ 
				span = "<span class='glyphicon glyphicon-remove form-control-feedback'></span>";
				ul = "<ul id='parsley-id-4' class='parsley-errors-list filled'>";
				ul += how_many_errors_user_did(value);
			    ul += "</ul>";

				par.append(span, ul); // Appends content
			}
		}
	});
}

function set_options(){
	name = $(".page-errors").data("name");
  	errors = $(".page-errors").data("errors");
  	$(".page-errors").remove();
}

add_error();