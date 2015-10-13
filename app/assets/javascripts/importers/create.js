$(window).load(function() {
  var import_status_id = $('#page_data').data('import-status-id');
  if (import_status_id == null){
    return;
  }
  var processing = true;
  var href  = '/import_statuses/' + import_status_id;

  console.log("fetching importer status");
  console.log("href: " + href);

  jQuery.ajaxSetup({async:false});
  interval = setInterval(function(){
    $.get(href, function(data){
      console.log(data);
      // console.log(data['count_succeeded']);
      $('#count_succeeded').html(data['count_succeeded']);
      $('#count_failed').html(data['count_failed']);
      processing = data['status'] != 'finished';
    }, "json")
    .fail(function(jqXHR, textStatus, errorThrown){
      alert("error in importer " + textStatus + errorThrown);
    });

    if (!processing) {
      clearInterval(interval);
      jQuery.ajaxSetup({async:true});
      $("body").css("cursor", "default");
      location.href = href;
    }
  }, 1000);
});
