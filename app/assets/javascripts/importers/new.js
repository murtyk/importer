$('#new_importer_form').submit(function() {
  if ($('#importer_form_file').val() == ""){
    alert("Please select a file");
    return false;
  }
});
