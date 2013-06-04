<link href="js/select2.css" rel="stylesheet"/>
<script src="js/select2.js"></script>
<script id="script_tool">
    $(document).ready(function() { $("#tool").select2({ 
      placeholder: "start typing a name",
      minimumInputLength: 1,
      data:[{id:0,text:'enhancement'},{id:1,text:'bug'},{id:2,text:'duplicate'},{id:3,text:'invalid'},{id:4,text:'wontfix'}],
      width: 'resolve' });       
    });
</script>