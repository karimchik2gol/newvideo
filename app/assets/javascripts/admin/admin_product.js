jQuery(document).ready(function() {
  var link, association, content, nested_name;

  $(".dropify-clear").click(function(){
    par = $(this).parents(".dropify-wrapper").parent();
    par.hide();
    par.find(".dropify").val("");
    par.find("input[type='hidden']:last").val("1");
  })

  function beautiful_file_upload(){
    $(".dropify:last").removeAttr("data-default-file");
    start_dropify(); // Calls from partial fileupload 
  }

  function add_fields(classname) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(classname).append(content.replace(regexp, new_id));
  }

  function append_new_item() {
    if(nested_name == "Add Video" && $(".videos-container input[type='text']").length < 3) {
      add_fields(".videos-container");
    }
    else if(nested_name == "Add Image" && $(".dropify").length < 10) {
      add_fields(".portfolioContainer .gallery");
      beautiful_file_upload();
    }
  }

  $(document).on("click", ".link_to_add_fields_images", function(e){
    e.preventDefault();
    link = $(this);
    association = $(this).data("association");
    content = $(this).data("content");
    nested_name = $(this).text();
    append_new_item();
  });

  function activate_errors(){
    $(".page-errors").each(function(){
      name = $(this).data("name");
      errors = $(this).data("errors");
      add_error();
    });
  }

  //activate_errors();
});