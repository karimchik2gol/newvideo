// SET CHECKBOX VALUE
$("input[type='checkbox']").change(function(){
	$(this).parent().find("input[type='hidden']").val($(this).is(":checked"));
})

$(".change-checkbox").click(function(){
	$(this).find("input[type='checkbox']").trigger("change");
})

function getCSRFToken(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
}

$(document).ready(function() {
	$(".latest-categories").click(function(e) {
		e.preventDefault();
		ids = $(this).data("categories").split(",");
		for(i = 0; i < ids.length; i ++) {
			checkbox = $("input[value='" + ids[i] + "']");
			checkbox.trigger("click");
		}
	})
})