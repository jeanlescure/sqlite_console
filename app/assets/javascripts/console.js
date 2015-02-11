var table_template;
var result_template;
var data;

$(function(){
  function get_data_and_render(){
    $.get('/data.json',function(d){
      data = d;
      $('#dbData').html(table_template({data: data}));
    });
  }
  $.get('/t?t=result',function(ejs){
    result_template = _.template(ejs);
  });
  $.get('/t?t=table',function(ejs){
    table_template = _.template(ejs);
    
    $('#sqliteForm').bind('submit', function(e){
      e.preventDefault();
      $('#sqliteButts').hide();
      $('#sqliteStatus').attr('class','');
      $('#sqliteStatus').html('running sentence...');
      
      $.post('/x', {sentence: $('#sqliteSentence').val()}, function(r){
        $('#sqliteButts').show();
        if (r.result){
          $('#sqliteStatus').html('success!');
          $('#sqliteStatus').addClass('text-success');
          
          if (r.data.length > 0){
            $('#sqliteModalContent').html(result_template({keys: r.keys, data: r.data}));
            $('#sqliteModal').modal('show');
          }
        }else{
          $('#sqliteStatus').html('error: ' + r.message);
          $('#sqliteStatus').addClass('text-danger');
        }
        
        get_data_and_render();
      }, "json");
    });
    
    $('#sqliteReset').click(function(e){
      e.preventDefault();
      
      if (confirm("WARNING! This action cannot be undone!\r\nDo you wish to continue?")){        
        $('#sqliteButts').hide();
        $('#sqliteStatus').attr('class','');
        $('#sqliteStatus').html('running sentence...');
        $.get('/kill', function(){
          $('#sqliteButts').show();
          $('#sqliteStatus').html('success!');
          $('#sqliteStatus').addClass('text-success');
          
          get_data_and_render();
        });
      }
    });
    
    get_data_and_render();
  });
});